class WalletNotSupportedException implements Exception {
  final String message;

  const WalletNotSupportedException([this.message = ""]);

  @override
  String toString() {
    return "WalletNotSupportedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
