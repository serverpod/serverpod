/// Firebase Exception
abstract class FirebaseException implements Exception {
  /// error message
  final String message;

  /// Creates a new [FirebaseException] object
  FirebaseException(this.message);

  @override
  String toString() => message;
}

/// Firebase Initialization Exception
class FirebasInitException extends FirebaseException {
  /// Creates a new [FirebasInitException] object
  FirebasInitException(super.message);
}

/// Invalid User UIID Exception
class FirebaseInvalidUIIDException extends FirebaseException {
  /// Creates a new [FirebaseInvalidUIIDException] object
  FirebaseInvalidUIIDException(super.message);
}

/// Invalid JWT Exception
class FirebaseJWTException extends FirebaseException {
  /// Creates a new [FirebaseJWTException] object
  FirebaseJWTException(super.message);
}
