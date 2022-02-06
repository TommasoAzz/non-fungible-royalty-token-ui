import 'package:flutter/foundation.dart';
import 'package:flutter_web3/flutter_web3.dart';
import '../exception/wallet_not_loaded_exception.dart';
import '../exception/wallet_not_supported_exception.dart';
import '../exception/wallet_rejected_exception.dart';
import '../../logger/logger.dart';

typedef EthAddress = String;

/// Allows to access the **Ethereum** blockchain via the JS libraries **Ethers.js**, **web3.js**, and many more.
class Web3Connector with ChangeNotifier {
  final _logger = getLogger("Web3Connector");

  late Web3Provider _provider;

  bool _walletConnected = false;

  final List<EthAddress> _accounts = [];

  /// Connects to the wallet available in the browser.
  /// Notifies all listeners of this class when the accounts selected in the wallet change.
  /// Throws a [WalletRejectedException] when the user denies access to their wallet.
  /// Throws a [WalletNotSupportedException] when the browser can't have access to a wallet.
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

  /// Returns `true` when it is connected to a wallet, `false` otherwise.
  bool get connectedToWallet {
    _logger.v("connectedToWallet");
    return _walletConnected;
  }

  /// Loads a contract from the blockchain and returns it.
  /// If `connectedToWallet == false` this method throws a [WalletNotLoadedException].
  Contract loadContract(final EthAddress address, final String abi) {
    _logger.v("loadContract");

    if (!_walletConnected) {
      throw const WalletNotLoadedException();
    }

    return Contract(address, abi, _provider.getSigner());
  }

  /// Returns the first acccount in the list of currently connected account to the website.
  EthAddress get firstAccount {
    _logger.v("firstAccount");

    if (_accounts.isEmpty) {
      _logger.e("There are no accounts stored.");
      return "";
    }

    return _accounts.first;
  }
}
