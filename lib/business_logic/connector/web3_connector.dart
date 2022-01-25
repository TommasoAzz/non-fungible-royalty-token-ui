import 'package:flutter/foundation.dart';
import 'package:flutter_web3/flutter_web3.dart';
import '../exception/wallet_not_loaded_exception.dart';
import '../exception/wallet_not_supported_exception.dart';
import '../exception/wallet_rejected_exception.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

class Web3Connector with ChangeNotifier {
  final _logger = getLogger("Web3Connector");

  late Web3Provider _provider;

  bool _walletConnected = false;

  final List<EthAddress> _accounts = [];

  Future<void> connectToWallet() async {
    _logger.v("connectToWallet");

    if (Ethereum.isSupported) {
      if (_walletConnected) {
        _logger.i("Wallet already connected.");
        return;
      }

      try {
        _accounts.clear();
        _accounts.addAll(await ethereum!.requestAccount());

        _logger.i("Retrieved the following accounts: $_accounts");

        _provider = Web3Provider.fromEthereum(ethereum!);
        _walletConnected = true;

        notifyListeners();

        ethereum!.onAccountsChanged((accounts) {
          _logger.i("Accounts changed!");
          if (accounts.isNotEmpty) {
            _accounts.clear();
            _accounts.addAll(accounts);
            _walletConnected = true;
          } else {
            _accounts.clear();
            _walletConnected = false;
          }
          notifyListeners();
        });
      } on EthereumUserRejected {
        _logger.e("User rejected the wallet modal.");
        throw const WalletRejectedException();
      }
    } else {
      _logger.e("Wallet not supported!");
      throw const WalletNotSupportedException();
    }
  }

  bool get connectedToWallet => _walletConnected;

  Contract loadContract(final EthAddress address, final String abi) {
    _logger.v("loadContract");

    if (!_walletConnected) {
      throw const WalletNotLoadedException();
    }

    return Contract(address, abi, _provider.getSigner());
  }

  EthAddress get firstAccount {
    _logger.v("firstAccount");

    if (_accounts.isEmpty) {
      _logger.e("There are no accounts stored.");
      return "";
    }

    return _accounts.first;
  }
}
