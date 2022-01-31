import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../business_logic/models/token.dart';

import '../../business_logic/contracts/erc1190_tradable.dart';
import '../../business_logic/models/collection.dart';

import '../../business_logic/contracts/erc1190_marketplace.dart';
import '../../logger/logger.dart';

class MarketplaceVM with ChangeNotifier {
  final _logger = getLogger("MarketplaceVM");

  late ERC1190Marketplace marketplaceContract;

  bool _marketplaceSmartContractLoaded = false;

  final ERC1190Tradable Function(String) loadERC1190SmartContract;

  final http.Client httpClient;

  final String ipfsUrl;

  final Future<void> Function() _connect;

  final bool Function() _connected;

  String _account;

  MarketplaceVM({
    required Future<void> Function() connect,
    required bool Function() connected,
    required String account,
    required this.loadERC1190SmartContract,
    required this.httpClient,
    required this.ipfsUrl,
  })  : _connect = connect,
        _connected = connected,
        _account = account;

  Future<void> connectToWallet() async {
    _logger.v("connectToWallet");

    await _connect();
  }

  bool get isConnected {
    _logger.v("isConnected");

    return _connected();
  }

  String get loggedAccount {
    _logger.v("loggedAccount");

    return _account;
  }

  set loggedAccount(final String account) {
    _logger.v("loggedAccount");

    if (_account != account) {
      _account = account;
      notifyListeners();
    }
  }

  set contract(final ERC1190Marketplace erc1190marketplace) {
    _logger.v("contract");

    if (!_marketplaceSmartContractLoaded) {
      marketplaceContract = erc1190marketplace;
      _marketplaceSmartContractLoaded = true;
      notifyListeners();
    }
  }

  void disableContract() {
    _logger.v("disableContract");
    _marketplaceSmartContractLoaded = false;
  }

  Future<List<Collection>> getCollections(
      [final String collectionOwner = ""]) async {
    _logger.v("getCollections");

    final collectionAddresses = <String>[];
    if (collectionOwner.isEmpty) {
      collectionAddresses.addAll(await marketplaceContract.allCollections);
    } else {
      collectionAddresses
          .addAll(await marketplaceContract.collectionsOf(collectionOwner));
    }

    final contracts = collectionAddresses.map(loadERC1190SmartContract);

    final collections = <Collection>[];

    for (final contract in contracts) {
      collections.add(Collection(
        address: contract.address,
        name: await contract.name,
        symbol: await contract.symbol,
        creator: await marketplaceContract.creatorOf(contract.address),
        availableTokens: await contract.availableTokens,
      ));
    }

    return collections;
  }

  Future<Collection> getCollection(final String collectionAddress) async {
    final contract = loadERC1190SmartContract(collectionAddress);
    return Collection(
      address: contract.address,
      name: await contract.name,
      symbol: await contract.symbol,
      creator: await marketplaceContract.creatorOf(contract.address),
      availableTokens: await contract.availableTokens,
    );
  }

  Future<Collection> deployNewCollection(
    final String name,
    final String symbol,
    final int royaltyForRental,
    final int royaltyForOwnershipTransfer, [
    final List<String> files = const [],
  ]) async {
    _logger.v("deployNewCollection");

    final contractAddress = await marketplaceContract.deployNewCollection(
      name,
      symbol,
      "https://ipfs.io/ipfs/",
    );
    _logger.i(
        "Deployed collection. Deployed smart contract at address: $contractAddress.");

    final collection = loadERC1190SmartContract(contractAddress);
    final creator = await marketplaceContract.creatorOf(contractAddress);

    for (final fileBlobURI in files) {
      final fileResponse = await httpClient.get(Uri.parse(fileBlobURI));
      final fileBytes = fileResponse.bodyBytes;

      final ipfsURI = Uri.parse("$ipfsUrl/api/v0/add");
      final request = http.MultipartRequest("POST", ipfsURI);
      request.files.add(http.MultipartFile.fromBytes("path", fileBytes));
      final ipfsResponse = await request.send();
      if (ipfsResponse.statusCode == 200) {
        _logger.i(
            "Deployed file with path = $fileBlobURI to IPFS. Minting the relative token.");
        final ipfsResponseBodyJson = json.decode(
          await ipfsResponse.stream.bytesToString(),
        ) as Map<String, dynamic>;
        final fileName = ipfsResponseBodyJson['Name'];
        final fileHash = ipfsResponseBodyJson['Hash'];
        final tokenId = await collection.mint(
          creator,
          "$fileHash?filename=$fileName",
          royaltyForRental,
          royaltyForOwnershipTransfer,
        );
        _logger.i("Minted token $tokenId");
      } else {
        _logger.e(
          "Could not deploy file with path = $fileBlobURI to IPFS. Not minting the relative token.",
        );
      }
    }

    return Collection(
      address: collection.address,
      name: await collection.name,
      symbol: await collection.symbol,
      creator: creator,
      availableTokens: await collection.availableTokens,
    );
  }

