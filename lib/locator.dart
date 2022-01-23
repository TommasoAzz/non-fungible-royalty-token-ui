import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/contracts/erc1190_tradable.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/connector/contract_loader.dart';
import 'business_logic/connector/web3_connector.dart';
import 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<String>(
    // "0x2E19Cb4b4F90558695B27A6cf46bA6068D36C409", // On Rinkeby
    "0xfC8106356958a3161D9b80938C28c1f2b6225a99", // On Ganache
    instanceName: "ERC1190Marketplace",
  );
  locator.registerSingleton<String>(
      // "https://tommasoazz.ddns.net:5001", // On Raspberry Pi
      "http://localhost:5001", // On local IPFS node,
      instanceName: "ipfs");
  locator.registerLazySingleton<http.Client>(() => http.Client());
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
      httpClient: locator<http.Client>(),
      ipfsUrl: locator<String>(instanceName: "ipfs"),
    );
  });
}
