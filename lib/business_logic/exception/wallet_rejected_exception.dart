/// Exception thrown when the user rejects the crypto wallet request for connection
/// to the website.
class WalletRejectedException implements Exception {
  final String message;

  const WalletRejectedException([this.message = ""]);

  @override
  String toString() {
    return "WalletRejectedException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
