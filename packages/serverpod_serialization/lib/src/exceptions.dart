import 'package:serverpod_serialization/serverpod_serialization.dart';

/// This is `SerializableException` that can be used to pass Domain exceptions 
/// from the Server to the Client
///
/// You can `throw SerializableException()`
///
/// Based on issue [#486](https://github.com/serverpod/serverpod/issues/486)
abstract class SerializableException extends SerializableEntity
    implements Exception {
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
