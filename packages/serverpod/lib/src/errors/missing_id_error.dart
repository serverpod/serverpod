import 'internal_server_error.dart';

/// Thrown when a class is missing an id.
class MissingIdError extends InternalServerError {
  /// Creates a [MissingIdException] with the given class name.
  MissingIdError(String objectName)
      : super(
            'The $objectName does not have an id set, this operation requires the object to exist in the database.');
}
