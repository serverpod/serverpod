/// Base exception for OAuth2 token exchange operations.
///
/// All specific OAuth2 token exchange errors should extend this class.
abstract class OAuth2Exception implements Exception {
  /// A human-readable error message.
  final String message;

  /// Creates a new [OAuth2Exception] object
  const OAuth2Exception(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when the token response could not be parsed as valid JSON.
class OAuth2InvalidResponseException extends OAuth2Exception {
  /// Creates a new [OAuth2InvalidResponseException] object
  const OAuth2InvalidResponseException(super.message);
}

/// Thrown when the access token was missing from the token response.
class OAuth2MissingAccessTokenException extends OAuth2Exception {
  /// Creates a new [OAuth2MissingAccessTokenException] object
  const OAuth2MissingAccessTokenException(super.message);
}

/// Thrown when a network error or timeout occurred during the token exchange.
class OAuth2NetworkErrorException extends OAuth2Exception {
  /// Creates a new [OAuth2NetworkErrorException] object
  const OAuth2NetworkErrorException(super.message);
}

/// Thrown for unknown or unexpected errors during the token exchange.
class OAuth2UnknownException extends OAuth2Exception {
  /// Creates a new [OAuth2UnknownException] object
  const OAuth2UnknownException(super.message);
}
