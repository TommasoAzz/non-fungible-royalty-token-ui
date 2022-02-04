import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'business_logic/exception/wallet_not_loaded_exception.dart';
import 'business_logic/contracts/erc1190_marketplace.dart';
import 'business_logic/contracts/erc1190_tradable.dart';
import 'business_logic/viewmodel/marketplace_vm.dart';
import 'business_logic/connector/contract_loader.dart';
import 'business_logic/connector/web3_connector.dart';
import 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

typedef JSON = Map<String, dynamic>;

void setupLocator() {
  /// Navigation service
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  // /// Ethereum smart contract address to connect to (based on the network)
  // locator.registerSingleton<String>(
  //   // "0x2E19Cb4b4F90558695B27A6cf46bA6068D36C409", // On Rinkeby
  //   "0xfC8106356958a3161D9b80938C28c1f2b6225a99", // On Ganache
  //   instanceName: "marketplace_contract_address",
  // );

  /// IPFS node URL
  locator.registerSingleton<String>(
    // "https://tommasoazz.ddns.net:5001", // On Raspberry Pi
    "http://localhost:5001", // On local IPFS node,
    instanceName: "ipfs",
  );

  /// Compiled ERC1190Marketplace contract
  locator.registerSingletonAsync<JSON>(
    () async {
      final jsonFile = await rootBundle.loadString("assets/contracts/ERC1190Marketplace.json");
      return json.decode(jsonFile) as JSON;
    },
    instanceName: "marketplace_contract",
  );

  /// Compiled ERC1190Tradable contract
  locator.registerSingletonAsync<JSON>(
    () async {
      final jsonFile = await rootBundle.loadString("assets/contracts/ERC1190Tradable.json");
      return json.decode(jsonFile) as JSON;
    },
    instanceName: "tradable_contract",
  );

  /// Ethereum smart contract address to connect to (based on the network)
  locator.registerSingletonWithDependencies<String>(
    () {
      final contractJson = locator<JSON>(instanceName: "marketplace_contract");
      final networks = (contractJson["networks"] as JSON);
      final network = (networks.values.first as JSON);
      return network["address"] as String;
    },
    instanceName: "marketplace_contract_address",
    dependsOn: [
      InitDependency(JSON, instanceName: "marketplace_contract"),
    ],
  );

  /// Web3 Connector instance (to be used by the Contract loader and the UI)
  locator.registerSingleton<Web3Connector>(Web3Connector());

  /// Contract loader instance (+ loading contract ABIs)
  locator.registerSingletonWithDependencies<ContractLoader>(() {
    final marketplaceABI = locator<JSON>(instanceName: "marketplace_contract")["abi"];
    final tradableABI = locator<JSON>(instanceName: "tradable_contract")["abi"];

    ERC1190Marketplace.abi = json.encode(marketplaceABI);
    ERC1190Tradable.abi = json.encode(tradableABI);

    return ContractLoader(locator<Web3Connector>());
  }, dependsOn: [
    InitDependency(JSON, instanceName: "marketplace_contract"),
    InitDependency(JSON, instanceName: "tradable_contract"),
  ]);

  /// Marketplace ViewModel (to be used by the UI)
  locator.registerSingletonWithDependencies<MarketplaceVM>(() {
    final contractLoader = locator<ContractLoader>();
    final connector = locator<Web3Connector>();

    final vm = MarketplaceVM(
      connect: connector.connectToWallet,
      connected: () => connector.connectedToWallet,
      account: connector.firstAccount,
      loadERC1190SmartContract: contractLoader.loadERC1190Tradable,
      httpClient: http.Client(),
      ipfsUrl: locator<String>(instanceName: "ipfs"),
      toWei: (eth) => EthUtils.parseEther(eth.toStringAsFixed(20)).toBigInt,
      fixAddress: (addr) => EthUtils.getAddress(addr),
    );

    connector.addListener(() {
      try {
        vm.contract = contractLoader.loadERC1190MarketplaceContract(
          locator<String>(instanceName: "marketplace_contract_address"),
        );
      } on WalletNotLoadedException {
        vm.disableContract();
      }

      vm.loggedAccount = connector.firstAccount;
    });

    return vm;
  }, dependsOn: [
    ContractLoader,
    InitDependency(String, instanceName: "marketplace_contract_address")
  ]);
}
