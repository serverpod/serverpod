import 'package:serverpod_serialization/serverpod_serialization.dart';

/// This is `SerializableException` that can be used to pass Domain exceptions
/// from the Server to the Client
///
/// You can `throw SerializableException()`
///
/// Based on issue [#486](https://github.com/serverpod/serverpod/issues/486)
abstract class SerializableException implements SerializableModel, Exception {
  /// Const constructor to pass empty exception with `statusCode 500`
  SerializableException();

  @override
  String toString() {
    return 'ServerpodException: Internal server error';
  }

  @override
  dynamic toJson() {
    return {};
  }
}

/// This is an exception that is thrown when a stream is closed with an error
class StreamClosedWithErrorException implements Exception {
  /// Const constructor to create a new [StreamClosedWithErrorException]
  const StreamClosedWithErrorException();

  @override
  String toString() =>
      'StreamClosedWithErrorException: Stream closed with error';
}
