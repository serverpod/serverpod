import '../common/oauth2_pkce/oauth2_pkce_client_config.dart';
import '../common/oauth2_pkce/oauth2_pkce_util.dart';

/// Result of the Google web OAuth sign-in flow.
///
/// Contains the authorization code and PKCE code verifier that must be sent
/// to your backend endpoint to complete authentication.
typedef GoogleWebSignInResult = ({
  /// The authorization code received from Google after user authorization.
  String code,

  /// The PKCE code verifier used to generate the code challenge.
  ///
  /// Must be sent to the backend along with [code] for token exchange.
  String codeVerifier,

  /// The redirect URI used for the OAuth flow.
  ///
  /// Must be sent to the backend along with [code] for token exchange.
  String redirectUri,
});

/// Service to manage Google OAuth sign-in on the web platform.
///
/// Handles the OAuth 2.0 authorization code flow with PKCE (Proof Key for Code
/// Exchange) for Google authentication on web. Uses [flutter_web_auth_2] to
/// open the browser to Google's authorization page and capture the callback
/// via `window.postMessage`.
///
/// This service is intended **for web only**. On native platforms (iOS,
/// Android, macOS), use [GoogleSignInService] with the `google_sign_in`
/// package instead. The [GoogleAuthController] dispatches to this service
/// automatically when running on web.
///
/// Example usage:
///
/// ```dart
/// // Initialize once during app startup (web only)
/// await client.auth.initializeGoogleWebSignIn(
///   clientId: 'your-client-id.apps.googleusercontent.com',
///   redirectUri: 'https://yourdomain.com/auth.html',
/// );
///
/// // Sign in
/// final result = await GoogleWebSignInService.instance.signIn();
///
/// // Send result to backend
/// await endpoint.loginWithCode(
///   code: result.code,
///   codeVerifier: result.codeVerifier,
///   redirectUri: result.redirectUri,
/// );
/// ```
class GoogleWebSignInService {
  /// Singleton instance of the [GoogleWebSignInService].
  static final GoogleWebSignInService instance =
      GoogleWebSignInService._internal();

  GoogleWebSignInService._internal();

  OAuth2PkceProviderClientConfig? _config;
  bool? _useWebview;

  OAuth2PkceUtil get _oauth2Util => OAuth2PkceUtil(
    config: _config!,
    useWebview: _useWebview,
  );

  /// Whether the service has been initialized with a redirect URI.
  ///
  /// When `true`, the OAuth2 PKCE web flow is active and [GoogleSignInWidget]
  /// will show a Flutter-rendered button that triggers [signIn].
  ///
  /// When `false`, [GoogleSignInWidget] falls back to the Google-hosted iFrame
  /// button or the native `google_sign_in` flow.
  bool get isInitialized => _config != null;

  /// Default OAuth scopes for Google sign-in.
  ///
  /// The `openid` scope is required so that Google's token endpoint returns an
  /// `id_token`, which is used for server-side JWKS verification.
  static const List<String> defaultScopes = [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  /// Ensures that Google web sign-in is initialized.
  ///
  /// This method is idempotent - only the first call has effect.
  ///
  /// [clientId] is the **Web application** OAuth client ID from Google Cloud
  /// Console. This must be the `Web application` credential type.
  ///
  /// [redirectUri] is the full URL to the `auth.html` file on your web server:
  /// - Production: `'https://yourdomain.com/auth.html'`
  /// - Local dev: `'http://localhost:PORT/auth.html'`
  ///
  /// This URI must be listed under **Authorized redirect URIs** for the web
  /// credential in Google Cloud Console.
  ///
  /// [callbackUrlScheme] is the URL scheme used for the OAuth callback.
  /// Defaults to the scheme extracted from [redirectUri] (`https` or `http`).
  ///
  /// [additionalAuthParams] are extra parameters merged into the authorization
  /// URL. The service already sends `prompt: select_account` and
  /// `access_type: online` by default. Any values provided here are merged
  /// on top and will override the defaults on conflict.
  ///
  /// [useWebview] controls the authentication method on Linux and Windows.
  /// When `true`, uses the webview implementation (default).
  Future<void> ensureInitialized({
    required String clientId,
    required String redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
    Map<String, String> additionalAuthParams = const {},
  }) async {
    if (_config != null) return;

    _useWebview = useWebview;
    _config = OAuth2PkceProviderClientConfig(
      authorizationEndpoint: Uri.https(
        'accounts.google.com',
        '/o/oauth2/v2/auth',
      ),
      clientId: clientId,
      redirectUri: redirectUri,
      callbackUrlScheme: callbackUrlScheme ?? Uri.parse(redirectUri).scheme,
      defaultScopes: defaultScopes,
      additionalAuthParams: {
        'prompt': 'select_account',
        'access_type': 'online',
        ...additionalAuthParams,
      },
    );
  }

  /// Starts the Google web OAuth sign-in flow using PKCE.
  ///
  /// Opens the browser to Google's authorization page. After the user
  /// authorizes the app, the browser redirects to `auth.html`, which posts
  /// the result back to Flutter via `window.postMessage`.
  ///
  /// [scopes] overrides the [defaultScopes] when provided.
  ///
  /// Returns a [GoogleWebSignInResult] with the authorization [code],
  /// [codeVerifier], and [redirectUri]. All three must be forwarded to
  /// the backend endpoint to complete the token exchange.
  ///
  /// Throws [StateError] if called before [ensureInitialized].
  Future<GoogleWebSignInResult> signIn({
    List<String>? scopes,
  }) async {
    if (_config == null) {
      throw StateError(
        'GoogleWebSignInService is not initialized. '
        'Call ensureInitialized() or initializeGoogleWebSignIn() first.',
      );
    }

    final result = await _oauth2Util.authorize(scopes: scopes);

    return (
      code: result.code,
      codeVerifier: result.codeVerifier!,
      redirectUri: _config!.redirectUri,
    );
  }
}
