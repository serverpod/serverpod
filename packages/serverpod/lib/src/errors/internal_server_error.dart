/// Internal base class for all internal errors thrown by the server.
/// not intended to be used directly.
abstract class InternalServerError extends Error {
  final String _message;

  /// Creates an internal server error with the given message.
  InternalServerError(this._message);

  @override
  String toString() {
    return 'Error: $_message';
  }
}
