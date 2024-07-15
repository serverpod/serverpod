/// This is an exception that is thrown when a stream is closed with an error
class StreamClosedWithErrorException implements Exception {
  /// Const constructor to create a new [StreamClosedWithErrorException]
  const StreamClosedWithErrorException();

  @override
  String toString() =>
      'StreamClosedWithErrorException: Stream closed with error';
}
