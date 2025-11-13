import 'package:serverpod/serverpod.dart';

import '../../../../auth_user.dart';
import '../../../generated/protocol.dart';
import '../../../session/business/auth_sessions.dart';
import '../../../session/business/auth_sessions_config.dart';
import '../token_manager.dart';

/// Token manager adapter for [AuthSessions].
///
/// This class is used to bridge the gap between the [AuthSessions] and the
/// [TokenManager] interface. It delegates all operations to the [AuthSessions]
/// instance.
class AuthSessionsTokenManager implements TokenManager {
  /// The name of the token issuer.
  static String get tokenIssuerName => AuthStrategy.session.name;

  /// The [AuthSessions] instance.
  final AuthSessions authSessions;

  /// Creates a new [AuthSessionsTokenManager] instance.
  AuthSessionsTokenManager({
    required final AuthSessionsConfig config,
    final AuthUsers authUsers = const AuthUsers(),
  }) : authSessions = AuthSessions(config: config, authUsers: authUsers);

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) {
    return authSessions.createSession(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) {
      return [];
    }

    return (await authSessions.admin.findSessions(
          session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
        ))
        .map(
          (final element) => TokenInfo(
            userId: element.authUserId.toString(),
            tokenId: element.id.toString(),
            tokenIssuer: tokenIssuerName,
            scopes: element.scopeNames.map(Scope.new).toSet(),
            method: element.method,
          ),
        )
        .toList();
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) return;

    final deletedSessions = await authSessions.admin.deleteSessions(
      session,
      transaction: transaction,
      authUserId: authUserId,
      method: method,
    );

    for (final (:authUserId, :sessionId) in deletedSessions) {
      await session.messages.authenticationRevoked(
        authUserId.uuid,
        RevokedAuthenticationAuthId(authId: sessionId.uuid),
      );
    }
  }

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) return;

    final UuidValue authSessionId;
    try {
      authSessionId = UuidValue.withValidation(tokenId);
    } catch (e) {
      // Silence if the tokenId is not a valid UUID which can happen when
      // interacting with multiple token managers.
      return;
    }

    final deletedSessions = await authSessions.admin.deleteSessions(
      session,
      authSessionId: authSessionId,
      transaction: transaction,
    );

    if (deletedSessions.isEmpty) return;

    if (deletedSessions.length != 1) {
      throw StateError(
        'Expected 1 session to be deleted, but got ${deletedSessions.length}',
      );
    }

    final (:authUserId, :sessionId) = deletedSessions.first;

    await session.messages.authenticationRevoked(
      authUserId.uuid,
      RevokedAuthenticationAuthId(authId: sessionId.uuid),
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return authSessions.authenticationHandler(session, token);
  }
}
