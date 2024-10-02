/// Custom exception for invalid header values.
class InvalidHeaderValueException implements Exception {
  final String message;

  InvalidHeaderValueException(this.message);

  @override
  String toString() => 'InvalidHeaderValueException: $message';
}
