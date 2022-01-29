import 'package:collection/collection.dart';

import '../../business_logic/models/token.dart';

class Collection {
  final String address;
  final String name;
  final String symbol;
  final String creator;
  final int availableTokens;
  final List<Token> tokens;

  Collection({
    required this.address,
    required this.name,
    required this.symbol,
    required this.creator,
    required this.availableTokens,
    this.tokens = const [],
  });

  @override
  String toString() {
    return 'Collection(address: $address, name: $name, symbol: $symbol, creator: $creator, availableTokens: $availableTokens, tokens: $tokens)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Collection &&
        other.address == address &&
        other.name == name &&
        other.symbol == symbol &&
        other.creator == creator &&
        other.availableTokens == availableTokens &&
        listEquals(other.tokens, tokens);
  }

  @override
  int get hashCode {
    return address.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        creator.hashCode ^
        availableTokens.hashCode ^
        tokens.hashCode;
  }
}
