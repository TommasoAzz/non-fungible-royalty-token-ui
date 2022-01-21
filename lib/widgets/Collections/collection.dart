class Collection {
  final String nameCollection;
  final String symbol;
  final String creator;
  final int tokenNumber;

  Collection(
      {required this.nameCollection,
      required this.symbol,
      required this.creator,
      required this.tokenNumber});
}

final collections = [
  Collection(
    nameCollection: 'This Is the Way',
    symbol: 'Gavin Corbett',
    creator: 'creators/1.jpg',
    tokenNumber: 1,
  ),
  Collection(
    nameCollection: 'Her',
    symbol: 'Spike Jonze',
    creator: 'creators/2.jpg',
    tokenNumber: 3,
  ),
  Collection(
    nameCollection: 'Fight Club',
    symbol: 'David Fincher',
    creator: 'creators/3.jpg',
    tokenNumber: 6,
  ),
  Collection(
    nameCollection: 'Enemy',
    symbol: 'Javier Gullón',
    creator: 'creators/4.jpg',
    tokenNumber: 1,
  ),
  Collection(
    nameCollection: 'Manual to Minimalism',
    symbol: 'Unknown',
    creator: 'creators/5.jpg',
    tokenNumber: 10,
  ),
  Collection(
    nameCollection: 'Dirty Harry',
    symbol: 'Don Siegel',
    creator: 'creators/6.jpg',
    tokenNumber: 5,
  ),
];
