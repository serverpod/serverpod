/// Configuration for the Apple account module.
class AppleAccountConfig {
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

  /// Creates a new Sign in with Apple configuration.
  AppleAccountConfig({
    required this.serviceIdentifier,
    required this.bundleIdentifier,
    required this.redirectUri,
    required this.teamId,
    required this.keyId,
    required this.key,
  });
}
