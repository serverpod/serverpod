/// An object for internal use to pass along the idToken or serverAuthCode
/// received from google during the sign in process.
class ClientAuthTokens {
  /// The auth token received from google.
  final String? idToken;

  /// The server auth code received from google.
  final String? serverAuthCode;

  /// Creates a new [ClientAuthTokens] object.
  ClientAuthTokens({
    this.idToken,
    this.serverAuthCode,
  });
}

/// Provides a function that attempts to Sign in with Google.
/// Returns a [ClientAuthTokens] with the serverAuthCode or tokenId.
typedef SignInWithGooglePlatform =
    Future<ClientAuthTokens> Function({
      String? clientId,
      String? serverClientId,
      required List<String> scopes,
      required Uri redirectUri,
    });
