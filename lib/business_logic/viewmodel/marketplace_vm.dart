import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../business_logic/contracts/erc1190_tradable.dart';
import '../../business_logic/models/collection.dart';

import '../../business_logic/contracts/erc1190_marketplace.dart';
import '../../logger/logger.dart';

class MarketplaceVM with ChangeNotifier {
  final _logger = getLogger("MarketplaceVM");

  late ERC1190Marketplace marketplaceSmartContract;

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
      marketplaceSmartContract = erc1190marketplace;
      _marketplaceSmartContractLoaded = true;
      notifyListeners();
    }
  }

  void disableContract() {
    _marketplaceSmartContractLoaded = false;
  }

  Future<List<Collection>> getCollections([final String collectionOwner = ""]) async {
    _logger.v("getCollections");

    final collectionAddresses = <String>[];
    if (collectionOwner.isEmpty) {
      collectionAddresses.addAll(await marketplaceSmartContract.allCollections);
    } else {
      collectionAddresses.addAll(await marketplaceSmartContract.collectionsOf(collectionOwner));
    }

    final contracts = collectionAddresses.map(loadERC1190SmartContract);

    final collections = <Collection>[];

    for (final contract in contracts) {
      collections.add(Collection(
        name: await contract.name,
        symbol: await contract.symbol,
        creator: await marketplaceSmartContract.creatorOf(contract.address),
        availableTokens: await contract.availableTokens,
      ));
    }

    return collections;
  }

  Future<Collection> deployNewCollection(
    final String name,
    final String symbol,
    final String baseURI,
    final int royaltyForRental,
    final int royaltyForOwnershipTransfer, [
    final List<String> files = const [],
  ]) async {
    _logger.v("deployNewCollection");

    final contractAddress = await marketplaceSmartContract.deployNewCollection(
      name,
      symbol,
      baseURI,
    );

    final collection = loadERC1190SmartContract(contractAddress);
    final creator = await marketplaceSmartContract.creatorOf(contractAddress);

    for (final fileBlobURI in files) {
      final fileResponse = await httpClient.get(Uri.parse(fileBlobURI));
      final fileBytes = fileResponse.bodyBytes;

      final ipfsURI = Uri.parse("$ipfsUrl/api/v0/add");
      final request = http.MultipartRequest("POST", ipfsURI);
      request.files.add(http.MultipartFile.fromBytes("path", fileBytes));
      final ipfsResponse = await request.send();
      if (ipfsResponse.statusCode == 200) {
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
      }
    }

    return Collection(
      name: await collection.name,
      symbol: await collection.symbol,
      creator: creator,
      availableTokens: await collection.availableTokens,
    );
  }
}