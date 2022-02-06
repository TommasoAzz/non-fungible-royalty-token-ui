/// Exception thrown when the browser does not make any crypto wallet available.
class WalletNotSupportedException implements Exception {
  final String message;

  const WalletNotSupportedException([this.message = ""]);

  @override
  String toString() {
    return "WalletNotSupportedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
