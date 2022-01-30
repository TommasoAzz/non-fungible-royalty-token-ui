class Collection {
  final String address;
  final String name;
  final String symbol;
  final String creator;
  final int availableTokens;

  Collection({
    required this.address,
    required this.name,
    required this.symbol,
    required this.creator,
    required this.availableTokens,
  });

  @override
  String toString() {
    return 'Collection(address: $address, name: $name, symbol: $symbol, creator: $creator, availableTokens: $availableTokens)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Collection &&
        other.address == address &&
        other.name == name &&
        other.symbol == symbol &&
        other.creator == creator &&
        other.availableTokens == availableTokens;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        creator.hashCode ^
        availableTokens.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'name': name,
      'symbol': symbol,
      'creator': creator,
      'availableTokens': availableTokens,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      address: map['address'] ?? '',
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      creator: map['creator'] ?? '',
      availableTokens: map['availableTokens']?.toInt() ?? 0,
    );
  }
}
