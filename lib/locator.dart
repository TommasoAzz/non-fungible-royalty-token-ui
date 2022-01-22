import 'package:get_it/get_it.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/contracts/erc1190_tradable.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/connector/contract_loader.dart';
import 'business_logic/connector/web3_connector.dart';
import 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<String>(
    "0x2E19Cb4b4F90558695B27A6cf46bA6068D36C409",
    instanceName: "ERC1190Marketplace",
  );
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerSingletonAsync<SharedPreferences>(SharedPreferences.getInstance);
  locator.registerSingleton<Web3Connector>(Web3Connector());
  locator.registerLazySingleton<ContractLoader>(() => ContractLoader(locator<Web3Connector>()));
  locator.registerLazySingleton<MarketplaceVM>(() {
    final contract = locator<ContractLoader>().loadERC1190MarketplaceContract(
      locator<String>(instanceName: "ERC1190Marketplace"),
    );

    return MarketplaceVM(
      marketplaceSmartContract: contract,
      loadERC1190SmartContract: locator<ContractLoader>().loadERC1190Tradable,
    );
  });
}
