import 'web3_connector.dart';
import '../../logger/logger.dart';
import '../contracts/erc1190_marketplace.dart';
import '../contracts/erc1190_tradable.dart';

typedef EthAddress = String;

class ContractLoader {
  final _logger = getLogger("ContractLoader");

  final Web3Connector _web3connector;

  ContractLoader(this._web3connector);

  ERC1190Marketplace loadERC1190MarketplaceContract(final EthAddress address) {
    _logger.v("loadERC1190MarketplaceContract");

    final contract = _web3connector.loadContract(address, ERC1190Marketplace.abi);
    return ERC1190Marketplace(contract: contract);
  }

  ERC1190Tradable loadERC1190Tradable(final EthAddress address) {
    _logger.v("loadERC1190Tradable");

    final contract = _web3connector.loadContract(address, ERC1190Tradable.abi);
    return ERC1190Tradable(contract: contract);
  }
}
