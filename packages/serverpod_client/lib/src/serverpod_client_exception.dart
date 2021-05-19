/// [Exception] thrown when errors in communication with the server occurs.
class ServerpodClientException implements Exception {
  /// Error message sent from the server.
  final String message;

  /// Http status code associated with the error.
  final int statusCode;

  /// Creates a new [ServerpodClientException].
  const ServerpodClientException(this.message, this.statusCode);

  @override
  String toString() {
    return ('ServerpodClientException: ${message.trim()}, statusCode = $statusCode');
  }
}