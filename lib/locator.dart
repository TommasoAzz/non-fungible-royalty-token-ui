import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/connector/contract_loader.dart';
import 'business_logic/connector/web3_connector.dart';
import 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingletonAsync(() async => await SharedPreferences.getInstance());
  locator.registerSingleton<Web3Connector>(Web3Connector());
  locator.registerLazySingleton<ContractLoader>(() => ContractLoader(locator<Web3Connector>()));
}
