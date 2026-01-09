import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../common/utils.dart';

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
});

/// Service to manage GitHub OAuth sign-in flow.
///
/// This service handles the OAuth 2.0 authorization code flow with PKCE
/// (Proof Key for Code Exchange) for GitHub authentication. It is implemented
/// as a singleton to ensure consistent state management throughout the app
/// lifetime.
///
/// The service automatically handles:
/// - PKCE generation for enhanced security
/// - OAuth redirect URI handling
/// - State parameter for CSRF protection
///
/// Example usage:
/// ```dart
/// // 1. Initialize the service (typically in main or during app startup)
/// await GitHubSignInService.instance.ensureInitialized(
///   clientId: 'your-github-oauth-client-id',
///   redirectUri: 'customScheme://github/auth/callback',
/// );
///
/// // 2. Sign in the user
/// final result = await GitHubSignInService.instance.signIn();
///
/// // 3. Send both code and codeVerifier to your backend
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

  bool _initialized = false;
  String? _clientId;
  String? _redirectUri;
  String? _callbackUrlScheme;
  bool? _useWebview;

  /// Returns whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Gets the configured client ID if set.
  String? get clientId => _clientId;

  /// Gets the configured redirect URI if set.
  String? get redirectUri => _redirectUri;

  /// Gets the configured callback URL scheme if set.
  String? get callbackUrlScheme => _callbackUrlScheme;

  /// Ensures that GitHub Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the configuration. Subsequent calls with
  /// different parameters will be ignored.
  ///
  /// The [clientId] is the OAuth client ID from your GitHub OAuth App.
  ///
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  /// **Only has an effect on Linux and Windows!** When set to `true`, uses the
  /// webview implementation. When set to `false`, uses the old approach with an
  /// internal server to fetch the HTTP result. Defaults to `true`.
  /// See [FlutterWebAuth2Options] documentation for more details.
  ///
  /// If [clientId] and [redirectUri] are not provided, will try to load the
  /// values from environment variables `GITHUB_CLIENT_ID` and
  /// `GITHUB_REDIRECT_URI` respectively. If the values are not provided by
  /// any means, an error will be thrown in the [signIn] method.
  Future<void> ensureInitialized({
    String? clientId,
    String? redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    if (_initialized) return;

    _clientId = clientId ?? _getClientIdFromEnvVar();
    _redirectUri = redirectUri ?? _getRedirectUriFromEnvVar();
    _callbackUrlScheme = callbackUrlScheme;
    _useWebview = useWebview;
    _initialized = true;
  }

  /// Initiates the GitHub OAuth sign-in flow using PKCE.
  ///
  /// This method:
  /// 1. Generates a PKCE code verifier and challenge for enhanced security
  /// 2. Opens the GitHub authorization page in a browser/web view
  /// 3. Waits for the user to authorize the app
  /// 4. Returns the authorization code and code verifier
  ///
  /// Returns a [GitHubSignInResult] containing the authorization code and PKCE
  /// code verifier. Both values must be sent to your backend endpoint to
  /// complete authentication. The backend will exchange them for an access token.
  ///
  /// Example:
  /// ```dart
  /// final result = await GitHubSignInService.instance.signIn();
  /// await client.githubIdp.login(
  ///   code: result.code,
  ///   codeVerifier: result.codeVerifier,
  ///   redirectUri: 'your-redirect-uri',
  /// );
  /// ```
  ///
  /// Throws an exception if:
  /// - The service is not initialized with valid clientId and redirectUri
  /// - The user cancels the authorization
  /// - The authorization fails for any reason
  ///
  /// The [scopes] parameter allows requesting additional GitHub permissions.
  /// By default, only basic profile information is requested.
  Future<GitHubSignInResult> signIn({
    List<String> scopes = const [],
  }) async {
    if (!isInitialized) {
      throw StateError(
        'GitHubSignInService is not initialized. '
        'Call ensureInitialized() first.',
      );
    }

    if (_clientId == null || _clientId!.isEmpty) {
      throw StateError(
        'GitHub client ID is not configured. '
        'Provide clientId to ensureInitialized() or set GITHUB_CLIENT_ID '
        'environment variable.',
      );
    }

    if (_redirectUri == null || _redirectUri!.isEmpty) {
      throw StateError(
        'GitHub redirect URI is not configured. '
        'Provide redirectUri to ensureInitialized() or set '
        'GITHUB_REDIRECT_URI environment variable.',
      );
    }

    // Generate random state and PKCE code verifier and code challenge
    final state = _generateState();
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    // Build GitHub authorization URL
    final queryParameters = {
      'client_id': _clientId!,
      'redirect_uri': _redirectUri!,
      'state': state,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };

    // Add scope only if specified - GitHub defaults to empty list if omitted
    if (scopes.isNotEmpty) {
      queryParameters['scope'] = scopes.join(' ');
    }

    // Create the authorization URL
    // More info on the authorization url:
    // https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
    final authorizationUrl = Uri.https(
      'github.com',
      '/login/oauth/authorize',
      queryParameters,
    );

    try {
      // Launch the authorization URL
      final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme:
            _callbackUrlScheme ?? Uri.parse(_redirectUri!).scheme,
        options: FlutterWebAuth2Options(useWebview: _useWebview),
      );

      final uri = Uri.parse(result);
      final queryParams = uri.queryParameters;

      // 1. Validate State (Security check)
      final returnedState = queryParams['state'];
      if (returnedState == null || returnedState != state) {
        throw Exception(
          'Security validation failed: State mismatch or missing.',
        );
      }

      // 2. Extract Code
      final code = queryParams['code'];
      if (code == null || code.isEmpty) {
        throw Exception(
          'Authorization failed: No code returned from provider.',
        );
      }

      return (code: code, codeVerifier: codeVerifier);
    } catch (e) {
      debugPrint('GitHub sign-in failed: ${e.toString()}');
      rethrow;
    }
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
  ///
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  /// **Only has an effect on Linux and Windows!** When set to `true`, uses the
  /// webview implementation. When set to `false`, uses the old approach with an
  /// internal server to fetch the HTTP result.
  /// See [FlutterWebAuth2Options] documentation for more details.
  ///
  /// If [clientId] and [redirectUri] are not provided, will try to load the
  /// values from `GITHUB_CLIENT_ID` and `GITHUB_REDIRECT_URI` environment
  /// variables, respectively. If the values are not provided by any means, an
  /// error will be thrown in the sign-in method.
  Future<void> initializeGitHubSignIn({
    String? clientId,
    String? redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    await GitHubSignInService.instance.ensureInitialized(
      clientId: clientId,
      redirectUri: redirectUri,
      callbackUrlScheme: callbackUrlScheme,
      useWebview: useWebview,
    );
  }
}

/// Generates a cryptographically secure random string for the PKCE code verifier.
String _generateCodeVerifier() => generateSecureRandomString(32);

/// Generates a random state parameter for CSRF protection.
String _generateState() => generateSecureRandomString(16);

/// Generates the PKCE code challenge from the code verifier using SHA-256.
String _generateCodeChallenge(String codeVerifier) {
  final bytes = utf8.encode(codeVerifier);
  final digest = sha256.convert(bytes);
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
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
