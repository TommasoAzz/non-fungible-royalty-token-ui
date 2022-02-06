/// Exception throws when the IPFS node to connect to is not available.
class IpfsConnectionException implements Exception {
  final String message;

  const IpfsConnectionException([this.message = ""]);

  @override
  String toString() {
    return "IpfsConnectionException${message.isNotEmpty ? ' - $message' : ''}";
  }
}
