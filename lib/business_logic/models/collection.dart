import '../../business_logic/models/token.dart';

class Collection {
  final String name;
  final String symbol;
  final String creator;
  final int availableTokens;
  final List<Token> tokens;

  Collection({
    required this.name,
    required this.symbol,
    required this.creator,
    required this.availableTokens,
    this.tokens = const [],
  });

  @override
  String toString() {
    return 'Collection(name: $name, symbol: $symbol, creator: $creator, availableTokens: $availableTokens)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Collection &&
        other.name == name &&
        other.symbol == symbol &&
        other.creator == creator &&
        other.availableTokens == availableTokens;
  }

  @override
  int get hashCode {
    return name.hashCode ^ symbol.hashCode ^ creator.hashCode ^ availableTokens.hashCode;
  }
}
