import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/legacy_authentication_handler.dart';
import 'package:serverpod_auth_bridge_server/src/generated/legacy_session.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Token manager that validates and manages legacy session tokens created by
/// the bridge's proxy endpoints.
class LegacySessionTokenManager implements TokenManager {
  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    final legacySession = await resolveLegacySession(session, token);
    if (legacySession == null) return null;

    return AuthenticationInfo(
      legacySession.authUserId.toString(),
      {for (final name in legacySession.scopeNames) Scope(name)},
      authId: legacySession.id.toString(),
    );
  }

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {
    final id = int.tryParse(tokenId);
    if (id == null) return;

    await LegacySession.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(id),
      transaction: transaction,
    );
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {
    if (authUserId == null) return;

    await LegacySession.db.deleteWhere(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
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
    return [];
  }

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) {
    throw UnsupportedError(
      'LegacySessionTokenManager does not support issuing tokens. '
      'Legacy sessions are created directly by the proxy endpoints.',
    );
  }
}
