import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../auth_user/auth_user.dart';
import '../../generated/protocol.dart';
import '../util/session_key_hash.dart';
import 'server_side_sessions_admin.dart';
import 'server_side_sessions_config.dart';
import 'server_side_sessions_token.dart';

/// Management functions for [ServerSideSession]s.
///
/// This should be used instead of [ServerSideSession.db].
class ServerSideSessions {
  final ServerSideSessionsConfig _config;

  /// The secrets configuration.
  final ServerSideSessionKeyHash _sessionKeyHash;

  /// Management functions for auth users.
  final AuthUsers authUsers;

  /// Creates a new [ServerSideSessions] instance.
  ServerSideSessions({
    required final ServerSideSessionsConfig config,
    this.authUsers = const AuthUsers(),
  }) : _config = config,
       _sessionKeyHash = ServerSideSessionKeyHash.fromConfig(config);

  /// Admin-related functions for managing session.
  final admin = ServerSideSessionsAdmin();

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
    final sessionKeyParts = tryParseServerSideSessionToken(session, key);
    if (sessionKeyParts == null) {
      return null;
    }

    final (:serverSideSessionId, :secret) = sessionKeyParts;

    var serverSideSession = await ServerSideSession.db.findById(
      session,
      serverSideSessionId,
    );

    if (serverSideSession == null) {
      session.log(
        'Did not find server side session with ID "$serverSideSessionId"',
        level: LogLevel.debug,
      );

      return null;
    }

    if (_isSessionExpired(serverSideSession)) {
      session.log(
        'Got session after its expiration.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (!_sessionKeyHash.validateSessionKeyHash(
      secret: secret,
      hash: Uint8List.sublistView(serverSideSession.sessionKeyHash),
      salt: Uint8List.sublistView(serverSideSession.sessionKeySalt),
    )) {
      session.log(
        'Provided `secret` did not result in correct session key hash.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (serverSideSession.lastUsedAt.isBefore(
      clock.now().subtract(const Duration(minutes: 1)),
    )) {
      serverSideSession = await ServerSideSession.db.updateRow(
        session,
        serverSideSession.copyWith(lastUsedAt: clock.now()),
      );
    }

