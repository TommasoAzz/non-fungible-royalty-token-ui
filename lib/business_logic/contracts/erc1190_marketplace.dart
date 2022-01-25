import 'dart:async';

import 'package:flutter_web3/flutter_web3.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

class ERC1190Marketplace {
  final _logger = getLogger("ERC1190Marketplace");

  static late final String abi;

  final Contract contract;

  ERC1190Marketplace({
    required this.contract,
  });

  String get address => contract.address;

  Future<EthAddress> creatorOf(final EthAddress collectionAddress) async {
    _logger.v("creatorOf");

    final creator = await contract.call<EthAddress>("creatorOf", [collectionAddress]);

    return creator;
  }

  Future<List<EthAddress>> get allCollections async {
    _logger.v("allCollections");

    final collections = (await contract.call<List<dynamic>>("allCollections"))
        .map((addr) => addr as String)
        .toList();

    return collections;
  }

  Future<List<EthAddress>> collectionsOf(final EthAddress collectionOwner) async {
    _logger.v("collectionsOf");

    final collections = (await contract.call<List<dynamic>>("collectionsOf", [collectionOwner]))
        .map((addr) => addr as String)
        .toList();

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
