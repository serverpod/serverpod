/// Configuration options for the API token module.
class ApiTokenConfig {
  /// Length of the API token secret (which is only stored on the client).
  ///
  /// Defaults to 64 bytes.
  final int apiTokenSecretLength;

  /// Length of the salt used for the API token hash.
  ///
  /// Defaults to 16 bytes.
  final int apiTokenHashSaltLength;

  /// Create a new API token configuration.
  ApiTokenConfig({
    this.apiTokenSecretLength = 64,
    this.apiTokenHashSaltLength = 16,
  });
}
