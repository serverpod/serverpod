/// The reason why an [OAuth2PkceException] was thrown.
enum OAuth2PkceExceptionReason {
  /// User cancelled the authorization flow.
  userCancelled,

  /// State parameter validation failed (possible CSRF attack).
  stateMismatch,

  /// No authorization code was returned by the provider.
  missingAuthorizationCode,

  /// The provider returned an error response.
  providerError,

  /// Network or other unexpected error occurred.
  unknown,
}

/// Exception thrown during OAuth2 PKCE authorization flow.
class OAuth2PkceException implements Exception {
  /// Creates an [OAuth2PkceException] with the given reason and message.
  const OAuth2PkceException({
    required this.reason,
    required this.message,
  });

  /// The reason for the exception.
  final OAuth2PkceExceptionReason reason;

  /// A human-readable error message.
  final String message;

  @override
  String toString() => 'OAuth2PkceException: $message (reason: $reason)';
}
