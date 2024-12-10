/// Exception for invalid header values.
class InvalidHeaderException implements Exception {
  /// Description of the error.
  final String message;

  /// Type of header that caused the error.
  final String headerType;

  /// Creates an [InvalidHeaderException] with a [message] and the
  /// [headerType] that caused the error.
  InvalidHeaderException(
    this.message, {
    required this.headerType,
  });

  @override
  String toString() {
    return 'Invalid \'$headerType\' header: $message';
  }
}
