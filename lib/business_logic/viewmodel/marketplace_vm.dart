import 'dart:convert' show json;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../business_logic/models/token.dart';
import '../../business_logic/contracts/erc1190_tradable.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/contracts/erc1190_marketplace.dart';
import '../../logger/logger.dart';
import '../exception/ipfs_connection_exception.dart';

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

  final BigInt Function(double) toWei;

  final String Function(String) fixAddress;

  MarketplaceVM({
    required Future<void> Function() connect,
    required bool Function() connected,
    required String account,
    required this.loadERC1190SmartContract,
    required this.httpClient,
    required this.ipfsUrl,
    required this.toWei,
    required this.fixAddress,
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
      _account = fixAddress(account);
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

  Future<List<Collection>> getCollections([
    final String collectionOwner = "",
  ]) async {
    _logger.v("getCollections");

    final collectionAddresses = <String>[];
    if (collectionOwner.isEmpty) {
      collectionAddresses.addAll(await marketplaceContract.allCollections);
    } else {
      collectionAddresses.addAll(
        await marketplaceContract.collectionsOf(collectionOwner),
      );
    }

    final collections = <Collection>[];

    for (final collectionAddr in collectionAddresses) {
      collections.add(await getCollection(collectionAddr));
    }

    return collections;
  }

  Future<Collection> getCollection(final String collectionAddress) async {
    _logger.v("getCollection");
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

    try {
      await http.post(Uri.parse("$ipfsUrl/api/v0/id"));
      // ignore: avoid_catches_without_on_clauses
    } catch (connectionError) {
      throw const IpfsConnectionException();
    }

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
        await collection.mint(
          creator,
          "$fileHash?filename=$fileName",
          royaltyForRental,
          royaltyForOwnershipTransfer,
        );
        _logger.i("Token minted!");
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

  Future<List<Token>> getTokens(final Collection collection) async {
    _logger.v("getTokens");

    final contract = loadERC1190SmartContract(collection.address);
    final availableTokens = await contract.availableTokens;

    final tokens = <Token>[];

    for (int tokenId = 1; tokenId <= availableTokens; tokenId++) {
      tokens.add(await getToken(collection, tokenId));
    }

    return tokens;
  }

  Future<Token> getToken(final Collection collection, final int tokenId) async {
    _logger.v("getToken");
    final contract = loadERC1190SmartContract(collection.address);
    return Token(
      id: tokenId,
      uri: await contract.tokenURI(tokenId),
      ownershipLicensePrice: await contract.ownershipPriceOf(tokenId),
      creativeLicensePrice: await contract.creativeOwnershipPriceOf(tokenId),
      rentalPricePerSecond: await contract.rentalPriceOf(tokenId),
      owner: await contract.ownerOf(tokenId),
      creativeOwner: await contract.creativeOwnerOf(tokenId),
      rentedBy: await contract.rentersOf(tokenId),
      royaltyOwnershipTransfer:
          await contract.royaltyForOwnershipTransfer(tokenId),
      royaltyRental: await contract.royaltyForRental(tokenId),
      creativeLicenseRequests:
          await marketplaceContract.getCreativeLicenseTransferRequests(
        collection.address,
        tokenId,
      ),
      ownershipLicenseRequests:
          await marketplaceContract.getOwnershipLicenseTransferRequests(
        collection.address,
        tokenId,
      ),
      approvedByOwner: await contract.getApprovedOwnership(tokenId),
      approvedByCreator: await contract.getApprovedCreative(tokenId),
      collection: collection,
      expiredRenters: await expiredRenters(collection.address, tokenId),
      currentRenters: await notExpiredRenters(collection.address, tokenId),
    );
  }

  Future<List<Token>> getOwnedTokens() async {
    _logger.v("getOwnedTokens");
    final collectionAddresses = await marketplaceContract.allCollections;
    final ownedTokens = <Token>[];
    for (final addr in collectionAddresses) {
      final contract = loadERC1190SmartContract(addr);
      final collection = await getCollection(addr);
      final availableTokens = collection.availableTokens;
      for (int tokenId = 1; tokenId <= availableTokens; tokenId++) {
        if (_account == (await contract.ownerOf(tokenId))) {
          ownedTokens.add(await getToken(collection, tokenId));
        }
      }
    }
    return ownedTokens;
  }

  Future<List<Token>> getCreativeOwnedTokens() async {
    _logger.v("getCreativeOwnedTokens");
    final collectionAddresses = await marketplaceContract.allCollections;
    final creativeOwnedTokens = <Token>[];
    for (final addr in collectionAddresses) {
      final contract = loadERC1190SmartContract(addr);
      final collection = await getCollection(addr);
      final availableTokens = collection.availableTokens;
      for (int tokenId = 1; tokenId <= availableTokens; tokenId++) {
        if (_account == (await contract.creativeOwnerOf(tokenId))) {
          creativeOwnedTokens.add(await getToken(collection, tokenId));
        }
      }
    }
    return creativeOwnedTokens;
  }

  Future<List<Token>> getRentedTokens() async {
    _logger.v("getRentedTokens");
    final collectionAddresses = await marketplaceContract.allCollections;
    final currentDateTime = DateTime.now().millisecondsSinceEpoch;
    final rentedTokens = <Token>[];
    for (final addr in collectionAddresses) {
      final contract = loadERC1190SmartContract(addr);
      final collection = await getCollection(addr);
      final availableTokens = collection.availableTokens;
      for (int tokenId = 1; tokenId <= availableTokens; tokenId++) {
        final renters = await contract.rentersOf(tokenId);
        final endRentalDate =
            (await contract.getRentalDate(tokenId, _account)).toInt();
        if (renters.contains(_account) && endRentalDate > currentDateTime) {
          rentedTokens.add(await getToken(collection, tokenId));
        }
      }
    }
    return rentedTokens;
  }

  Future<BigInt> getRentalDate(
    final String collectionAddress,
    final int tokenId,
    final String renter,
  ) async {
    _logger.v("getRentalDate");

    final contract = loadERC1190SmartContract(collectionAddress);

    return await contract.getRentalDate(tokenId, renter);
  }

  Future<void> updateEndRentalDate(
    final String collectionAddress,
    final int tokenId,
    final int currentDate,
    final String renter,
  ) async {
    _logger.v("updateEndRentalDate");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.updateEndRentalDate(tokenId, currentDate, renter);
  }

  Future<List<String>> expiredRenters(
      final String collectionAddress, final int tokenId) async {
    _logger.v("expiredRenters");
    final contract = loadERC1190SmartContract(collectionAddress);

    final renters = await contract.rentersOf(tokenId);

    final date = DateTime.now().millisecondsSinceEpoch;

    final expired = <String>[];

    for (final renter in renters) {
      if ((await getRentalDate(collectionAddress, tokenId, renter)).toInt() <
          date) {
        expired.add(renter);
      }
    }
    return expired;
  }

  Future<List<String>> notExpiredRenters(
      final String collectionAddress, final int tokenId) async {
    _logger.v("notExpiredRenters");
    final contract = loadERC1190SmartContract(collectionAddress);

    final renters = await contract.rentersOf(tokenId);

    final date = DateTime.now().millisecondsSinceEpoch;

    final notExpired = <String>[];

    for (final renter in renters) {
      if ((await getRentalDate(collectionAddress, tokenId, renter)).toInt() >
          date) {
        notExpired.add(renter);
      }
    }
    return notExpired;
  }

  Future<void> rentAsset(
    final String collectionAddress,
    final int tokenId,
    final int rentStartingDateInMillis,
    final int rentExpirationDateInMillis,
  ) async {
    _logger.v("rentAsset");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.rentAsset(
        tokenId, rentStartingDateInMillis, rentExpirationDateInMillis);
  }

  Future<void> obtainOwnershipLicense(
    final String collectionAddress,
    final int tokenId,
  ) async {
    _logger.v("obtainOwnershipLicense");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.obtainOwnershipLicense(tokenId);
  }

  Future<void> obtainCreativeLicense(
    final String collectionAddress,
    final int tokenId,
  ) async {
    _logger.v("obtainCreativeLicense");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.obtainCreativeLicense(tokenId);
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

    final priceInWei = toWei(priceInEth);

    _logger.i("Prince in ETH: $priceInEth, price in WEI: $priceInWei");

    await contract.setOwnershipLicensePrice(tokenId, priceInWei);
  }

  Future<void> setCreativeLicensePrice(
    final String collectionAddress,
    final int tokenId,
    final double priceInEth,
  ) async {
    _logger.v("setCreativeLicensePrice");

    final contract = loadERC1190SmartContract(collectionAddress);

    final priceInWei = toWei(priceInEth);

    _logger.i("Prince in ETH: $priceInEth, price in WEI: $priceInWei");

    await contract.setCreativeLicensePrice(tokenId, priceInWei);
  }

  Future<void> setRentalPrice(
    final String collectionAddress,
    final int tokenId,
    final double priceInEth,
  ) async {
    _logger.v("setRentalPrice");

    final contract = loadERC1190SmartContract(collectionAddress);

    final priceInWei = toWei(priceInEth);

    _logger.i("Prince in ETH: $priceInEth, price in WEI: $priceInWei");

    await contract.setRentalPrice(tokenId, priceInWei);
  }

  Future<void> requireOwnershipLicenseTransferApproval(
    final String collectionAddress,
    final int tokenId,
  ) async {
    _logger.v("requireOwnershipLicenseTransferApproval");

    await marketplaceContract.requireOwnershipLicenseTransferApproval(
        collectionAddress, tokenId);
  }

  Future<void> requireCreativeLicenseTransferApproval(
    final String collectionAddress,
    final int tokenId,
  ) async {
    _logger.v("requireCreativeLicenseTransferApproval");

    await marketplaceContract.requireCreativeLicenseTransferApproval(
        collectionAddress, tokenId);
  }

  Future<void> approveOwnership(final String collectionAddress,
      final int tokenId, final String to) async {
    _logger.v("approve");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.approveOwnership(to, tokenId);
  }

  Future<void> approveCreative(final String collectionAddress,
      final int tokenId, final String to) async {
    _logger.v("approve");

    final contract = loadERC1190SmartContract(collectionAddress);

    await contract.approveCreative(to, tokenId);
  }

  Future<bool> getApprovedOwnership(
      final String collectionAddress, final int tokenId) async {
    _logger.v("getApprovedByOwner");

    final contract = loadERC1190SmartContract(collectionAddress);

    return _account == (await contract.getApprovedOwnership(tokenId));
  }

  Future<bool> getApprovedCreative(
      final String collectionAddress, final int tokenId) async {
    _logger.v("getApprovedByCreator");

    final contract = loadERC1190SmartContract(collectionAddress);

    return _account == (await contract.getApprovedCreative(tokenId));
  }
}
