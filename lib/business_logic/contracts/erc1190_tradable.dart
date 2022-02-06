import 'dart:async';

import 'package:flutter_web3/flutter_web3.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

/// This class implements all the methods from the `ERC1190Tradable`
/// smart contract and also those that are necessary from the `ERC1190`, the
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

  /// Returns the number of available tokens.
  Future<int> get availableTokens async {
    _logger.v("availableTokens");

    final tokens = await contract.call<BigInt>("availableTokens");

    return tokens.toInt();
  }

  /// Returns the price of the ownership price license.
  Future<double> ownershipPriceOf(final int tokenId) async {
    _logger.v("ownershipPriceOf");

    final ownershipPrice = await contract.call<BigInt>("ownershipPriceOf", [tokenId]);

    return ownershipPrice.toInt() / 1e18;
  }

  /// Returns the price of the creative ownership price license.
  Future<double> creativeOwnershipPriceOf(final int tokenId) async {
    _logger.v("creativeOwnershipPriceOf");

    final creativePrice = await contract.call<BigInt>("creativeOwnershipPriceOf", [tokenId]);

    return creativePrice.toInt() / 1e18;
  }

  /// Returns the price of renting the token `tokenId` for a second. The amount is in wei.
  Future<double> rentalPriceOf(final int tokenId) async {
    _logger.v("rentalPriceOf");

    final rentalPrice = await contract.call<BigInt>("rentalPriceOf", [tokenId]);

    return rentalPrice.toInt() / 1e18;
  }

  /// Returns the royalty (in an integer range between 0 and 100) the creative
  /// owner receives when a rental of token `tokenId` takes place.
  Future<int> royaltyForRental(final int tokenId) async {
    _logger.v("royaltyForRental");

    final royalty = await contract.call<int>("royaltyForRental", [tokenId]);

    return royalty;
  }

  /// Returns the royalty (in an integer range between 0 and 100) the creative
  /// owner receives when the ownership license of token `tokenId` takes place.
  Future<int> royaltyForOwnershipTransfer(final int tokenId) async {
    _logger.v("royaltyForOwnershipTransfer");

    final royalty = await contract.call<int>("royaltyForOwnershipTransfer", [tokenId]);

    return royalty;
  }

  /// Generates a new token and assigns its ownership and creative license to
  /// `creator`.
  /// The royalties are set via `royaltyForRental` and `royaltyForOwnershipTransfer`.
  /// A file is assigned to the token via `file`.
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

  /// Sets the price for acquiring property of the ownership license of token `tokenId`.
  Future<void> setOwnershipLicensePrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setOwnershipLicensePrice");

    final tx = await contract.send("setOwnershipLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  /// Sets the price for acquiring property of the creative license of token `tokenId`.
  Future<void> setCreativeLicensePrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setCreativeLicensePrice");

    final tx = await contract.send("setCreativeLicensePrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  /// Sets the price for renting `tokenId` for 1 second.
  Future<void> setRentalPrice(final int tokenId, final BigInt priceInWei) async {
    _logger.v("setRentalPrice");

    final tx = await contract.send("setRentalPrice", [tokenId, priceInWei]);
    await tx.wait();
  }

  ///  Rents the token `tokenId` for a total amount of `rentExpirationDateInMillis - rentStartingDateInMillis` ms.
  Future<void> rentAsset(
    final int tokenId,
    final int rentStartingDateInMillis,
    final int rentExpirationDateInMillis,
  ) async {
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

  /// Transfers the ownership license from the current owner to the account `to`.
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

  /// Transfers the ownership license from the current owner to the sender of the request.
  /// The sender was previously authorized to do so.
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

  /// Transfers the creative license from the current creative owner to the account `to`.
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

  /// Transfers the creative license from the current owner to the sender of the request.
  /// The sender was previously authorized to do so.
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

    final tx = await contract.send(
      "obtainCreativeLicense",
      [tokenId],
      TransactionOverride(
        value: await contract.call<BigInt>("creativeOwnershipPriceOf", [tokenId]),
      ),
    );
    await tx.wait();

    await completer.future;
  }

  /* From ERC1190 */

  /// Returns the number of owned (though an ownership license) tokens in ``owner``'s account.
  Future<int> balanceOfOwner(final EthAddress owner) async {
    _logger.v("balanceOfOwner");

    return await contract.call<int>("balanceOfOwner", [owner]);
  }

  /// Returns the number of owned (through a creative license) tokens in ``creativeOwner``'s account.
  Future<int> balanceOfCreativeOwner(final EthAddress owner) async {
    _logger.v("balanceOfCreativeOwner");

    return await contract.call<int>("balanceOfCreativeOwner", [owner]);
  }

  /// Returns the number of tokens currently rented by ``renter``'s account.
  Future<int> balanceOfRenter(final EthAddress owner) async {
    _logger.v("balanceOfRenter");

    return await contract.call<int>("balanceOfRenter", [owner]);
  }

  /// Returns the owner of the `tokenId` token.
  Future<EthAddress> ownerOf(final int tokenId) async {
    _logger.v("ownerOf");

    return await contract.call<EthAddress>("ownerOf", [tokenId]);
  }

  /// Returns the creative owner of the `tokenId` token.
  Future<EthAddress> creativeOwnerOf(final int tokenId) async {
    _logger.v("creativeOwnerOf");

    return await contract.call<EthAddress>("creativeOwnerOf", [tokenId]);
  }

  /// Returns the renters of `tokenId`.
  Future<List<EthAddress>> rentersOf(final int tokenId) async {
    _logger.v("rentersOf");

    return (await contract.call<List<dynamic>>("rentersOf", [tokenId]))
        .map((addr) => addr as String)
        .toList();
  }

  /// Returns the token collection name.
  Future<String> get name async {
    _logger.v("name");

    return await contract.call<String>("name");
  }

  /// Returns the token collection symbol.
  Future<String> get symbol async {
    _logger.v("symbol");

    return await contract.call<String>("symbol");
  }

  /// Returns the Uniform Resource Identifier (URI) for `tokenId` token.
  Future<String> tokenURI(final int tokenId) async {
    _logger.v("tokenURI");

    return await contract.call<String>("tokenURI", [tokenId]);
  }

  /// Gives permission to `to` to transfer the ownership license of token `tokenId` to another account.
  /// The approval is cleared when the token is transferred.
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

  /// Gives permission to `to` to transfer the creative ownership license of `tokenId` to another account.
  /// The approval is cleared when the token is transferred.
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

  /// Returns the account approved by owner for `tokenId` token.
  Future<String> getApprovedOwnership(final int tokenId) async {
    _logger.v("getApprovedOwnership");

    return await contract.call<EthAddress>("getApprovedOwnership", [tokenId]);
  }

  /// Returns the account approved by creative owner for `tokenId` token.
  Future<String> getApprovedCreativeOwnership(final int tokenId) async {
    _logger.v("getApprovedCreativeOwnership");

    return await contract.call<EthAddress>("getApprovedCreativeOwnership", [tokenId]);
  }

  /// Returns the expiration date in milliseconds (it is 0 if `renter` has not 
  /// rented the token or if the rental has expired).
  Future<BigInt> getRentalDate(final int tokenId, final EthAddress renter) async {
    _logger.v("getRentalDate");

    return await contract.call<BigInt>("getRentalDate", [tokenId, renter]);
  }

  /// Returns the expiration date in milliseconds if `renter` is renting `tokenId` 
  /// token currently.
  /// Calling this function twice could result in two diffent results if the 
  /// `rentExpirationDateInMillis` corresponds to an expired date time.
  Future<void> updateEndRentalDate(
    final int tokenId,
    final int currentDate,
    final EthAddress renter,
  ) async {
    _logger.v("updateEndRentalDate");

    final tx = await contract.send("updateEndRentalDate", [tokenId, currentDate, renter]);
    await tx.wait();
  }
}
