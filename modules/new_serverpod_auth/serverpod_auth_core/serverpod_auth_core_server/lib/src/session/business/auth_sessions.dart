import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../auth_user/auth_user.dart';
import '../../generated/protocol.dart';
import '../util/session_key_hash.dart';
import 'auth_sessions_admin.dart';
import 'auth_sessions_config.dart';
import 'session_key.dart';

/// Management functions for [AuthSession]s.
///
/// This should be used instead of [AuthSession.db].
final class AuthSessions {
  final AuthSessionsConfig _config;

  /// The secrets configuration.
  final AuthSessionKeyHash _sessionKeyHash;

  /// Management functions for auth users.
  final AuthUsers authUsers;

  /// Creates a new [AuthSessions] instance.
  AuthSessions({
    required final AuthSessionsConfig config,
    this.authUsers = const AuthUsers(),
  }) : _config = config,
       _sessionKeyHash = AuthSessionKeyHash.fromConfig(config);

  /// Admin-related functions for managing session.
  final admin = AuthSessionsAdmin();

  /// Looks up the `AuthenticationInfo` belonging to the [key].
  ///
  /// Only looks at keys created with this package (by checking the prefix),
  /// returns `null` for all other inputs.
  ///
  /// In case the session looks like it was created with this package, but
  /// does not resolve to a valid authentication info (anymore), this will
  /// return `null`, and log details of the reason for rejection.
  Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    final sessionKeyParts = tryParseSessionKey(session, key);
    if (sessionKeyParts == null) {
      return null;
    }

    final (:authSessionId, :secret) = sessionKeyParts;

    var authSession = await AuthSession.db.findById(
      session,
      authSessionId,
    );

    if (authSession == null) {
      session.log(
        'Did not find auth session with ID "$authSessionId"',
        level: LogLevel.debug,
      );

      return null;
    }

    final expiresAt = authSession.expiresAt;
    if (expiresAt != null && clock.now().isAfter(expiresAt)) {
      session.log(
        'Got session after its set expiration date.',
        level: LogLevel.debug,
      );

      return null;
    }

    final expireAfterUnusedFor = authSession.expireAfterUnusedFor;
    if (expireAfterUnusedFor != null &&
        authSession.lastUsedAt
            .add(expireAfterUnusedFor)
            .isBefore(clock.now())) {
      session.log(
        'Got session which expired due to inactivity.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (!_sessionKeyHash.validateSessionKeyHash(
      secret: secret,
      hash: Uint8List.sublistView(authSession.sessionKeyHash),
      salt: Uint8List.sublistView(authSession.sessionKeySalt),
    )) {
      session.log(
        'Provided `secret` did not result in correct session key hash.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (authSession.lastUsedAt.isBefore(
      clock.now().subtract(const Duration(minutes: 1)),
    )) {
      authSession = await AuthSession.db.updateRow(
        session,
        authSession.copyWith(lastUsedAt: clock.now()),
      );
    }

