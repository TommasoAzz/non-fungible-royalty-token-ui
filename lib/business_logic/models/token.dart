import 'package:collection/collection.dart';

import 'collection.dart';

typedef EthAddress = String;

class Token {
  final int id;
  final String uri;
  final double ownershipLicensePrice;
  final double creativeLicensePrice;
  final double rentalPricePerSecond;
  final EthAddress owner;
  final EthAddress creativeOwner;
  final List<EthAddress> rentedBy;
  final List<EthAddress> ownershipLicenseRequests;
  final List<EthAddress> creativeLicenseRequests;
  final int royaltyOwnershipTransfer;
  final int royaltyRental;
  final String approved;
  final Collection collection;
  final List<EthAddress> currentRenters;
  final List<EthAddress> expiredRenters;

  Token({
    required this.id,
    required this.uri,
    required this.ownershipLicensePrice,
    required this.creativeLicensePrice,
    required this.rentalPricePerSecond,
    required this.owner,
    required this.creativeOwner,
    required this.rentedBy,
    this.ownershipLicenseRequests = const [],
    this.creativeLicenseRequests = const [],
    required this.royaltyOwnershipTransfer,
    required this.royaltyRental,
    required this.approved,
    required this.collection,
    this.currentRenters = const [],
    this.expiredRenters = const [],
  });

  @override
  String toString() {
    return 'Token(id: $id, uri: $uri, ownershipLicensePrice: $ownershipLicensePrice, creativeLicensePrice: $creativeLicensePrice, rentalPricePerSecond: $rentalPricePerSecond, owner: $owner, creativeOwner: $creativeOwner, rentedBy: $rentedBy, ownershipLicenseRequests: $ownershipLicenseRequests, creativeLicenseRequests: $creativeLicenseRequests, royaltyOwnershipTransfer: $royaltyOwnershipTransfer, royaltyRental: $royaltyRental, approved: $approved, collection: $collection, currentRenters: $currentRenters, expiredRenters: $expiredRenters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Token &&
        other.id == id &&
        other.uri == uri &&
        other.ownershipLicensePrice == ownershipLicensePrice &&
        other.creativeLicensePrice == creativeLicensePrice &&
        other.rentalPricePerSecond == rentalPricePerSecond &&
        other.owner == owner &&
        other.creativeOwner == creativeOwner &&
        listEquals(other.rentedBy, rentedBy) &&
        listEquals(other.ownershipLicenseRequests, ownershipLicenseRequests) &&
        listEquals(other.creativeLicenseRequests, creativeLicenseRequests) &&
        other.royaltyOwnershipTransfer == royaltyOwnershipTransfer &&
        other.royaltyRental == royaltyRental &&
        other.approved == approved &&
        other.collection == collection &&
        listEquals(other.currentRenters, currentRenters) &&
        listEquals(other.expiredRenters, expiredRenters);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uri.hashCode ^
        ownershipLicensePrice.hashCode ^
        creativeLicensePrice.hashCode ^
        rentalPricePerSecond.hashCode ^
        owner.hashCode ^
        creativeOwner.hashCode ^
        rentedBy.hashCode ^
        ownershipLicenseRequests.hashCode ^
        creativeLicenseRequests.hashCode ^
        royaltyOwnershipTransfer.hashCode ^
        royaltyRental.hashCode ^
        approved.hashCode ^
        collection.hashCode ^
        currentRenters.hashCode ^
        expiredRenters.hashCode;
  }
}
