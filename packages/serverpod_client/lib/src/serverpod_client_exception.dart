class ServerpodClientException implements Exception {
  final String message;
  final int statusCode;

  const ServerpodClientException(this.message, this.statusCode);

  String toString() {
    return ('ServerpodClientException: ${message.trim()}, statusCode = $statusCode');
  }
}