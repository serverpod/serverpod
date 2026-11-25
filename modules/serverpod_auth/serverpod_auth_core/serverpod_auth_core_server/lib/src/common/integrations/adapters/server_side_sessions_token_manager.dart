import 'package:serverpod/serverpod.dart';

import '../../../auth_user/auth_user.dart';
import '../../../generated/protocol.dart';
import '../../../session/business/server_side_sessions.dart';
import '../../../session/business/server_side_sessions_config.dart';
import '../token_manager.dart';

/// Token manager adapter for [ServerSideSessions].
///
/// This class is used to bridge the gap between the [ServerSideSessions] and the
/// [TokenManager] interface. It delegates all operations to the [ServerSideSessions]
/// instance.
class ServerSideSessionsTokenManager extends TokenManager {
  /// The name of the token issuer.
  static String get tokenIssuerName => AuthStrategy.session.name;

  /// The [ServerSideSessions] instance.
  final ServerSideSessions serverSideSessions;

  /// Creates a new [ServerSideSessionsTokenManager] instance.
  ServerSideSessionsTokenManager({
    required ServerSideSessionsConfig config,
    AuthUsers authUsers = const AuthUsers(),
  }) : serverSideSessions = ServerSideSessions(
         config: config,
         authUsers: authUsers,
       );

  @override
  Future<AuthSuccess> createToken(
    Session session, {
    required UuidValue authUserId,
    required String method,
    Set<Scope>? scopes,
    Transaction? transaction,
  }) {
    return serverSideSessions.createSession(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<List<TokenInfo>> listTokens(
    Session session, {
    required UuidValue? authUserId,
    String? method,
    String? tokenIssuer,
    Transaction? transaction,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) {
      return [];
    }

    return (await serverSideSessions.listSessions(
          session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
        ))
        .map(
          (element) => TokenInfo(
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
    Session session, {
    required UuidValue? authUserId,
    Transaction? transaction,
    String? method,
    String? tokenIssuer,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) return;

    final deletedSessions = await serverSideSessions.admin.deleteSessions(
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
    Session session, {
    required String tokenId,
    Transaction? transaction,
    String? tokenIssuer,
  }) async {
    if (tokenIssuer != null && tokenIssuer != tokenIssuerName) return;

    final UuidValue serverSideSessionId;
    try {
      serverSideSessionId = UuidValue.withValidation(tokenId);
    } catch (e) {
      // Silence if the tokenId is not a valid UUID which can happen when
      // interacting with multiple token managers.
      return;
    }

    final deletedSessions = await serverSideSessions.admin.deleteSessions(
      session,
      serverSideSessionId: serverSideSessionId,
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
    Session session,
    String token,
  ) async {
    return serverSideSessions.authenticationHandler(session, token);
  }
}
