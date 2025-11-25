import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

/// Configuration for the Apple identity provider.
class AppleIDPConfig {
  /// The service identifier for the Sign in with Apple project.
  final String serviceIdentifier;

  /// The bundle ID of the Apple-native app using Sign in with Apple.
  final String bundleIdentifier;

  /// The redirect URL used for 3rd party platforms, e.g. Android.
  final String redirectUri;

  /// The team identifier of the parent Apple Developer account.
  final String teamId;

  /// The ID of the key associated with the Sign in with Apple service.
  final String keyId;

  /// The secret contents of the private key file received once from Apple.
  final String key;

  /// The route used for the revoked notification.
  final String revokedNotificationRoute;

  /// The route used for the web authentication callback.
  final String webAuthenticationCallbackRoute;

  /// Creates a new Sign in with Apple configuration.
  AppleIDPConfig({
    required this.serviceIdentifier,
    required this.bundleIdentifier,
    required this.redirectUri,
    required this.teamId,
    required this.keyId,
    required this.key,
    required this.revokedNotificationRoute,
    required this.webAuthenticationCallbackRoute,
  });

  /// Creates a new Sign in with Apple configuration from default expected keys.
  factory AppleIDPConfig.fromKeys(
    final String? Function(String key) getConfig,
  ) {
    const serviceIdentifierKey = 'appleServiceIdentifier';
    const bundleIdentifierKey = 'appleBundleIdentifier';
    const redirectUriKey = 'appleRedirectUri';
    const teamIdKey = 'appleTeamId';
    const keyIdKey = 'appleKeyId';
    const keyKey = 'appleKey';
    const revokedNotificationRouteKey = 'appleRevokedNotificationRoute';
    const webAuthenticationRouteKey = 'appleWebAuthenticationCallbackRoute';

    final keys = {
      serviceIdentifierKey: getConfig(serviceIdentifierKey),
      bundleIdentifierKey: getConfig(bundleIdentifierKey),
      redirectUriKey: getConfig(redirectUriKey),
      teamIdKey: getConfig(teamIdKey),
      keyIdKey: getConfig(keyIdKey),
      keyKey: getConfig(keyKey),
      revokedNotificationRouteKey: getConfig(revokedNotificationRouteKey),
      webAuthenticationRouteKey: getConfig(webAuthenticationRouteKey),
    };

    final missingKeys = keys.entries
        .where((final e) => e.value == null)
        .map((final e) => e.key)
        .join('", "');

    if (missingKeys.isNotEmpty) {
      throw StateError(
        'Missing required keys for Apple IDP configuration: "$missingKeys".',
      );
    }

    return AppleIDPConfig(
      serviceIdentifier: keys[serviceIdentifierKey]!,
      bundleIdentifier: keys[bundleIdentifierKey]!,
      redirectUri: keys[redirectUriKey]!,
      teamId: keys[teamIdKey]!,
      keyId: keys[keyIdKey]!,
      key: keys[keyKey]!,
      revokedNotificationRoute: keys[revokedNotificationRouteKey]!,
      webAuthenticationCallbackRoute: keys[webAuthenticationRouteKey]!,
    );
  }
}

/// Extension methods for [AppleIDPConfig].
extension AppleIDPConfigExtension on AppleIDPConfig {
  /// Converts the [AppleIDPConfig] to a [SignInWithAppleConfiguration].
  SignInWithAppleConfiguration toSignInWithAppleConfiguration() {
    return SignInWithAppleConfiguration(
      serviceIdentifier: serviceIdentifier,
      bundleIdentifier: bundleIdentifier,
      redirectUri: redirectUri,
      teamId: teamId,
      keyId: keyId,
      key: key,
    );
  }
}
