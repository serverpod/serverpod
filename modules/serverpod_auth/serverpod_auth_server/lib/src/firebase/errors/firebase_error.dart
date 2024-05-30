/// FirebaseError
class FirebaseError implements Exception {
  /// error message
  final String message;

  /// Creates a new [FirebaseError] object
  FirebaseError(this.message);

  @override
  String toString() => message;
}
