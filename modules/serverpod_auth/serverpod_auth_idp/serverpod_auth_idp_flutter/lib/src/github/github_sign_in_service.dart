import 'dart:async';

import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../common/oauth2_pkce/oauth2_pkce_config.dart';
import '../common/oauth2_pkce/oauth2_pkce_util.dart';

/// Result of the GitHub OAuth sign-in flow.
///
/// Contains the authorization code and PKCE code verifier that must be sent
/// to your backend endpoint to complete authentication.
typedef GitHubSignInResult = ({
  /// The authorization code received from GitHub after user authorization.
  String code,

  /// The PKCE code verifier that was used to generate the code challenge.
  /// Must be sent to the backend along with the code for token exchange.
  String codeVerifier,

  /// The redirect URI that was used for the OAuth flow.
  /// Must be sent to the backend along with the code for token exchange.
  String redirectUri,
});

/// Service to manage GitHub OAuth sign-in flow.
///
/// Ensure it is only initialized once throughout the app lifetime.
///
/// This service handles the OAuth 2.0 authorization code flow with PKCE
/// (Proof Key for Code Exchange) for GitHub authentication.
///
/// Example usage:
/// ```dart
/// // Initialize service (typically in main or during app startup)
/// await GitHubSignInService.instance.ensureInitialized(
///   clientId: 'your-github-oauth-client-id',
///   redirectUri: 'customScheme://github/auth/callback',
/// );
///
/// // Sign in the user
/// final result = await GitHubSignInService.instance.signIn();
///
/// // Send both code and codeVerifier to your backend
/// await client.githubIdp.login(
///   code: result.code,
///   codeVerifier: result.codeVerifier,
///   redirectUri: 'customScheme://github/auth/callback',
/// );
/// ```
class GitHubSignInService {
  /// Singleton instance of the [GitHubSignInService].
  static final GitHubSignInService instance = GitHubSignInService._internal();

  GitHubSignInService._internal();

  OAuth2PkceProviderClientConfig? _config;
  bool? _useWebview;

  /// Ensures that GitHub Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the configuration.
  ///
  /// The [clientId] is the OAuth client ID from your GitHub OAuth App.
  ///
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  /// When set to `true`, uses the webview implementation. When set to `false`,
  /// uses an internal server approach. Defaults to `true`.
  Future<void> ensureInitialized({
    required String clientId,
    required String redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    if (_config != null) return;

    _config = OAuth2PkceProviderClientConfig(
      authorizationEndpoint: Uri.https(
        'github.com',
        '/login/oauth/authorize',
      ),
      clientId: clientId,
      redirectUri: redirectUri,
      callbackUrlScheme: callbackUrlScheme ?? Uri.parse(redirectUri).scheme,
    );
    _useWebview = useWebview;
  }

  /// Starts the GitHub OAuth sign-in flow using PKCE.
  ///
  /// Returns authorization code and PKCE code verifier for backend authentication.
  /// [scopes] allows requesting extra GitHub permissions (optional).
  Future<GitHubSignInResult> signIn({
    List<String>? scopes,
  }) async {
    if (_config == null) {
      throw StateError(
        'GitHubSignInService is not initialized. Call ensureInitialized() first.',
      );
    }

    final oauth2Util = OAuth2PkceUtil(
      config: _config!,
      useWebview: _useWebview,
    );

    final result = await oauth2Util.authorize(scopes: scopes);

    return (
      code: result.code,
      codeVerifier: result.codeVerifier!,
      redirectUri: _config!.redirectUri,
    );
  }
}

/// Extension on [FlutterAuthSessionManager] to add GitHub Sign-In initialization.
extension GitHubSignInServiceExtension on FlutterAuthSessionManager {
  /// Initializes GitHub Sign-In with the required configuration.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the GitHub Sign-In configuration.
  ///
  /// The [clientId] is the OAuth client ID from your GitHub OAuth App.
  /// If not provided, will try to load from `GITHUB_CLIENT_ID` environment variable.
  ///
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  /// If not provided, will try to load from `GITHUB_REDIRECT_URI` environment variable.
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  Future<void> initializeGitHubSignIn({
    String? clientId,
    String? redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    final effectiveClientId = clientId ?? _getClientIdFromEnvVar();
    final effectiveRedirectUri = redirectUri ?? _getRedirectUriFromEnvVar();

    if (effectiveClientId == null) {
      throw ArgumentError(
        'GitHub client ID is required. '
        'Provide clientId parameter or set GITHUB_CLIENT_ID environment variable.',
      );
    }

    if (effectiveRedirectUri == null) {
      throw ArgumentError(
        'GitHub redirect URI is required. '
        'Provide redirectUri parameter or set GITHUB_REDIRECT_URI environment variable.',
      );
    }

    await GitHubSignInService.instance.ensureInitialized(
      clientId: effectiveClientId,
      redirectUri: effectiveRedirectUri,
      callbackUrlScheme: callbackUrlScheme,
      useWebview: useWebview,
    );
  }
}

String? _getClientIdFromEnvVar() {
  return const String.fromEnvironment('GITHUB_CLIENT_ID').isNotEmpty
      ? const String.fromEnvironment('GITHUB_CLIENT_ID')
      : null;
}

String? _getRedirectUriFromEnvVar() {
  return const String.fromEnvironment('GITHUB_REDIRECT_URI').isNotEmpty
      ? const String.fromEnvironment('GITHUB_REDIRECT_URI')
      : null;
}
