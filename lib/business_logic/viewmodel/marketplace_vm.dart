import '../../business_logic/contracts/erc1190_tradable.dart';
import '../../business_logic/models/collection.dart';

import '../../business_logic/contracts/erc1190_marketplace.dart';
import '../../logger/logger.dart';

class MarketplaceVM {
  final _logger = getLogger("ERC1190Marketplace");

  final ERC1190Marketplace marketplaceSmartContract;

  final ERC1190Tradable Function(String) loadERC1190SmartContract;

  MarketplaceVM({
    required this.marketplaceSmartContract,
    required this.loadERC1190SmartContract,
  });

  Future<List<Collection>> getCollections([final String collectionOwner = ""]) async {
    _logger.v("getCollections");

    final collectionAddresses = await marketplaceSmartContract.getCollections(collectionOwner);

    final contracts = collectionAddresses.map(loadERC1190SmartContract);

    final collections = <Collection>[];

    for (final contract in contracts) {
      collections.add(Collection(
        name: await contract.name,
        symbol: await contract.symbol,
        creator: await marketplaceSmartContract.creatorOf(contract.address),
        availableTokens: await contract.availableTokens,
      ));
    }

    return collections;
  }

  Future<Collection> deployNewCollection(
    final String name,
    final String symbol,
    final String baseURI,
    final int royaltyForRental,
    final int royaltyForOwnershipTransfer, [
    final List<String> files = const [],
  ]) async {
    _logger.v("deployNewCollection");

    final contractAddress = await marketplaceSmartContract.deployNewCollection(
      name,
      symbol,
      baseURI,
    );

    final collection = loadERC1190SmartContract(contractAddress);
    final creator = await marketplaceSmartContract.creatorOf(contractAddress);

    for (final file in files) {
      final tokenId = await collection.mint(
        creator,
        royaltyForRental,
        royaltyForOwnershipTransfer,
      );
      // TODO(dominego): Deploy [file] on IPFS.
    }

    return Collection(
      name: await collection.name,
      symbol: await collection.symbol,
      creator: creator,
      availableTokens: await collection.availableTokens,
    );
  }
}
