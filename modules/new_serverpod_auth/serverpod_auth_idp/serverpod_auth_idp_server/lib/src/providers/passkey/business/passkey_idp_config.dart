/// Configuration for the Passkey account module.
class PasskeyIDPConfig {
  /// The hostname to be used on the web and associated with any apps.
  ///
  /// This is also known as the "relying party".
  final String hostname;

  /// Maximum time after which a challenge must have been solved.
  final Duration challengeLifetime;

  /// Creates a new configuration.
  PasskeyIDPConfig({
    required this.hostname,
    this.challengeLifetime = const Duration(minutes: 5),
  });

  /// Creates a new instance of [PasskeyIDPConfig] from default expected keys.
  factory PasskeyIDPConfig.fromKeys(
    final String? Function(String key) getConfig, {
    final Duration challengeLifetime = const Duration(minutes: 5),
  }) {
    const hostnameKey = 'passkeyHostname';

    final hostname = getConfig(hostnameKey);
    if (hostname == null) {
      throw StateError(
        'Missing required keys for Passkey IDP configuration: "$hostnameKey".',
      );
    }

    return PasskeyIDPConfig(
      hostname: hostname,
      challengeLifetime: challengeLifetime,
    );
  }
}
