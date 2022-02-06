import 'web3_connector.dart';
import '../../logger/logger.dart';
import '../contracts/erc1190_marketplace.dart';
import '../contracts/erc1190_tradable.dart';

typedef EthAddress = String;

/// Utility class for loading instances of [ERC1190Marketplace] and [ERC1190Tradable] contract wrappers.
/// An active instance of [Web3Connector] in order for the contracts to be loaded.
class ContractLoader {
  final _logger = getLogger("ContractLoader");

  final Web3Connector _web3connector;

  ContractLoader(this._web3connector);

  /// Loads an instance of [ERC1190Marketplace] given a valid `ERC1190Marketplace` smart contract address.
  ERC1190Marketplace loadERC1190MarketplaceContract(final EthAddress address) {
    _logger.v("loadERC1190MarketplaceContract");

    final contract = _web3connector.loadContract(address, ERC1190Marketplace.abi);
    return ERC1190Marketplace(contract: contract);
  }

  /// Loads an instance of [ERC1190Tradable] given a valid `ERC1190Tradable` smart contract address.
  ERC1190Tradable loadERC1190Tradable(final EthAddress address) {
    _logger.v("loadERC1190Tradable");

    final contract = _web3connector.loadContract(address, ERC1190Tradable.abi);
    return ERC1190Tradable(contract: contract);
  }
}
