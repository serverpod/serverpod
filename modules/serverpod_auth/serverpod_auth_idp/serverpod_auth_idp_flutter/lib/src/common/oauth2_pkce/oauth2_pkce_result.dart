/// Result of the OAuth2 PKCE sign-in flow.
///
/// Contains the authorization code and PKCE code verifier that must be sent
/// to the backend to complete authentication.
typedef OAuth2PkceResult = ({
  /// The authorization code received from the OAuth2 provider after user
  /// authorization.
  ///
  /// This code is temporary and must be exchanged for an access token on
  /// the backend within a short time (typically 10 minutes).
  String code,

  /// The PKCE code verifier that was used to generate the code challenge.
  ///
  /// This must be sent to the backend along with the authorization code.
  /// The backend will use this to verify that the token request is coming
  /// from the same client that initiated the authorization flow.
  String codeVerifier,
});
