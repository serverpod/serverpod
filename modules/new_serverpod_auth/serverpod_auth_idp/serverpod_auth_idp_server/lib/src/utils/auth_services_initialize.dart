import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

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
    required final List<TokenManagerFactory> tokenManagers,
    final List<IdentityProviderFactory> identityProviders = const [],
    final AuthUsersConfig authUsersConfig = const AuthUsersConfig(),
    final UserProfileConfig userProfileConfig = const UserProfileConfig(),
    final GetConfigurationFunction? getConfigFunction,
  }) {
    AuthServices.set(
      pod: this,
      tokenManagers: tokenManagers,
      identityProviders: identityProviders,
      authUsersConfig: authUsersConfig,
      userProfileConfig: userProfileConfig,
    );

    authenticationHandler = AuthServices.instance.authenticationHandler;

    // NOTE: Only try to configure the routes for Apple IDP if it is configured
    // using the default configuration (not passed as an additional identity
    // provider). In such cases, the user is expected to configure the routes
    // manually, since the provider has been configured manually as well.
    if (identityProviders
        .whereType<AppleIdentityProviderFactory>()
        .isNotEmpty) {
      final appleIDP = AuthServices.instance.appleIDP;
      webServer.addRoute(
        appleIDP.revokedNotificationRoute(),
        appleIDP.config.revokedNotificationRoute,
      );
      webServer.addRoute(
        appleIDP.webAuthenticationCallbackRoute(),
        appleIDP.config.webAuthenticationCallbackRoute,
      );
    }
  }
}
