import 'dart:async';

import 'package:flutter_web3/flutter_web3.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

class ERC1190Marketplace {
  final _logger = getLogger("ERC1190Marketplace");

  static const List<String> abi = [
    "function getCollections() returns (address[])",
    "function getCollections(address) returns (address[])",
    "function deployNewCollection(string, string, string) returns (address)",
    "function requireOwnershipLicenseTransferApproval(address, uint256)",
    "function requireCreativeLicenseTransferApproval(address, uint256)",
    "function getOwnershipLicenseTransferRequests(address, uint256) returns (address[])",
    "function getCreativeLicenseTransferRequests(address, uint256) returns (address[])",
    "event CollectionDeployed(string, string, string, address)"
  ];

  final Contract contract;

  ERC1190Marketplace({
    required this.contract,
  });

  Future<List<EthAddress>> getCollections([final EthAddress collectionOwner = ""]) async {
    _logger.v("getCollections");

    final collections = await contract.call<List<EthAddress>>(
      "getCollections",
      collectionOwner.isNotEmpty ? [collectionOwner] : [],
    );

    return collections;
  }

  Future<EthAddress> deployNewCollection(
    final String name,
    final String symbol,
    final String baseURI,
  ) async {
    _logger.v("deployNewCollection");

    final completer = Completer<EthAddress>();

    contract.once("CollectionDeployed", (event) {
      // TODO(TommasoAzz): Finish managing event.
      dartify(event);
      completer.complete("");
    });

    final tx = await contract.send("deployNewCollection", [name, symbol, baseURI]);
    await tx.wait();

    return await completer.future;
  }

  Future<void> requireOwnershipLicenseTransferApproval(
    EthAddress collectionAddress,
    int tokenId,
  ) async {
    _logger.v("requireOwnershipLicenseTransferApproval");

    final tx = await contract.send(
      "requireOwnershipLicenseTransferApproval",
      [collectionAddress, tokenId],
    );
    await tx.wait();
  }

  Future<void> requireCreativeLicenseTransferApproval(
    EthAddress collectionAddress,
    int tokenId,
  ) async {
    _logger.v("requireCreativeLicenseTransferApproval");

    final tx = await contract.send(
      "requireCreativeLicenseTransferApproval",
      [collectionAddress, tokenId],
    );
    await tx.wait();
  }

  Future<List<EthAddress>> getOwnershipLicenseTransferRequests(
    EthAddress collectionAddress,
    int tokenId,
  ) async {
    _logger.v("getOwnershipLicenseTransferRequests");

    return await contract.call<List<EthAddress>>(
      "getOwnershipLicenseTransferRequests",
      [collectionAddress, tokenId],
    );
  }

  Future<List<EthAddress>> getCreativeLicenseTransferRequests(
    EthAddress collectionAddress,
    int tokenId,
  ) async {
    _logger.v("getCreativeLicenseTransferRequests");

    return await contract.call<List<EthAddress>>(
      "getCreativeLicenseTransferRequests",
      [collectionAddress, tokenId],
    );
  }
}
