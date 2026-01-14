/// Exception thrown during OAuth2 token exchange operations.
///
/// This exception contains detailed error information from the OAuth2 provider
/// that can be logged on the server side for debugging.
class OAuth2Exception implements Exception {
  /// The OAuth2 error code (e.g., "invalid_grant", "invalid_client").
  final String error;

  /// Optional human-readable error description.
  final String? errorDescription;

  /// Creates a new [OAuth2Exception].
  OAuth2Exception(this.error, {this.errorDescription});

  @override
  String toString() {
    if (errorDescription != null) {
      return 'OAuth2Exception: $error - $errorDescription';
    }
    return 'OAuth2Exception: $error';
  }
}
