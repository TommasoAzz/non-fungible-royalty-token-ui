class WalletRejectedException implements Exception {
  final String message;

  const WalletRejectedException([this.message = ""]);

  @override
  String toString() {
    return "WalletRejectedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
