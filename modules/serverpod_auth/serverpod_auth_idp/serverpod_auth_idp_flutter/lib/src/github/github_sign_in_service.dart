import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

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
///
/// Example usage:
/// ```dart
/// final service = GitHubSignInService.instance;
/// await service.ensureInitialized(
///   clientId: 'your-github-oauth-client-id',
///   redirectUri: 'customScheme://',
/// );
///
/// final code = await service.signIn();
/// ```
class GitHubSignInService {
  /// Singleton instance of the [GitHubSignInService].
  static final GitHubSignInService instance = GitHubSignInService._internal();

  GitHubSignInService._internal();

  bool _initialized = false;
  String? _state;
  String? _clientId;
  String? _redirectUri;
  String? _codeVerifier;
  String? _callbackUrlScheme;
  bool? _useWebview;

  /// Gets the configured client ID if set.
  String? get clientId => _clientId;

  /// Gets the configured redirect URI if set.
  String? get redirectUri => _redirectUri;

  /// Gets the latest PKCE code verifier.
  ///
  /// This should be sent to your backend along with the authorization code
  /// to exchange for an access token.
  ///
  /// Returns null if no PKCE code verifier has been generated.
  String? get codeVerifier => _codeVerifier;

  /// Gets the configured callback URL scheme if set.
  String? get callbackUrlScheme => _callbackUrlScheme;

  /// Ensures that GitHub Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the configuration. Subsequent calls with
  /// different parameters will be ignored.
  ///
  /// The [clientId] is the OAuth client ID from your GitHub OAuth App.
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  /// The [useWebview] controls the authentication method on Linux and Windows.
  /// **Only has an effect on Linux and Windows!** When set to `true`, uses the
  /// webview implementation. When set to `false`, uses the old approach with an
  /// internal server to fetch the HTTP result.
  /// See [FlutterWebAuth2Options] documentation for more details.
  ///
  /// If [clientId] and [redirectUri] are not provided, will try to load the
  /// values from environment variables `GITHUB_CLIENT_ID` and
  /// `GITHUB_REDIRECT_URI` respectively. If the values are not provided by
  /// any means, an error will be thrown when attempting to sign in.
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

  /// Initiates the GitHub OAuth sign-in flow.
  ///
  /// This method:
  /// 1. Generates a PKCE code verifier and challenge
  /// 2. Opens the GitHub authorization page in a browser/web view
  /// 3. Waits for the user to authorize the app
  /// 4. Extracts the authorization code from the callback
  ///
  /// Returns the authorization code that can be exchanged for an access token
  /// on backend server.
  ///
  /// Throws an exception if:
  /// - The service is not initialized
  /// - The user cancels the authorization
  /// - The authorization fails for any reason
  ///
  /// The [scopes] parameter allows requesting additional GitHub permissions.
  /// By default, only basic profile information is requested.
  Future<String> signIn({List<String> scopes = const []}) async {
    if (_clientId == null || _redirectUri == null) {
      throw StateError(
        'GitHubSignInService is not initialized. '
        'Call ensureInitialized() first.',
      );
    }

    // Generate PKCE code verifier and challenge
    _codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(_codeVerifier!);
    _state = _generateState();

    // Build GitHub authorization URL
    final queryParameters = {
      'client_id': _clientId!,
      'redirect_uri': _redirectUri!,
      'state': _state!,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };

    // Add scope only if specified - GitHub defaults to empty list if omitted
    if (scopes.isNotEmpty) {
      queryParameters['scope'] = scopes.join(' ');
    }

    // Reference: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
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
      if (returnedState == null || returnedState != _state) {
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

      return code;
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
  /// The [redirectUri] is the callback URL registered in your GitHub OAuth App.
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  /// The [useWebview] controls the authentication method on Linux and Windows.
  /// **Only has an effect on Linux and Windows!** When set to `true`, uses the
  /// webview implementation. When set to `false`, uses the old approach with an
  /// internal server to fetch the HTTP result.
  /// See [FlutterWebAuth2Options] documentation for more details.
  ///
  /// If [clientId] and [redirectUri] are not provided, will try to load the
  /// values from `GITHUB_CLIENT_ID` and `GITHUB_REDIRECT_URI` environment
  /// variables, respectively. If the values are not provided by any means, an
  /// error will be thrown when attempting to sign in.
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
String _generateCodeVerifier() {
  final random = Random.secure();
  final bytes = List<int>.generate(32, (i) => random.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
}

/// Generates the PKCE code challenge from the code verifier using SHA-256.
String _generateCodeChallenge(String codeVerifier) {
  final bytes = utf8.encode(codeVerifier);
  final digest = sha256.convert(bytes);
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
}

/// Generates a random state parameter for CSRF protection.
String _generateState() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (i) => random.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
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
