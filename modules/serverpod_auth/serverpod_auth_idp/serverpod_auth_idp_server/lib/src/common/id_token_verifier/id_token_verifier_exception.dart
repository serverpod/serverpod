/// Base exception thrown when ID token validation fails.
///
/// Provider-specific exceptions should extend this class.
class IdTokenValidationException implements Exception {
  /// The exception message that was thrown.
  final String message;

  /// Creates a new instance.
  IdTokenValidationException(this.message);
}
