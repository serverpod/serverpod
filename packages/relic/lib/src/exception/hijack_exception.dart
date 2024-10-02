/// An exception used to indicate that a request has been hijacked.
///
/// This shouldn't be captured by any code other than the relic server adapter that
/// created the hijackable request. Middleware that captures exceptions should
/// make sure to pass on HijackExceptions.
///
/// See also [Request.hijack].
class HijackException implements Exception {
  const HijackException();

  @override
  String toString() =>
      "A relic server request's underlying data stream was hijacked.\n"
      'This exception is used for control flow and should only be handled by a '
      'relic server adapter.';
}
