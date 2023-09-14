import 'internal_server_error.dart';

/// Thrown when a class is missing a required field.
class MissingFieldError extends InternalServerError {
  /// Creates a [MissingFieldException] with the given class name.
  MissingFieldError(String objectName, String fieldName)
      : super(
            'The field "$fieldName" is null on the object "$objectName", this operation requires "$fieldName" to be defined.');
}
