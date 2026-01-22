/// The reason why an [OAuth2Exception] was thrown during token exchange.
enum OAuth2ExceptionReason {
  /// The token response could not be parsed as valid JSON.
  invalidResponse,

  /// The access token was missing from the token response.
  missingAccessToken,

  /// Network error or timeout occurred during the token exchange.
  networkError,

  /// Unknown or unexpected error occurred.
  unknown,
}

/// Exception thrown during OAuth2 token exchange operations.
///
/// This exception is thrown when the OAuth2 token exchange process fails,
/// whether due to invalid credentials, network errors, or provider-specific
/// issues.
class OAuth2Exception implements Exception {
  /// Creates an [OAuth2Exception] with the given reason and message.
  const OAuth2Exception({
    required this.reason,
    required this.message,
  });

  /// The reason for the exception.
  final OAuth2ExceptionReason reason;

  /// A human-readable error message.
  final String message;

  @override
  String toString() => 'OAuth2Exception: $message (reason: $reason)';
}
