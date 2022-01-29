import 'package:collection/collection.dart';

typedef EthAddress = String;

class Token {
  final int id;
  final String uri;
  final int ownershipLicensePrice;
  final int creativeLicensePrice;
  final int rentalPricePerSecond;
  final EthAddress owner;
  final EthAddress creativeOwner;
  final List<EthAddress> rentedBy;
  final List<EthAddress> ownershipLicenseRequests;
  final List<EthAddress> creativeLicenseRequests;

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
  });

  @override
  String toString() {
    return 'Token(id: $id, uri: $uri, ownershipLicensePrice: $ownershipLicensePrice, creativeLicensePrice: $creativeLicensePrice, rentalPricePerSecond: $rentalPricePerSecond, owner: $owner, creativeOwner: $creativeOwner, rentedBy: $rentedBy, ownershipLicenseRequests: $ownershipLicenseRequests, creativeLicenseRequests: $creativeLicenseRequests)';
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
        listEquals(other.creativeLicenseRequests, creativeLicenseRequests);
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
        creativeLicenseRequests.hashCode;
  }
}
