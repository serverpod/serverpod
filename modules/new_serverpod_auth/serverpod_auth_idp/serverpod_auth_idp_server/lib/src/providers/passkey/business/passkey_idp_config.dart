/// Configuration for the Passkey account module.
class PasskeyIdpConfig {
  /// The hostname to be used on the web and associated with any apps.
  ///
  /// This is also known as the "relying party".
  final String hostname;

  /// Maximum time after which a challenge must have been solved.
  final Duration challengeLifetime;

  /// Creates a new configuration.
  PasskeyIdpConfig({
    required this.hostname,
    this.challengeLifetime = const Duration(minutes: 5),
  });
}
