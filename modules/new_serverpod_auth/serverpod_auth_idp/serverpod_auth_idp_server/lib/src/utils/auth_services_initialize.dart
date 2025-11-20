import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';

/// Type alias for the function to get configuration values from Serverpod.
typedef GetConfigurationFunction = String? Function(String key);

/// Extension to initialize the AuthServices with the default configuration.
extension AuthServicesInit on Serverpod {
  /// Initializes the AuthServices with the default configuration.
  ///
  /// This method simplifies the setup of the authentication services by
  /// automatically configuring all identity providers and token managers
  /// according to the configuration accessed through the [getConfigFunction].
  /// By default, the [getConfigFunction] uses the [Serverpod.getPassword]
  /// method to get the configuration values from the `passwords.yaml` file.
  ///
  /// Check the default generated `passwords.yaml` file for all configuration
  /// keys and their required values. Note that if any required key for a given
  /// identity provider is not set, the identity provider will not be set.
  ///
  /// The [preferJwtAsPrimaryTokenManager] parameter offer the choice between
  /// using JWT as primary token manager instead of server-side session tokens.
  /// This is a preference that will only be used if both token managers are
  /// configured. If only one token manager is configured, it will be used as
  /// the primary token manager regardless of the preference.
  ///
  /// If [tokenManagers] is provided, the [preferJwtAsPrimaryTokenManager]
  /// parameter will be ignored. The first token manager in the list will then
  /// be used as the primary token manager, and the rest as additional token
  /// managers.
  ///
  /// The [EmailIDP] identity provider usually require additional configuration
  /// that goes beyond basic string values, such as the callback functions to
  /// send verification codes. To supply such configuration, this exposes the
  /// [emailIDPOptions] parameter.
  ///
  /// Use the [additionalIdentityProviders] parameter to also include extra or
  /// custom identity providers.
  void initializeAuthServices({
    final EmailIDPOptions? emailIDPOptions,
    final bool preferJwtAsPrimaryTokenManager = true,
    List<TokenManagerFactory>? tokenManagers,
    final List<IdentityProviderFactory<Object>>? additionalIdentityProviders,
    final GetConfigurationFunction? getConfigFunction,
  }) {
    final getConfig = getConfigFunction ?? getPassword;

    tokenManagers ??= _getTokenManager(
      getConfig,
      preferJwtAsPrimaryTokenManager,
    );

    final identityProviders = _getIdentityProviders(
      getConfig,
      emailIDPOptions,
    );

    AuthServices.set(
      primaryTokenManager: tokenManagers.first,
      identityProviders: [
        ...identityProviders,
        ...(additionalIdentityProviders ?? []),
      ],
      additionalTokenManagers: tokenManagers.skip(1).toList(),
    );

    authenticationHandler = AuthServices.instance.authenticationHandler;

    // NOTE: Only try to configure the routes for Apple IDP if it is configured
    // using the default configuration (not passed as an additional identity
    // provider). In such cases, the user is expected to configure the routes
    // manually, since the provider has been configured manually as well.
    if (identityProviders
        .whereType<AppleIdentityProviderFactory>()
        .isNotEmpty) {
      final revokedNotificationRoute = getConfig(
        'appleRevokedNotificationRoute',
      );
      final webAuthenticationCallbackRoute = getConfig(
        'appleWebAuthenticationCallbackRoute',
      );

      if (revokedNotificationRoute == null ||
          webAuthenticationCallbackRoute == null) {
        throw StateError(
          'Apple revoked notification route and web authentication callback '
          'route must be configured. Set both "appleRevokedNotificationRoute" '
          'and "appleWebAuthenticationCallbackRoute" in the configuration.',
        );
      }

      webServer.addRoute(
        AuthServices.instance.appleIDP.revokedNotificationRoute(),
        revokedNotificationRoute,
      );
      webServer.addRoute(
        AuthServices.instance.appleIDP.webAuthenticationCallbackRoute(),
        webAuthenticationCallbackRoute,
      );
    }
  }
}