    return AuthenticationInfo(
      serverSideSession.authUserId.uuid,
      serverSideSession.scopeNames.map(Scope.new).toSet(),
      authId: serverSideSessionId.toString(),
    );
  }

  /// Create a session for the user, returning the secret session key to be used for the authentication header.
  ///
  /// The user should have been authenticated before calling this method.
  ///
  /// A fixed [expiresAt] can be set to ensure that the session is not usable after that date.
  /// If not provided, defaults to [ServerSideSessionsConfig.defaultSessionLifetime] into the future (if configured).
  ///
  /// Additional [expireAfterUnusedFor] can be set to make sure that the session has not been unused for longer than the provided value.
  /// In case the session was unused for at least [expireAfterUnusedFor] it'll automatically be decommissioned.
  /// If not provided, defaults to [ServerSideSessionsConfig.defaultSessionInactivityTimeout] (if configured).
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
    /// If `null`, uses [ServerSideSessionsConfig.defaultSessionLifetime] to compute expiration time.
    /// If both are `null`, the session will work until it's deleted or when it's been
    /// inactive for [expireAfterUnusedFor].
    final DateTime? expiresAt,

    /// Length of inactivity after which the session is no longer usable.
    /// If `null`, uses [ServerSideSessionsConfig.defaultSessionInactivityTimeout].
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

    final serverSideSession = await ServerSideSession.db.insertRow(
      session,
      ServerSideSession(
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
      token: buildServerSideSessionToken(
        secret: secret,
        serverSideSessionId: serverSideSession.id!,
      ),
      tokenExpiresAt: effectiveExpiresAt,
      authUserId: authUserId,
      scopeNames: scopeNames,
    );
  }

  /// List all sessions matching the given filters.
  ///
  /// If [authUserId] is provided, only sessions for that user will be listed.
  /// If [method] is provided, only sessions created with that method will be listed.
  /// If [expired] is provided, only sessions matching the expiration status will be listed.
  /// A session is considered expired if either its [expiresAt] date has passed or
  /// it has been unused for longer than [expireAfterUnusedFor].
  Future<List<ServerSideSessionInfo>> listSessions(
    final Session session, {
    final UuidValue? authUserId,
    final String? method,
    final bool? expired,
    final Transaction? transaction,
  }) async {
    final serverSideSessions = await ServerSideSession.db.find(
      session,
      where: (final t) {
        Expression<dynamic> expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= t.authUserId.equals(authUserId);
        }

        if (method != null) {
          expression &= t.method.equals(method);
        }

        return expression;
      },
      transaction: transaction,
    );

    final sessionInfos = <ServerSideSessionInfo>[
      for (final serverSideSession in serverSideSessions)
        if (_shouldIncludeSession(serverSideSession, expired))
          ServerSideSessionInfo(
            id: serverSideSession.id!,
            authUserId: serverSideSession.authUserId,
            scopeNames: serverSideSession.scopeNames,
            created: serverSideSession.createdAt,
            lastUsed: serverSideSession.lastUsedAt,
            expiresAt: serverSideSession.expiresAt,
            expireAfterUnusedFor: serverSideSession.expireAfterUnusedFor,
            method: serverSideSession.method,
          ),
    ];

    return sessionInfos;
  }

  /// Helper method to determine if a session should be included based on expiration filter.
  bool _shouldIncludeSession(
    final ServerSideSession serverSideSession,
    final bool? expiredFilter,
  ) {
    // If no filter is specified, include all sessions
    if (expiredFilter == null) {
      return true;
    }

    final isExpired = _isSessionExpired(serverSideSession);

    // Return true if the session's expiration status matches the filter
    return isExpired == expiredFilter;
  }

  /// Checks if a session is expired based on the same logic used in authenticationHandler.
  bool _isSessionExpired(final ServerSideSession serverSideSession) {
    // Check if session has a fixed expiration date that has passed
    final expiresAt = serverSideSession.expiresAt;
    if (expiresAt != null && clock.now().isAfter(expiresAt)) {
      return true;
    }

    // Check if session has been inactive for too long
    final expireAfterUnusedFor = serverSideSession.expireAfterUnusedFor;
    if (expireAfterUnusedFor != null &&
        serverSideSession.lastUsedAt
            .add(expireAfterUnusedFor)
            .isBefore(clock.now())) {
      return true;
    }

    return false;
  }

  /// Signs out a user from the server and ends all user sessions managed by this module.
  ///
  /// This means that all sessions connected to the user will be terminated.
  /// Returns the list of IDs of the deleted sessions.
  ///
  /// Note: The method will not do anything if no authentication information is
  /// found for the user.
  ///
  /// Automatically registers authentication revocation via
  /// `session.messages.authenticationRevoked` when sessions are deleted. If this
  /// behavior is not desired, use [AuthSessionsAdmin.deleteSessions] instead.
  Future<List<UuidValue>> revokeAllSessions(
    final Session session, {
    required final UuidValue authUserId,
    final String? method,
    final Transaction? transaction,
  }) async {
    // Delete all sessions for the user
    final auths = await ServerSideSession.db.deleteWhere(
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
  ///
  /// Automatically registers authentication revocation via
  /// `session.messages.authenticationRevoked` when the session is deleted. If this
  /// behavior is not desired, use [AuthSessionsAdmin.deleteSessions] instead.
  Future<bool> revokeSession(
    final Session session, {
    required final UuidValue serverSideSessionId,
    final Transaction? transaction,
  }) async {
    // Delete the user session for the current device
    final serverSideSession = (await ServerSideSession.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(serverSideSessionId),
      transaction: transaction,
    )).firstOrNull;

    if (serverSideSession == null) {
      return false;
    }

    // Notify the client about the revoked authentication for the specific
    // user session
    await session.messages.authenticationRevoked(
      serverSideSession.authUserId.uuid,
      RevokedAuthenticationAuthId(authId: serverSideSessionId.toString()),
    );

    return true;
  }
}
