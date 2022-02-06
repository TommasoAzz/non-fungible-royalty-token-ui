/// Exception thrown when the user is not connected to a crypto wallet.
class WalletNotLoadedException implements Exception {
  final String message;

  const WalletNotLoadedException([this.message = ""]);

  @override
  String toString() {
    return "WalletNotLoadedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
