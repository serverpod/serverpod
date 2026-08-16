/// Result of the OAuth2 sign-in flow.
///
/// Contains the authorization code and optionally the PKCE code verifier that
/// must be sent to the backend to complete authentication.
///
/// The [codeVerifier] is null when the OAuth2 provider doesn't use PKCE
/// (Proof Key for Code Exchange). PKCE is an extension to OAuth2 that
/// provides additional security, particularly for mobile and public clients.
typedef OAuth2PkceResult = ({
  /// The authorization code received from the OAuth2 provider after user
  /// authorization.
  ///
  /// This code is temporary and must be exchanged for an access token on
  /// the backend within a short time (typically 10 minutes).
  String code,

  /// The PKCE code verifier used to generate the code challenge.
  ///
  /// Optional. This is `null` when the OAuth2 provider doesn't use PKCE.
  String? codeVerifier,
});
