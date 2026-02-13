import 'dart:async';

import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../common/oauth2_pkce/oauth2_pkce_client_config.dart';
import '../common/oauth2_pkce/oauth2_pkce_util.dart';

/// Result of the Microsoft OAuth sign-in flow.
///
/// Contains the authorization code and PKCE code verifier that must be sent
/// to your backend endpoint to complete authentication.
typedef MicrosoftSignInResult = ({
  /// The authorization code received from Microsoft after user authorization.
  String code,

  /// The PKCE code verifier that was used to generate the code challenge.
  /// Must be sent to the backend along with the code for token exchange.
  String codeVerifier,

  /// The redirect URI that was used for the OAuth flow.
  /// Must be sent to the backend along with the code for token exchange.
  String redirectUri,
});

/// Service to manage Microsoft OAuth sign-in flow.
///
/// Ensure it is only initialized once throughout the app lifetime.
///
/// This service handles the OAuth 2.0 authorization code flow with PKCE
/// (Proof Key for Code Exchange) for Microsoft authentication.
///
/// Example usage:
/// ```dart
/// // Initialize service (typically in main or during app startup)
/// await MicrosoftSignInService.instance.ensureInitialized(
///   clientId: 'your-microsoft-client-id',
///   redirectUri: 'customScheme://microsoft/auth/callback',
///   tenant: 'common',
/// );
///
/// // Sign in the user
/// final result = await MicrosoftSignInService.instance.signIn();
///
/// // Send both code and codeVerifier to your backend
/// await client.microsoftIdp.login(
///   code: result.code,
///   codeVerifier: result.codeVerifier,
///   redirectUri: 'customScheme://microsoft/auth/callback',
/// );
/// ```
class MicrosoftSignInService {
  /// Singleton instance of the [MicrosoftSignInService].
  static final MicrosoftSignInService instance =
      MicrosoftSignInService._internal();

  MicrosoftSignInService._internal();

  OAuth2PkceProviderClientConfig? _config;
  bool? _useWebview;

  OAuth2PkceUtil get _oauth2Util => OAuth2PkceUtil(
    config: _config!,
    useWebview: _useWebview,
  );

  /// Ensures that Microsoft Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the configuration.
  ///
  /// The [clientId] is the Application (client) ID from your Microsoft Entra ID app.
  ///
  /// The [redirectUri] is the callback URL registered in your Microsoft Entra ID app.
  ///
  /// The [tenant] specifies which accounts can sign in:
  /// - `common` (default): Personal and work/school accounts
  /// - `organizations`: Work/school accounts only
  /// - `consumers`: Personal Microsoft accounts only
  /// - Specific tenant ID: Accounts from a specific organization
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
    String tenant = 'common',
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    if (_config != null) return;

    _config = OAuth2PkceProviderClientConfig(
      authorizationEndpoint: Uri.https(
        'login.microsoftonline.com',
        '/$tenant/oauth2/v2.0/authorize',
      ),
      clientId: clientId,
      redirectUri: redirectUri,
      callbackUrlScheme: callbackUrlScheme ?? Uri.parse(redirectUri).scheme,
    );
    _useWebview = useWebview;
  }

  /// Starts the Microsoft OAuth sign-in flow using PKCE.
  ///
  /// Returns authorization code and PKCE code verifier for backend authentication.
  /// [scopes] allows requesting extra Microsoft permissions (optional).
  Future<MicrosoftSignInResult> signIn({
    List<String>? scopes,
  }) async {
    if (_config == null) {
      throw StateError(
        'MicrosoftSignInService is not initialized. Call ensureInitialized() first.',
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

/// Extension on [FlutterAuthSessionManager] to add Microsoft Sign-In initialization.
extension MicrosoftSignInServiceExtension on FlutterAuthSessionManager {
  /// Initializes Microsoft Sign-In with the required configuration.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the Microsoft Sign-In configuration.
  ///
  /// The [clientId] is the Application (client) ID from your Microsoft Entra ID app.
  /// If not provided, will try to load from `MICROSOFT_CLIENT_ID` environment variable.
  ///
  /// The [redirectUri] is the callback URL registered in your Microsoft Entra ID app.
  /// If not provided, will try to load from `MICROSOFT_REDIRECT_URI` environment variable.
  ///
  /// The [tenant] specifies which accounts can sign in (defaults to 'common').
  ///
  /// The [callbackUrlScheme] is the URL scheme for the OAuth callback. If not
  /// provided, defaults to the scheme from [redirectUri].
  ///
  /// The [useWebview] controls the authentication method on Linux and Windows.
  Future<void> initializeMicrosoftSignIn({
    String? clientId,
    String? redirectUri,
    String tenant = 'common',
    String? callbackUrlScheme,
    bool? useWebview,
  }) async {
    final effectiveClientId = clientId ?? _getClientIdFromEnvVar();
    final effectiveRedirectUri = redirectUri ?? _getRedirectUriFromEnvVar();

    if (effectiveClientId == null) {
      throw ArgumentError(
        'Microsoft client ID is required. '
        'Provide clientId parameter or set MICROSOFT_CLIENT_ID environment variable.',
      );
    }

    if (effectiveRedirectUri == null) {
      throw ArgumentError(
        'Microsoft redirect URI is required. '
        'Provide redirectUri parameter or set MICROSOFT_REDIRECT_URI environment variable.',
      );
    }

    await MicrosoftSignInService.instance.ensureInitialized(
      clientId: effectiveClientId,
      redirectUri: effectiveRedirectUri,
      tenant: tenant,
      callbackUrlScheme: callbackUrlScheme,
      useWebview: useWebview,
    );
  }

  String? _getClientIdFromEnvVar() {
    const clientIdVarName = 'MICROSOFT_CLIENT_ID';
    return const String.fromEnvironment(clientIdVarName).isEmpty
        ? null
        : const String.fromEnvironment(clientIdVarName);
  }

  String? _getRedirectUriFromEnvVar() {
    const redirectUriVarName = 'MICROSOFT_REDIRECT_URI';
    return const String.fromEnvironment(redirectUriVarName).isEmpty
        ? null
        : const String.fromEnvironment(redirectUriVarName);
  }
}
