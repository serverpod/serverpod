import 'package:serverpod/serverpod.dart';

import '../../common/integrations/token_manager_builder.dart';
import '../../common/utils/get_passwords_extension.dart';
import '../session.dart';

/// Configuration options for the session module.
class ServerSideSessionsConfig
    implements TokenManagerBuilder<ServerSideSessionsTokenManager> {
  /// The pepper used for hashing authentication session keys.
  ///
  /// This influences the stored session hashes, so it must not be changed for a given deployment,
  /// as otherwise all sessions become invalid.
  ///
  /// To rotate peppers without invalidating existing sessions, use [fallbackSessionKeyHashPeppers].
  final String sessionKeyHashPepper;

  /// Fallback peppers for validating session keys created with previous peppers.
  ///
  /// When rotating peppers, add the old pepper to this list to allow existing sessions
  /// to continue working. The system will try [sessionKeyHashPepper] first, then
  /// each fallback pepper in order until a match is found.
  ///
  /// This is optional and defaults to an empty list.
  final List<String> fallbackSessionKeyHashPeppers;

  /// Length of the session key secret (which is only stored on the client).
  ///
  /// Defaults to 32 bytes.
  final int sessionKeySecretLength;

  /// Length of the salt used for the session key hash.
  ///
  /// Defaults to 16 bytes.
  final int sessionKeyHashSaltLength;

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

  /// Called when a server side session has been created.
  ///
  /// Useful to attaching additional data to the server side session that can be
  /// later used on the server to find or revoke sessions.
  final Future<void> Function(
    Session session, {
    required UuidValue authUserId,
    required UuidValue serverSideSessionId,
    required Transaction? transaction,
  })?
  onSessionCreated;

  /// Create a new user session configuration.
  ServerSideSessionsConfig({
    required this.sessionKeyHashPepper,
    this.fallbackSessionKeyHashPeppers = const [],
    this.sessionKeySecretLength = 32,
    this.sessionKeyHashSaltLength = 16,
    this.defaultSessionLifetime,
    this.defaultSessionInactivityTimeout,
    this.onSessionCreated,
  }) {
    _validateSessionKeyHashPepper(sessionKeyHashPepper);
    for (final fallbackPepper in fallbackSessionKeyHashPeppers) {
      _validateSessionKeyHashPepper(fallbackPepper);
    }
    _validateSessionLifetime(defaultSessionLifetime);
    _validateSessionInactivityTimeout(defaultSessionInactivityTimeout);
  }

  @override
  ServerSideSessionsTokenManager build({
    required final AuthUsers authUsers,
  }) => ServerSideSessionsTokenManager(
    config: this,
    authUsers: authUsers,
  );
}

/// Creates a new [ServerSideSessionsConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class ServerSideSessionsConfigFromPasswords extends ServerSideSessionsConfig {
  /// Creates a new [ServerSideSessionsConfigFromPasswords] instance.
  ServerSideSessionsConfigFromPasswords({
    super.fallbackSessionKeyHashPeppers,
    super.sessionKeySecretLength,
    super.sessionKeyHashSaltLength,
    super.defaultSessionLifetime,
    super.defaultSessionInactivityTimeout,
  }) : super(
         sessionKeyHashPepper: Serverpod.instance.getPasswordOrThrow(
           'serverSideSessionKeyHashPepper',
         ),
       );
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
