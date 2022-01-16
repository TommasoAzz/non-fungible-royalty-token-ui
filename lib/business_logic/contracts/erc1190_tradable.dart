import 'dart:async';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/logger/logger.dart';

typedef EthAddress = String;

/// This class implements all the methods from the ERC1190Tradable
/// interface and also those that are necessary from ERC1190, the
/// underlying smart contract.
class ERC1190Tradable {
  final _logger = getLogger("ERC1190Tradable");

  static const List<String> abi = [
    /* From ERC1190Tradable */
    "function mint(address, uint8, uint8) returns (uint256)",
    "function setOwnershipLicensePrice(uint256, uint256)",
    "function setCreativeLicensePrice(uint256, uint256)",
    "function setRentalPrice(uint256, uint256)",
    "function rentAsset(uint256, uint256)",
    "function transferOwnershipLicense(uint256, address)",
    "function obtainOwnershipLicense(uint256)",
    "function transferCreativeLicense(uint256, address)",
    "function obtainCreativeLicense(uint256)",
    "event TokenMinted(address, uint8, uint8, uint256)",
    /* From ERC1190 */
    "function balanceOfOwner(address) returns (uint256)",
    "function balanceOfCreativeOwner(address) returns (uint256)",
    "function balanceOfRenter(address) returns (uint256)",
    "function ownerOf(uint256) returns (address)",
    "function creativeOwnerOf(uint256) returns (address)",
    "function rentersOf(uint256) returns (address[])",
    "function name() returns (string)",
    "function symbol() returns (string)",
    "function tokenURI(uint256) returns (string)",
    "function approve(address, uint256)",
    "event Approval(address, address, uint256)",
    "event TransferCreativeLicense(address, address, uint256)",
    "event TransferOwnershipLicense(address, address, uint256)",
    "event AssetRented(address, address, uint256)",
  ];

  final Contract contract;

  ERC1190Tradable({
    required this.contract,
  });

  /* From ERC1190Tradable */

  Future<int> mint(
    final String creator,
    int royaltyForRental,
    int royaltyForOwnershipTransfer,
  ) async {
    _logger.v("mint");

    final completer = Completer<int>();

    contract.once("TokenMinted", (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete(0);
    });

    final tx = await contract.send(
      "mint",
      [creator, royaltyForRental, royaltyForOwnershipTransfer],
    );
    await tx.wait();

    return await completer.future;
  }

  Future<void> setOwnershipLicensePrice(final int tokenId, final int priceInWei) async {
    _logger.v("setOwnershipLicensePrice");

    final tx = await contract.send("setOwnershipLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> setCreativeLicensePrice(final int tokenId, final int priceInWei) async {
    _logger.v("setCreativeLicensePrice");

    final tx = await contract.send("setCreativeLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> setRentalPrice(final int tokenId, final int priceInWei) async {
    _logger.v("setRentalPrice");

    final tx = await contract.send("setRentalPrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> rentAsset(final int tokenId, final int rentExpirationDateInMillis) async {
    _logger.v("rentAsset");

    final tx = await contract.send("rentAsset", [tokenId, rentExpirationDateInMillis]);
    await tx.wait();
  }

  Future<void> transferOwnershipLicense(final int tokenId, final EthAddress to) async {
    _logger.v("transferOwnershipLicense");

    final completer = Completer<void>();

    contract.once("TransferOwnershipLicense", (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete();
    });

    final tx = await contract.send("transferOwnershipLicense", [tokenId, to]);
    await tx.wait();

    await completer.future;
  }

  Future<void> obtainOwnershipLicense(final int tokenId) async {
    _logger.v("obtainOwnershipLicense");

    final completer = Completer<void>();

    contract.once("TransferOwnershipLicense", (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete();
    });

    final tx = await contract.send("obtainOwnershipLicense", [tokenId]);
    await tx.wait();

    await completer.future;
  }

  Future<void> transferCreativeLicense(final int tokenId, final EthAddress to) async {
    _logger.v("transferCreativeLicense");

    final completer = Completer<void>();

    contract.once("TransferCreativeLicense", (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete();
    });

    final tx = await contract.send("transferCreativeLicense", [tokenId, to]);
    await tx.wait();

    await completer.future;
  }

  Future<void> obtainCreativeLicense(final int tokenId) async {
    _logger.v("obtainCreativeLicense");

    final completer = Completer<void>();

    contract.once("TransferCreativeLicense", (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete();
    });

    final tx = await contract.send("obtainCreativeLicense", [tokenId]);
    await tx.wait();

    await completer.future;
  }

  /* From ERC1190 */

  Future<int> balanceOfOwner(final EthAddress owner) async {
    _logger.v("balanceOfOwner");

    return await contract.call<int>("balanceOfOwner", [owner]);
  }

  Future<int> balanceOfCreativeOwner(final EthAddress owner) async {
    _logger.v("balanceOfCreativeOwner");

    return await contract.call<int>("balanceOfCreativeOwner", [owner]);
  }

  Future<int> balanceOfRenter(final EthAddress owner) async {
    _logger.v("balanceOfRenter");

    return await contract.call<int>("balanceOfRenter", [owner]);
  }

  Future<EthAddress> ownerOf(final int tokenId) async {
    _logger.v("ownerOf");

    return await contract.call<EthAddress>("ownerOf", [tokenId]);
  }

  Future<EthAddress> creativeOwnerOf(final int tokenId) async {
    _logger.v("creativeOwnerOf");

    return await contract.call<EthAddress>("creativeOwnerOf", [tokenId]);
  }

  Future<List<EthAddress>> rentersOf(final int tokenId) async {
    _logger.v("rentersOf");

    return await contract.call<List<EthAddress>>("rentersOf", [tokenId]);
  }

  Future<String> get name async {
    _logger.v("name");

    return await contract.call<String>("name");
  }

  Future<String> get symbol async {
    _logger.v("symbol");

    return await contract.call<String>("symbol");
  }

  Future<String> tokenURI(final int tokenId) async {
    _logger.v("tokenURI");

    return await contract.call<String>("tokenURI", [tokenId]);
  }

  Future<void> approve(final EthAddress to, final int tokenId) async {
    _logger.v("approve");

    final completer = Completer<void>();

    contract.once('Approval', (event) {
      // TODO Finish managing event.
      dartify(event);
      completer.complete();
    });

    final tx = await contract.send("approve", [to, tokenId]);
    await tx.wait();

    await completer.future;
  }
}
