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
