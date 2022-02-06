import 'dart:async';

import 'package:flutter_web3/flutter_web3.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

/// This class implements all the methods from the ERC1190Tradable
/// interface and also those that are necessary from ERC1190, the
/// underlying smart contract.
class ERC1190Tradable {
  final _logger = getLogger("ERC1190Tradable");

  static late final String abi;

  final Contract contract;

  ERC1190Tradable({
    required this.contract,
  });

  String get address => contract.address;

  /* From ERC1190Tradable */

  Future<int> get availableTokens async {
    _logger.v("availableTokens");

    final tokens = await contract.call<BigInt>("availableTokens");

    return tokens.toInt();
  }

  Future<double> ownershipPriceOf(final int tokenId) async {
    _logger.v("ownershipPriceOf");

    final ownershipPrice = await contract.call<BigInt>("ownershipPriceOf", [tokenId]);

    return ownershipPrice.toInt() / 1e18;
  }

  Future<double> creativeOwnershipPriceOf(final int tokenId) async {
    _logger.v("creativeOwnershipPriceOf");

    final creativePrice = await contract.call<BigInt>("creativeOwnershipPriceOf", [tokenId]);

    return creativePrice.toInt() / 1e18;
  }

  Future<double> rentalPriceOf(final int tokenId) async {
    _logger.v("rentalPriceOf");

    final rentalPrice = await contract.call<BigInt>("rentalPriceOf", [tokenId]);

    return rentalPrice.toInt() / 1e18;
  }

  Future<int> royaltyForRental(final int tokenId) async {
    _logger.v("royaltyForRental");

    final royalty = await contract.call<int>("royaltyForRental", [tokenId]);

    return royalty;
  }

  Future<int> royaltyForOwnershipTransfer(final int tokenId) async {
    _logger.v("royaltyForOwnershipTransfer");

    final royalty = await contract.call<int>("royaltyForOwnershipTransfer", [tokenId]);

    return royalty;
  }

  Future<void> mint(
    final String creator,
    final String file,
    int royaltyForRental,
    int royaltyForOwnershipTransfer,
  ) async {
    _logger.v("mint");

    final completer = Completer<void>();

    contract.once("TokenMinted", (
      creator,
      royaltyForRental,
      royaltyForOwnershipTransfer,
      tokenId,
      _,
    ) {
      _logger.i("Event: TokenMinted");
      _logger.i("- creator: ${dartify(creator)}");
      _logger.i("- royaltyForRental: ${dartify(royaltyForRental)}");
      _logger.i("- royaltyForOwnershipTransfer: ${dartify(royaltyForOwnershipTransfer)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");

      completer.complete();
    });

    final tx = await contract.send(
      "mint",
      [creator, file, royaltyForRental, royaltyForOwnershipTransfer],
    );
    await tx.wait();

    return await completer.future;
  }

  Future<void> setOwnershipLicensePrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setOwnershipLicensePrice");

    final tx = await contract.send("setOwnershipLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> setCreativeLicensePrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setCreativeLicensePrice");

    final tx = await contract.send("setCreativeLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> setRentalPrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setRentalPrice");

    final tx = await contract.send("setRentalPrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  Future<void> rentAsset(final int tokenId, final int rentStartingDateInMillis,
      final int rentExpirationDateInMillis) async {
    _logger.v("rentAsset");

    final completer = Completer<void>();

    contract.once("AssetRented", (renter, tokenId, rentExpirationDateInMillis, _) {
      _logger.i("Event: AssetRented");
      _logger.i("- renter: ${dartify(renter)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");
      _logger.i("- rentExpirationDateInMillis: ${dartify(rentExpirationDateInMillis)}");
      _logger.i("- rentExpirationDateInMillis: ${dartify(rentStartingDateInMillis)}");
      completer.complete();
    });

    final rentalPricePerSecond = await contract.call<BigInt>("rentalPriceOf", [tokenId]);
    final rentalTotalSeconds =
        ((rentExpirationDateInMillis - rentStartingDateInMillis) * 0.001).toInt();
    final weiToSend = rentalPricePerSecond * BigInt.from(rentalTotalSeconds);

    final tx = await contract.send(
      "rentAsset(uint256,uint256,uint256)",
      [
        tokenId,
        rentStartingDateInMillis,
        rentExpirationDateInMillis,
      ],
      TransactionOverride(
        value: weiToSend,
        // gasLimit: BigInt.from(60000),
      ),
    );
    await tx.wait();

    await completer.future;
  }

