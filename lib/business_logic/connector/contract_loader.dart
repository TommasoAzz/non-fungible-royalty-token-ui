import 'package:flutter_web3/flutter_web3.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/connector/web3_connector.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/contracts/erc1190_marketplace.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/contracts/erc1190_tradable.dart';

typedef EthAddress = String;

class ContractLoader {
  final Web3Connector _web3connector;

  const ContractLoader(this._web3connector);

  ERC1190Marketplace loadERC1190MarketplaceContract(final EthAddress address) {
    final contract = _web3connector.loadContract(address, ERC1190Marketplace.abi);
    return ERC1190Marketplace(contract: contract);
  }

  ERC1190Tradable loadERC1190Tradable(final EthAddress address) {
    final contract = _web3connector.loadContract(address, ERC1190Tradable.abi);
    return ERC1190Tradable(contract: contract);
  }
}
