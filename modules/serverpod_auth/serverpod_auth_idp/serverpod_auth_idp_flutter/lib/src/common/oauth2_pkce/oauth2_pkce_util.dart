import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../utils.dart';
import 'oauth2_pkce_config.dart';
import 'oauth2_pkce_result.dart';

/// Generic utility for OAuth2 PKCE (Proof Key for Code Exchange) authorization.
///
/// Handles the client-side OAuth2 authorization code flow with PKCE for any
/// OAuth2 provider. Automatically manages:
/// - PKCE code generation (verifier and challenge) for security
/// - State parameter generation for CSRF protection
/// - Authorization URL construction with provider-specific parameters
/// - Browser/web view launching and callback handling
///
/// {@template oauth2_pkce_util}
/// The OAuth2 PKCE flow:
/// 1. Generate a random code verifier
/// 2. Generate a code challenge from the verifier (SHA-256 hash, base64url encoded)
/// 3. Redirect user to provider's authorization page with code challenge
/// 4. User authorizes the application
/// 5. Provider redirects back with an authorization code
/// 6. Return both the code and code verifier to be sent to the backend
/// 7. Backend exchanges code + verifier for access token
///
/// PKCE ensures that even if an attacker intercepts the authorization code,
/// they cannot exchange it for an access token without the code verifier.
/// {@endtemplate}
///
/// ## Usage Example
///
/// ```dart
/// // 1. Create a provider-specific configuration
/// final config = MyProviderConfig(
///   clientId: 'your-oauth-client-id',
///   redirectUri: 'com.example.app://oauth/callback',
///   callbackUrlScheme: 'com.example.app',
/// );
///
/// // 2. Create the utility
/// final oauth2Util = OAuth2PkceUtil(config: config);
///
/// // 3. Initiate authorization flow
/// final result = await oauth2Util.authorize(scopes: ['read', 'write']);
///
/// // 4. Send to backend for token exchange
/// await client.myProviderIdp.authenticate(
///   code: result.code,
///   codeVerifier: result.codeVerifier,
///   redirectUri: config.redirectUri,
/// );
/// ```
class OAuth2PkceUtil {
  /// The provider-specific configuration.
  final OAuth2PkceProviderConfig config;

  /// Controls the authentication method on Linux and Windows.
  ///
  /// **Only has an effect on Linux and Windows!** When set to `true`, uses the
  /// webview implementation. When set to `false`, uses the old approach with an
  /// internal server to fetch the HTTP result. Defaults to `true`.
  ///
  /// See [FlutterWebAuth2Options] documentation for more details.
  final bool? useWebview;

  /// Creates a new [OAuth2PkceUtil] with the given configuration.
  OAuth2PkceUtil({
    required this.config,
    this.useWebview,
  });

  /// Initiates the OAuth2 PKCE authorization flow.
  ///
  /// **Flow:**
  /// 1. Generates PKCE code verifier and SHA-256 code challenge
  /// 2. Generates random state parameter for CSRF protection
  /// 3. Constructs authorization URL with all parameters
  /// 4. Launches browser/web view to provider's authorization page
  /// 5. Waits for user to authorize (or deny) the application
  /// 6. Captures callback and validates state parameter
  /// 7. Extracts and returns authorization code with code verifier
  ///
  /// **Parameters:**
  /// - [scopes]: Permissions to request. If null, uses [OAuth2PkceProviderConfig.defaultScopes]
  /// - [authCodeParams]: Additional dynamic parameters to include in the authorization
  ///   request. These are merged with [OAuth2PkceProviderConfig.additionalAuthParams],
  ///   with these dynamic params taking precedence if keys conflict.
  ///
  /// **Returns:**
  /// [OAuth2PkceResult] with authorization code and code verifier.
  /// **Both must be sent to your backend** to exchange for an access token.
  ///
  /// **Throws:**
  /// - User cancels authorization
  /// - State parameter mismatch (security validation failure)
  /// - Provider returns error response
  /// - Missing authorization code in callback
  Future<OAuth2PkceResult> authorize({
    List<String>? scopes,
    Map<String, String>? authCodeParams,
  }) async {
    // Generate random state and PKCE parameters
    final state = config.enableState ? _generateState() : null;
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    // Build the authorization URL
    final authorizationUrl = _buildAuthorizationUrl(
      state: state,
      codeChallenge: codeChallenge,
      scopes: scopes ?? config.defaultScopes,
      authCodeParams: authCodeParams,
    );

    try {
      // Launch the authorization URL
      final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: config.callbackUrlScheme,
        options: FlutterWebAuth2Options(useWebview: useWebview),
      );

      // Parse the callback URI
      final uri = Uri.parse(result);
      final queryParams = uri.queryParameters;

      // Validate state parameter (CSRF protection)
      if (config.enableState) {
        final returnedState = queryParams['state'];
        if (returnedState == null || returnedState != state) {
          throw Exception(
            'Security validation failed: State mismatch or missing.',
          );
        }
      }

      // Extract authorization code
      final code = queryParams['code'];
      if (code == null || code.isEmpty) {
        final error = queryParams['error'];
        final errorDescription = queryParams['error_description'];

        if (error != null) {
          throw Exception(
            'Authorization failed: $error'
            '${errorDescription != null ? ' - $errorDescription' : ''}',
          );
        }

        throw Exception(
          'Authorization failed: No code returned from provider.',
        );
      }

      return (code: code, codeVerifier: codeVerifier);
    } catch (e) {
      debugPrint('OAuth2 PKCE sign-in failed: ${e.toString()}');
      rethrow;
    }
  }

  /// Builds the authorization URL with all required parameters.
  Uri _buildAuthorizationUrl({
    required String? state,
    required String codeChallenge,
    required List<String> scopes,
    Map<String, String>? authCodeParams,
  }) {
    final queryParameters = {
      'client_id': config.clientId,
      'redirect_uri': config.redirectUri,
      'response_type': 'code',
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      ...config.additionalAuthParams,
    };

    // Add state parameter if enabled
    if (config.enableState && state != null && state.isNotEmpty) {
      queryParameters['state'] = state;
    }

    // Add scope only if specified
    if (scopes.isNotEmpty) {
      queryParameters['scope'] = scopes.join(config.scopeSeparator);
    }

    // Add dynamic authorization code parameters (override static ones if conflicts)
    if (authCodeParams != null) {
      queryParameters.addAll(authCodeParams);
    }

    return config.authorizationEndpoint.replace(
      queryParameters: queryParameters,
    );
  }
}

/// Generates a cryptographically secure random string for the PKCE code verifier.
///
/// The code verifier should be a high-entropy cryptographic random string with
/// at least 256 bits of entropy (43-128 characters from the unreserved
/// character set).
String _generateCodeVerifier() => generateSecureRandomString(32);

/// Generates a random state parameter for CSRF protection.
///
/// The state parameter is used to prevent CSRF attacks by ensuring that the
/// authorization response matches the request.
String _generateState() => generateSecureRandomString(16);

/// Generates the PKCE code challenge from the code verifier using SHA-256.
///
/// The code challenge is derived from the code verifier by:
/// 1. Computing the SHA-256 hash of the code verifier
/// 2. Base64url encoding the hash (without padding)
String _generateCodeChallenge(String codeVerifier) {
  final bytes = utf8.encode(codeVerifier);
  final digest = sha256.convert(bytes);
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
}