  Future<void> transferOwnershipLicense(final int tokenId, final EthAddress to) async {
    _logger.v("transferOwnershipLicense");

    final completer = Completer<void>();

    contract.once("TransferOwnershipLicense", (from, to, tokenId, _) {
      _logger.i("Event: TransferOwnershipLicense");
      _logger.i("- from: ${dartify(from)}");
      _logger.i("- to: ${dartify(to)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");
      completer.complete();
    });

    final tx = await contract.send("transferOwnershipLicense(uint256,address)", [tokenId, to]);
    await tx.wait();

    await completer.future;
  }

  Future<void> obtainOwnershipLicense(final int tokenId) async {
    _logger.v("obtainOwnershipLicense");

    final completer = Completer<void>();

    contract.once("TransferOwnershipLicense", (from, to, tokenId, _) {
      _logger.i("Event: TransferOwnershipLicense");
      _logger.i("- from: ${dartify(from)}");
      _logger.i("- to: ${dartify(to)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");
      completer.complete();
    });

    final tx = await contract.send(
      "obtainOwnershipLicense",
      [tokenId],
      TransactionOverride(
        value: await contract.call<BigInt>("ownershipPriceOf", [tokenId]),
      ),
    );
    await tx.wait();

    await completer.future;
  }

  Future<void> transferCreativeLicense(final int tokenId, final EthAddress to) async {
    _logger.v("transferCreativeLicense");

    final completer = Completer<void>();

    contract.once("TransferCreativeLicense", (from, to, tokenId, _) {
      _logger.i("Event: TransferCreativeLicense");
      _logger.i("- from: ${dartify(from)}");
      _logger.i("- to: ${dartify(to)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");
      completer.complete();
    });

    final tx = await contract.send("transferCreativeLicense(uint256,address)", [tokenId, to]);
    await tx.wait();

    await completer.future;
  }

  Future<void> obtainCreativeLicense(final int tokenId) async {
    _logger.v("obtainCreativeLicense");

    final completer = Completer<void>();

    contract.once("TransferCreativeLicense", (from, to, tokenId, _) {
      _logger.i("Event: TransferCreativeLicense");
      _logger.i("- from: ${dartify(from)}");
      _logger.i("- to: ${dartify(to)}");
      _logger.i("- tokenId: ${dartify(tokenId)}");
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

    return (await contract.call<List<dynamic>>("rentersOf", [tokenId]))
        .map((addr) => addr as String)
        .toList();
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

  Future<void> approveOwnership(final EthAddress to, final int tokenId) async {
    _logger.v("approveOwnership");

    final completer = Completer<void>();

    contract.once('Approval', (owner, approved, tokenId, _) {
      _logger.i("Event: Approval");
      print("- owner: ${dartify(owner)}");
      print("- approved: ${dartify(approved)}");
      print("- tokenId: ${dartify(tokenId)}");
      completer.complete();
    });

    final tx = await contract.send("approveOwnership", [to, tokenId]);
    await tx.wait();

    await completer.future;
  }

  Future<void> approveCreativeOwnership(final EthAddress to, final int tokenId) async {
    _logger.v("approveCreativeOwnership");

    final completer = Completer<void>();

    contract.once('Approval', (owner, approved, tokenId, _) {
      _logger.i("Event: Approval");
      print("- owner: ${dartify(owner)}");
      print("- approved: ${dartify(approved)}");
      print("- tokenId: ${dartify(tokenId)}");
      completer.complete();
    });

    final tx = await contract.send("approveCreativeOwnership", [to, tokenId]);
    await tx.wait();

    await completer.future;
  }

  Future<String> getApprovedOwnership(final int tokenId) async {
    _logger.v("getApprovedOwnership");

    return await contract.call<EthAddress>("getApprovedOwnership", [tokenId]);
  }

  Future<String> getApprovedCreativeOwnership(final int tokenId) async {
    _logger.v("getApprovedCreativeOwnership");

    return await contract.call<EthAddress>("getApprovedCreativeOwnership", [tokenId]);
  }

  Future<BigInt> getRentalDate(final int tokenId, final EthAddress renter) async {
    _logger.v("getRentalDate");

    return await contract.call<BigInt>("getRentalDate", [tokenId, renter]);
  }

  Future<void> updateEndRentalDate(
      final int tokenId, final int currentDate, final EthAddress renter) async {
    _logger.v("updateEndRentalDate");

    final tx = await contract.send("updateEndRentalDate", [tokenId, currentDate, renter]);
    await tx.wait();
  }
}