    return AuthenticationInfo(
      authSession.authUserId.uuid,
      authSession.scopeNames.map(Scope.new).toSet(),
      authId: authSessionId.toString(),
    );
  }

  /// Create a session for the user, returning the secret session key to be used for the authentication header.
  ///
  /// The user should have been authenticated before calling this method.
  ///
  /// A fixed [expiresAt] can be set to ensure that the session is not usable after that date.
  /// If not provided, defaults to [AuthSessionsConfig.defaultSessionLifetime] into the future (if configured).
  ///
  /// Additional [expireAfterUnusedFor] can be set to make sure that the session has not been unused for longer than the provided value.
  /// In case the session was unused for at least [expireAfterUnusedFor] it'll automatically be decommissioned.
  /// If not provided, defaults to [AuthSessionsConfig.defaultSessionInactivityTimeout] (if configured).
  ///
  /// Send the return value to the client to  use that to authenticate in future calls.
  ///
  /// In most situations this should not be called directly, but rather through an authentication provider.
  @useResult
  Future<AuthSuccess> createSession(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,

    /// The scopes to apply to the session.
    ///
    /// By default forwards all of the [AuthUser]'s scopes to the session.
    Set<Scope>? scopes,

    /// Fixed date at which the session expires.
    /// If `null`, uses [AuthSessionsConfig.defaultSessionLifetime] to compute expiration time.
    /// If both are `null`, the session will work until it's deleted or when it's been
    /// inactive for [expireAfterUnusedFor].
    final DateTime? expiresAt,

    /// Length of inactivity after which the session is no longer usable.
    /// If `null`, uses [AuthSessionsConfig.defaultSessionInactivityTimeout].
    /// If both are `null`, the session is valid until [expiresAt].
    final Duration? expireAfterUnusedFor,

    /// Whether to skip the check if the user is blocked (in which case a
    /// [AuthUserBlockedException] would be thrown).
    ///
    /// Should only to be used if the caller is sure that the user is not
    /// blocked.
    final bool skipUserBlockedChecked = false,
    final Transaction? transaction,
  }) async {
    if (!skipUserBlockedChecked || scopes == null) {
      final authUser = await authUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );

      if (authUser.blocked && !skipUserBlockedChecked) {
        throw AuthUserBlockedException();
      }

      scopes ??= authUser.scopes;
    }

    // Apply default values from config
    final effectiveExpiresAt =
        expiresAt ??
        (_config.defaultSessionLifetime != null
            ? clock.now().add(_config.defaultSessionLifetime!)
            : null);
    final effectiveExpireAfterUnusedFor =
        expireAfterUnusedFor ?? _config.defaultSessionInactivityTimeout;

    final secret = generateRandomBytes(_config.sessionKeySecretLength);
    final hash = _sessionKeyHash.createSessionKeyHash(secret: secret);

    final scopeNames = <String>{
      for (final scope in scopes)
        if (scope.name != null) scope.name!,
    };

    final authSession = await AuthSession.db.insertRow(
      session,
      AuthSession(
        authUserId: authUserId,
        createdAt: clock.now(),
        lastUsedAt: clock.now(),
        expiresAt: effectiveExpiresAt,
        expireAfterUnusedFor: effectiveExpireAfterUnusedFor,
        scopeNames: scopeNames,
        sessionKeyHash: ByteData.sublistView(hash.hash),
        sessionKeySalt: ByteData.sublistView(hash.salt),
        method: method,
      ),
      transaction: transaction,
    );

    return AuthSuccess(
      authStrategy: AuthStrategy.session.name,
      token: buildSessionKey(
        secret: secret,
        authSessionId: authSession.id!,
      ),
      authUserId: authUserId,
      scopeNames: scopeNames,
    );
  }

  /// List all sessions.
  ///
  /// If [authUserId] is provided, only sessions for that user will be listed.
  Future<List<AuthSessionInfo>> listSessions(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
  }) async {
    return admin.findSessions(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );
  }

  /// Signs out a user from the server and ends all user sessions managed by this module.
  ///
  /// This means that all sessions connected to the user will be terminated.
  /// Returns the list of IDs of the deleted sessions.
  ///
  /// Note: The method will not do anything if no authentication information is
  /// found for the user.
  Future<List<UuidValue>> destroyAllSessions(
    final Session session, {
    required final UuidValue authUserId,
    final String? method,
    final Transaction? transaction,
  }) async {
    // Delete all sessions for the user
    final auths = await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.authUserId.equals(authUserId),
      transaction: transaction,
    );

    if (auths.isEmpty) return const [];

    await session.messages.authenticationRevoked(
      authUserId.uuid,
      RevokedAuthenticationUser(),
    );

    return [
      for (final auth in auths)
        if (auth.id != null) auth.id!,
    ];
  }

  /// Removes the specified session and thus signs out its user on its device.
  ///
  /// This does not affect the user's sessions on other devices. Returns `true`
  /// if the token was found and deleted, `false` otherwise.
  ///
  /// If the session does not exist, this method will have no effect.
  Future<bool> destroySession(
    final Session session, {
    required final UuidValue authSessionId,
    final Transaction? transaction,
  }) async {
    // Delete the user session for the current device
    final authSession = (await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(authSessionId),
      transaction: transaction,
    )).firstOrNull;

    if (authSession == null) {
      return false;
    }

    // Notify the client about the revoked authentication for the specific
    // user session
    await session.messages.authenticationRevoked(
      authSession.authUserId.uuid,
      RevokedAuthenticationAuthId(authId: authSessionId.toString()),
    );

    return true;
  }
}
