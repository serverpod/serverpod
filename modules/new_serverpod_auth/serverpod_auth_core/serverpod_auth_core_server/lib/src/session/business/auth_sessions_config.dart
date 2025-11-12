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

  /// Default absolute expiration time for sessions.
  ///
  /// When set, new sessions will expire at creation time + this duration.
  /// If `null`, sessions will not have an absolute expiration time by default.
  ///
  /// This can be overridden when creating individual sessions.
  ///
  /// Defaults to `null` (no absolute expiration).
  final Duration? defaultSessionLifetime;

  /// Default inactivity timeout for sessions.
  ///
  /// When set, sessions will expire if they go unused for this duration.
  /// If `null`, sessions will not expire due to inactivity by default.
  ///
  /// This can be overridden when creating individual sessions.
  ///
  /// Defaults to `null` (no inactivity timeout).
  final Duration? defaultSessionInactivityTimeout;

  /// Create a new user session configuration.
  AuthSessionsConfig({
    this.sessionKeySecretLength = 32,
    this.sessionKeyHashSaltLength = 16,
    required this.sessionKeyHashPepper,
    this.defaultSessionLifetime,
    this.defaultSessionInactivityTimeout,
  }) {
    _validateSessionKeyHashPepper(sessionKeyHashPepper);
    _validateSessionLifetime(defaultSessionLifetime);
    _validateSessionInactivityTimeout(defaultSessionInactivityTimeout);
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

void _validateSessionLifetime(final Duration? sessionLifetime) {
  if (sessionLifetime != null && sessionLifetime.isNegative) {
    throw ArgumentError.value(
      sessionLifetime,
      'defaultSessionLifetime',
      'must not be negative',
    );
  }
}

void _validateSessionInactivityTimeout(
  final Duration? sessionInactivityTimeout,
) {
  if (sessionInactivityTimeout != null && sessionInactivityTimeout.isNegative) {
    throw ArgumentError.value(
      sessionInactivityTimeout,
      'defaultSessionInactivityTimeout',
      'must not be negative',
    );
  }
}
