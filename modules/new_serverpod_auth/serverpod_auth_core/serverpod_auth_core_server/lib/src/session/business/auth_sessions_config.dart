/// Configuration options for the session module.
class AuthSessionsConfig {
  /// Length of the session key secret (which is only stored on the client).
  ///
  /// Defaults to 32 bytes.
  final int sessionKeySecretLength;

  /// Length of the salt used for the session key hash.
  ///
  /// Defaults to 16 bytes.
  final int sessionKeyHashSaltLength;

  /// The pepper used for hashing authentication session keys.
  ///
  /// This influences the stored session hashes, so it must not be changed for a given deployment,
  /// as otherwise all sessions become invalid.
  late final String sessionKeyHashPepper;

  /// Create a new user session configuration.
  AuthSessionsConfig({
    this.sessionKeySecretLength = 32,
    this.sessionKeyHashSaltLength = 16,
    required this.sessionKeyHashPepper,
  }) {
    _validateSessionKeyHashPepper(sessionKeyHashPepper);
  }
}

void _validateSessionKeyHashPepper(final String sessionKeyHashPepper) {
  if (sessionKeyHashPepper.isEmpty) {
    throw ArgumentError.value(
      sessionKeyHashPepper,
      'sessionKeyHashPepper',
      'must not be empty',
    );
  }

  if (sessionKeyHashPepper.length < 10) {
    throw ArgumentError.value(
      sessionKeyHashPepper,
      'sessionKeyHashPepper',
      'must be at least 10 characters long',
    );
  }
}