List<TokenManagerFactory> _getTokenManager(
  final GetConfigurationFunction getConfig,
  final bool useJwtAsPrimaryTokenManager,
) {
  final sessionKeyHashPepper = getConfig(
    'authSessionsSessionKeyHashPepper',
  );
  final refreshTokenHashPepper = getConfig(
    'authenticationTokenRefreshTokenHashPepper',
  );
  final privateKey = getConfig(
    'authenticationTokenPrivateKey',
  );

  final tokenManagers = <TokenManagerFactory>[
    if (refreshTokenHashPepper != null && privateKey != null)
      AuthenticationTokensTokenManagerFactory(
        AuthenticationTokenConfig(
          refreshTokenHashPepper: refreshTokenHashPepper,
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey(privateKey),
          ),
        ),
      ),
    if (sessionKeyHashPepper != null)
      AuthSessionsTokenManagerFactory(
        AuthSessionsConfig(sessionKeyHashPepper: sessionKeyHashPepper),
      ),
  ];

  if (tokenManagers.isEmpty) {
    throw StateError(
      'No token managers configured. Review the configuration to ensure that '
      'all required keys for at least one token manager are set.',
    );
  }

  if (tokenManagers.length > 1 && !useJwtAsPrimaryTokenManager) {
    tokenManagers.insert(0, tokenManagers.removeLast());
  }
  return tokenManagers;
}

List<IdentityProviderFactory<Object>> _getIdentityProviders(
  final GetConfigurationFunction getConfig,
  final EmailIDPOptions? emailIDPOptions,
) {
  return [
    _getEmailIdentityProvider(getConfig, emailIDPOptions),
    _getGoogleIdentityProvider(getConfig),
    _getAppleIdentityProvider(getConfig),
    _getPasskeyIdentityProvider(getConfig),
  ].cast<IdentityProviderFactory<Object>>();
}

EmailIdentityProviderFactory? _getEmailIdentityProvider(
  final GetConfigurationFunction getConfig,
  final EmailIDPOptions? emailIDPOptions,
) {
  final emailSecretHashPepper = getConfig('emailSecretHashPepper');
  if (emailSecretHashPepper == null) return null;
  return EmailIdentityProviderFactory(
    EmailIDPConfig.fromOptions(
      emailSecretHashPepper,
      emailIDPOptions ?? const EmailIDPOptions(),
    ),
  );
}

GoogleIdentityProviderFactory? _getGoogleIdentityProvider(
  final GetConfigurationFunction getConfig,
) {
  final googleClientSecret = getConfig('googleClientSecret');
  if (googleClientSecret == null) return null;
  return GoogleIdentityProviderFactory(
    GoogleIDPConfig(
      clientSecret: GoogleClientSecret.fromJsonString(
        googleClientSecret,
      ),
    ),
  );
}

AppleIdentityProviderFactory? _getAppleIdentityProvider(
  final GetConfigurationFunction getConfig,
) {
  final appleServiceIdentifier = getConfig('appleServiceIdentifier');
  final appleBundleIdentifier = getConfig('appleBundleIdentifier');
  final appleRedirectUri = getConfig('appleRedirectUri');
  final appleTeamId = getConfig('appleTeamId');
  final appleKeyId = getConfig('appleKeyId');
  final appleKey = getConfig('appleKey');

  if (appleServiceIdentifier == null ||
      appleBundleIdentifier == null ||
      appleRedirectUri == null ||
      appleTeamId == null ||
      appleKeyId == null ||
      appleKey == null) {
    return null;
  }

  return AppleIdentityProviderFactory(
    AppleIDPConfig(
      serviceIdentifier: appleServiceIdentifier,
      bundleIdentifier: appleBundleIdentifier,
      redirectUri: appleRedirectUri,
      teamId: appleTeamId,
      keyId: appleKeyId,
      key: appleKey,
    ),
  );
}

PasskeyIdentityProviderFactory? _getPasskeyIdentityProvider(
  final GetConfigurationFunction getConfig,
) {
  final hostname = getConfig('passkeyHostname');
  if (hostname == null) return null;
  return PasskeyIdentityProviderFactory(
    PasskeyIDPConfig(
      hostname: hostname,
    ),
  );
}
