class IpfsConnectionException implements Exception {
  final String message;

  const IpfsConnectionException([this.message = ""]);

  @override
  String toString() {
    return "IpfsConnectionException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
