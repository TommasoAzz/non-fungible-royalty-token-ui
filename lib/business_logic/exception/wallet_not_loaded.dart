class WalletNotLoadedException implements Exception {
  final String message;

  const WalletNotLoadedException([this.message = ""]);

  @override
  String toString() {
    return "WalletNotLoadedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
