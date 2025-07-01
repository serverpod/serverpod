import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';
import 'package:serverpod_auth_session_server/src/generated/protocol.dart';
import 'package:serverpod_auth_session_server/src/util/session_key_hash.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Management functions for [AuthSession]s.
///
/// This should be used instead of [AuthSession.db].
abstract final class AuthSessions {
  /// The current session module configuration.
  static AuthSessionConfig config = AuthSessionConfig();

  /// Admin-related functions for managing session.
  static final admin = AuthSessionsAdmin();

  /// Looks up the `AuthenticationInfo` belonging to the [key].
  ///
  /// Only looks at keys created with this package (by checking the prefix),
  /// returns `null` for all other inputs.
  ///
  /// In case the session looks like it was created with this package, but
  /// does not resolve to a valid authentication info (anymore), this will
  /// return `null`, and log details of the reason for rejection.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    if (!key.startsWith('$_sessionKeyPrefix:')) {
      return null;
    }

    final parts = key.split(':');
    if (parts.length != 3) {
      session.log(
        'Unexpected key format',
        level: LogLevel.debug,
      );

      return null;
    }

    final UuidValue authSessionId;
    try {
      authSessionId = UuidValue.fromByteList(base64Decode(parts[1]));
    } catch (e, stackTrace) {
      session.log(
        'Failed to parse auth session ID',
        level: LogLevel.debug,
        exception: e,
        stackTrace: stackTrace,
      );

      return null;
    }
    final secret = base64Decode(parts[2]);

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
        authSession.lastUsed.add(expireAfterUnusedFor).isBefore(clock.now())) {
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

    if (authSession.lastUsed
        .isBefore(clock.now().subtract(const Duration(minutes: 1)))) {
      authSession = await AuthSession.db.updateRow(
        session,
        authSession.copyWith(lastUsed: clock.now()),
      );
    }

    return AuthenticationInfo(
      authSession.authUserId,
      authSession.scopeNames.map(Scope.new).toSet(),
      authId: authSessionId.toString(),
    );
  }

  /// Create a session for the user, returning the secret session key to be used for the authentication header.
  ///
  /// The user should have been authenticated before calling this method.
  ///
  /// A fixed [expiresAt] can be set to ensure that the session is not usable after that date.
  ///
  /// Additional [expireAfterUnusedFor] can be set to make sure that the session has not been unused for longer than the provided value.
  /// In case the session was unused for at least [expireAfterUnusedFor] it'll automatically be decomissioned.
  ///
  /// Send the return value to the client to  use that to authenticate in future calls.
  ///
  /// In most situations this should not be called directly, but rather through an authentication provider.
  @useResult
  static Future<AuthSuccess> createSession(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope> scopes,

    /// Fixed date at which the session expires.
    /// If `null` the session will work until it's deleted or when it's been inactive for [expireAfterUnusedFor].
    final DateTime? expiresAt,

    /// Length of inactivity after which the session is no longer usable.
    final Duration? expireAfterUnusedFor,
    final Transaction? transaction,
  }) async {
    final secret = generateRandomBytes(config.sessionKeySecretLength);
    final hash = _sessionKeyHash.createSessionKeyHash(secret: secret);

    final scopeNames = <String>{
      for (final scope in scopes)
        if (scope.name != null) scope.name!,
    };

    final authSession = await AuthSession.db.insertRow(
      session,
      AuthSession(
        authUserId: authUserId,
        created: clock.now(),
        lastUsed: clock.now(),
        expiresAt: expiresAt,
        expireAfterUnusedFor: expireAfterUnusedFor,
        scopeNames: scopeNames,
        sessionKeyHash: ByteData.sublistView(hash.hash),
        sessionKeySalt: ByteData.sublistView(hash.salt),
        method: method,
      ),
      transaction: transaction,
    );

    return AuthSuccess(
      sessionKey: _buildSessionKey(
        secret: secret,
        authSessionId: authSession.id!,
      ),
      authUserId: authUserId,
      scopeNames: scopeNames,
    );
  }

  /// List all sessions belonging to the given [authUserId].
  static Future<List<AuthSessionInfo>> listSessions(
    final Session session, {
    required final UuidValue authUserId,
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
  ///
  /// Note: The method will not do anything if no authentication information is
  /// found for the user.
  static Future<void> destroyAllSessions(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    // Delete all sessions for the user
    final auths = await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.authUserId.equals(authUserId),
      transaction: transaction,
    );

    if (auths.isEmpty) return;

    await session.messages.authenticationRevoked(
      authUserId,
      RevokedAuthenticationUser(),
    );
  }

  /// Removes the specified session and thus signs out its user on its device.
  ///
  /// This does not affect the user's sessions on other
  /// devices.
  ///
  /// If the session does not exist, this method will have no effect.
  static Future<void> destroySession(
    final Session session, {
    required final UuidValue authSessionId,
    final Transaction? transaction,
  }) async {
    // Delete the user session for the current device
    final authSession = (await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(authSessionId),
      transaction: transaction,
    ))
        .firstOrNull;

    if (authSession == null) {
      return;
    }

    // Notify the client about the revoked authentication for the specific
    // user session
    await session.messages.authenticationRevoked(
      authSession.authUserId,
      RevokedAuthenticationAuthId(authId: authSessionId.toString()),
    );
  }

  /// Prefix for sessions keys
  /// "sas" being abbreviated of "serverpod_auth_session"
  static const _sessionKeyPrefix = 'sas';

  static String _buildSessionKey({
    required final UuidValue authSessionId,
    required final Uint8List secret,
  }) {
    return '$_sessionKeyPrefix:${base64Encode(authSessionId.toBytes())}:${base64Encode(secret)}';
  }

  /// The secrets configuration.
  static final __secrets = AuthSessionSecrets();

  /// Secrets to the used for testing. Also affects the internally used [AuthSessionKeyHash].
  @visibleForTesting
  static AuthSessionSecrets? secretsTestOverride;
  static AuthSessionSecrets get _secrets => secretsTestOverride ?? __secrets;

  static AuthSessionKeyHash get _sessionKeyHash =>
      AuthSessionKeyHash(secrets: _secrets);
}
