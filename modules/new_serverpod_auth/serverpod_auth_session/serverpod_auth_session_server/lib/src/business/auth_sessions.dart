import 'dart:convert';

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
    final secret = parts[2];

    final authSession = await AuthSession.db.findById(
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

    final maximumSessionLifetime =
        AuthSessionConfig.current.maximumSessionLifetime;

    if (maximumSessionLifetime != null &&
        authSession.created
            .add(maximumSessionLifetime)
            .isBefore(DateTime.now())) {
      session.log(
        'Session has expired',
        level: LogLevel.debug,
      );

      return null;
    }

    final sessionKeyHash = hashSessionKey(
      secret,
      pepper: AuthSessionSecrets.sessionKeyHashPepper,
    );

    if (sessionKeyHash != authSession.sessionKeyHash) {
      session.log(
        'Provided `secret` did not result in correct session key hash.',
        level: LogLevel.debug,
      );

      return null;
    }

    // Setup scopes
    final scopes = <Scope>{};
    for (final scopeName in authSession.scopeNames) {
      scopes.add(Scope(scopeName));
    }

    return AuthenticationInfo(
      authSession.authUserId,
      scopes,
      authId: authSessionId.toString(),
    );
  }

  /// Create a session for the user, returning the secret session key to be used for the authentication header.
  ///
  /// The user should have been authenticated before calling this method.
  ///
  /// Send the return value to the client to  use that to authenticate in future calls.
  ///
  /// In most situations this should not be called directly, but rather through an authentication provider.
  @useResult
  static Future<String> createSession(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope> scopes,
  }) async {
    final secret = generateRandomString();
    final hash = hashSessionKey(
      secret,
      pepper: AuthSessionSecrets.sessionKeyHashPepper,
    );

    final scopeNames = <String>{
      for (final scope in scopes)
        if (scope.name != null) scope.name!,
    };

    final authSession = await AuthSession.db.insertRow(
      session,
      AuthSession(
        authUserId: authUserId,
        scopeNames: scopeNames,
        sessionKeyHash: hash,
        method: method,
      ),
    );

    return _buildSessionKey(secret: secret, authSessionId: authSession.id!);
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
  }) async {
    // Delete all sessions for the user
    final auths = await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.authUserId.equals(authUserId),
    );

    if (auths.isEmpty) return;

    // Notify clients about the revoked authentication for the user
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
  }) async {
    // Delete the user session for the current device
    final authSession = (await AuthSession.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(authSessionId),
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
    required final String secret,
  }) {
    return '$_sessionKeyPrefix:${base64Encode(authSessionId.toBytes())}:$secret';
  }
}
