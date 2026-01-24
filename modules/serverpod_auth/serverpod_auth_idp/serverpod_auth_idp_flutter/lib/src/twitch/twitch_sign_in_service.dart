import 'dart:async';

import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../common/oauth2_pkce/oauth2_pkce_client_config.dart';
import '../common/oauth2_pkce/oauth2_pkce_util.dart';

/// Result of the Twitch OAuth sign-in flow.
///
/// Contains the authorization code and PKCE code verifier that must be sent
/// to your backend endpoint to complete authentication.
typedef TwitchSignInResult = ({
  /// The authorization code received from Twitch after user authorization.
  String code,

  /// The redirect URI that was used for the OAuth flow.
  /// Must be sent to the backend along with the code for token exchange.
  String redirectUri,
});

/// Service to manage Twitch OAuth sign-in flow.
///
/// Ensure it is only initialized once throughout the app lifetime.
///
/// This service handles the OAuth 2.0 authorization code flow with PKCE
/// (Proof Key for Code Exchange) for Twitch authentication.
///
/// Example usage:
/// ```dart
/// // Initialize service (typically in main or during app startup)
/// await TwitchSignInService.instance.ensureInitialized(
///   clientId: 'your-twitch-oauth-client-id',
///   redirectUri: 'customScheme://twitch/auth/callback',
/// );
///
/// // Sign in the user
/// final result = await TwitchSignInService.instance.signIn();
///
/// // Send code to your backend
/// await client.twitchIdp.login(
///   code: result.code,
///   redirectUri: 'customScheme://twitch/auth/callback',
/// );
/// ```
class TwitchSignInService {
  /// Singleton instance of the [TwitchSignInService].
  static final TwitchSignInService instance = TwitchSignInService._internal();

  TwitchSignInService._internal();

  OAuth2PkceProviderClientConfig? _config;
  bool? _useWebview;

  OAuth2PkceUtil get _oauth2Util => OAuth2PkceUtil(
    config: _config!,
    useWebview: _useWebview,
  );

  /// Ensures that Twitch Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the configuration.
  ///
  /// The [clientId] is the OAuth client ID from your Twitch OAuth App.
  ///
  /// The [redirectUri] is the callback URL registered in your Twitch OAuth App.
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
      authorizationEndpoint: Uri.https('id.twitch.tv', '/oauth2/authorize'),
      clientId: clientId,
      redirectUri: redirectUri,
      callbackUrlScheme: callbackUrlScheme ?? Uri.parse(redirectUri).scheme,
    );
    _useWebview = useWebview;
  }

  /// Starts the Twitch OAuth sign-in flow using PKCE.
  ///
  /// Returns authorization code for backend authentication.
  /// [scopes] allows requesting extra Twitch permissions (optional).
  Future<TwitchSignInResult> signIn({
    List<String>? scopes,
  }) async {
    if (_config == null) {
      throw StateError(
        'TwitchSignInService is not initialized. Call ensureInitialized() first.',
      );
    }

    final result = await _oauth2Util.authorize(scopes: scopes);

    return (
      code: result.code,
      redirectUri: _config!.redirectUri,
    );
  }
}

/// Extension on [FlutterAuthSessionManager] to add Twitch Sign-In initialization.
extension TwitchSignInServiceExtension on FlutterAuthSessionManager {
  /// Initializes Twitch Sign-In with the required configuration.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the Twitch Sign-In configuration.
  ///
  /// The [clientId] is the OAuth client ID from your Twitch OAuth App.
  /// If not provided, will try to load from `TWITCH_CLIENT_ID` environment variable.
  ///
  /// The [redirectUri] is the callback URL registered in your Twitch OAuth App.
  /// If not provided, will try to load from `TWITCH_REDIRECT_URI` environment variable.
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  Future<void> initializeTwitchSignIn({
    String? clientId,
    String? redirectUri,
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    final effectiveClientId = clientId ?? _getClientIdFromEnvVar();
    final effectiveRedirectUri = redirectUri ?? _getRedirectUriFromEnvVar();

    if (effectiveClientId == null) {
      throw ArgumentError(
        'Twitch client ID is required. '
        'Provide clientId parameter or set TWITCH_CLIENT_ID environment variable.',
      );
    }

    if (effectiveRedirectUri == null) {
      throw ArgumentError(
        'Twitch redirect URI is required. '
        'Provide redirectUri parameter or set TWITCH_REDIRECT_URI environment variable.',
      );
    }

    await TwitchSignInService.instance.ensureInitialized(
      clientId: effectiveClientId,
      redirectUri: effectiveRedirectUri,
      callbackUrlScheme: callbackUrlScheme,
      useWebview: useWebview,
    );
  }
}

String? _getClientIdFromEnvVar() {
  return const String.fromEnvironment('TWITCH_CLIENT_ID').isNotEmpty
      ? const String.fromEnvironment('TWITCH_CLIENT_ID')
      : null;
}

String? _getRedirectUriFromEnvVar() {
  return const String.fromEnvironment('TWITCH_REDIRECT_URI').isNotEmpty
      ? const String.fromEnvironment('TWITCH_REDIRECT_URI')
      : null;
}