  Future<List<Token>> getTokens(final String collectionAddress) async {
    _logger.v("getTokens");

    final contract = loadERC1190SmartContract(collectionAddress);
    final tokenIds = List.generate(
      await contract.availableTokens,
      (index) => index + 1,
      growable: false,
    );

    final tokens = <Token>[];

    for (final tokenId in tokenIds) {
      tokens.add(
        Token(
          id: tokenId,
          uri: await contract.tokenURI(tokenId),
          ownershipLicensePrice: await contract.ownershipPriceOf(tokenId),
          creativeLicensePrice:
              await contract.creativeOwnershipPriceOf(tokenId),
          rentalPricePerSecond: await contract.rentalPriceOf(tokenId),
          owner: await contract.ownerOf(tokenId),
          creativeOwner: await contract.creativeOwnerOf(tokenId),
          rentedBy: await contract.rentersOf(tokenId),
          royaltyOwnershipTransfer:
              await contract.royaltyForOwnershipTransfer(tokenId),
          royaltyRental: await contract.royaltyForRental(tokenId),
          creativeLicenseRequests:
              await marketplaceContract.getCreativeLicenseTransferRequests(
            collectionAddress,
            tokenId,
          ),
          ownershipLicenseRequests:
              await marketplaceContract.getOwnershipLicenseTransferRequests(
            collectionAddress,
            tokenId,
          ),
        ),
      );
    }

    return tokens;
  }

  Future<void> rentAsset(
    final String collectionAddress,
    final int tokenId,
    final int rentExpirationDateInMillis,
  ) async {
    _logger.v("rentAsset");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.rentAsset(tokenId, rentExpirationDateInMillis);
  }

  Future<void> transferOwnershipLicense(
    final String collectionAddress,
    final int tokenId,
    final String to,
  ) async {
    _logger.v("transferOwnershipLicense");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.transferOwnershipLicense(tokenId, to);
  }

  Future<void> transferCreativeLicense(
    final String collectionAddress,
    final int tokenId,
    final String to,
  ) async {
    _logger.v("transferCreativeLicense");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.transferCreativeLicense(tokenId, to);
  }

  Future<void> setOwnershipLicensePrice(
    final String collectionAddress,
    final int tokenId,
    final double priceInEth,
  ) async {
    _logger.v("setOwnershipLicensePrice");

    final contract = loadERC1190SmartContract(collectionAddress);

    final priceInWei = (priceInEth * 1e18).toInt();

    await contract.setOwnershipLicensePrice(tokenId, priceInWei);
  }

  Future<void> setCreativeLicensePrice(
    final String collectionAddress,
    final int tokenId,
    final double priceInEth,
  ) async {
    _logger.v("setCreativeLicensePrice");

    final contract = loadERC1190SmartContract(collectionAddress);

    final priceInWei = (priceInEth * 1e18).toInt();

    await contract.setCreativeLicensePrice(tokenId, priceInWei);
  }

  Future<void> setRentalPrice(
    final String collectionAddress,
    final int tokenId,
    final double priceInEth,
  ) async {
    _logger.v("setRentalPrice");

    final contract = loadERC1190SmartContract(collectionAddress);

    final priceInWei = (priceInEth * 1e18).toInt();

    await contract.setRentalPrice(tokenId, priceInWei);
  }
}
