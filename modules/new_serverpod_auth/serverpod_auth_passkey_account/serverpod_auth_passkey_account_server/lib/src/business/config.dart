/// Configuration for the Passkey account module.
class PasskeyAccountConfig {
  /// The hostname to be used on the web and associated with any apps.
  ///
  /// This is also known as the "relying party".
  final String hostname;

  /// Creates a new configuration.
  PasskeyAccountConfig({
    required this.hostname,
  });
}
