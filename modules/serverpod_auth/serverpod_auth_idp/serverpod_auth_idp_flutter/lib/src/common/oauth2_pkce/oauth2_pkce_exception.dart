/// Base exception for OAuth2 PKCE authorization flow.
///
/// All specific OAuth2 PKCE errors should extend this class.
abstract class OAuth2PkceException implements Exception {
  /// A human-readable error message.
  final String message;

  /// Creates a new [OAuth2PkceException] object
  const OAuth2PkceException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when the user cancels the authorization flow.
class OAuth2PkceUserCancelledException extends OAuth2PkceException {
  /// Creates a new [OAuth2PkceUserCancelledException] object
  const OAuth2PkceUserCancelledException(super.message);
}

/// Thrown when state parameter validation fails (possible CSRF attack).
class OAuth2PkceStateMismatchException extends OAuth2PkceException {
  /// Creates a new [OAuth2PkceStateMismatchException] object
  const OAuth2PkceStateMismatchException(super.message);
}

/// Thrown when no authorization code was returned by the provider.
class OAuth2PkceMissingAuthorizationCodeException extends OAuth2PkceException {
  /// Creates a new [OAuth2PkceMissingAuthorizationCodeException] object
  const OAuth2PkceMissingAuthorizationCodeException(super.message);
}

/// Thrown when the provider returned an error response.
class OAuth2PkceProviderErrorException extends OAuth2PkceException {
  /// Creates a new [OAuth2PkceProviderErrorException] object
  const OAuth2PkceProviderErrorException(super.message);
}

/// Thrown when a network or other unexpected error occurred.
class OAuth2PkceUnknownException extends OAuth2PkceException {
  /// Creates a new [OAuth2PkceUnknownException] object
  const OAuth2PkceUnknownException(super.message);
}
