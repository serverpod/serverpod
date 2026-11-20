import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/legacy_authentication_handler.dart';
import 'package:serverpod_auth_bridge_server/src/generated/legacy_session.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Token manager that validates and manages legacy session tokens created by
/// the bridge's proxy endpoints.
class LegacySessionTokenManager extends TokenManager
    implements TokenManagerBuilder<LegacySessionTokenManager> {
  /// Creates a new [LegacySessionTokenManager].
  const LegacySessionTokenManager();

  @override
  LegacySessionTokenManager build({required AuthUsers authUsers}) {
    return const LegacySessionTokenManager();
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    Session session,
    String token,
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
    Session session, {
    required String tokenId,
    Transaction? transaction,
    String? tokenIssuer,
  }) async {
    final id = int.tryParse(tokenId);
    if (id == null) return;

    await LegacySession.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
      transaction: transaction,
    );
  }

  @override
  Future<void> revokeAllTokens(
    Session session, {
    required UuidValue? authUserId,
    Transaction? transaction,
    String? method,
    String? tokenIssuer,
  }) async {
    if (authUserId == null) return;

    await LegacySession.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(authUserId),
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
    return [];
  }

  @override
  Future<AuthSuccess> createToken(
    Session session, {
    required UuidValue authUserId,
    required String method,
    Set<Scope>? scopes,
    Transaction? transaction,
  }) {
    throw UnsupportedError(
      'LegacySessionTokenManager does not support issuing tokens. '
      'Legacy sessions are created directly by the proxy endpoints.',
    );
  }
}
