/// This is `ServerpodException` that can be used to pass Domain exceptions from the Server to the Client
///
/// You can `throw ServerpodException()`
///
/// Based on issue [#486](https://github.com/serverpod/serverpod/issues/486)
class ServerpodException implements Exception {
  /// Const constructor to pass empty exception with `statusCode 500`
  const ServerpodException();

  @override
  String toString() {
    return 'ServerpodException: Internal server error';
  }
}
