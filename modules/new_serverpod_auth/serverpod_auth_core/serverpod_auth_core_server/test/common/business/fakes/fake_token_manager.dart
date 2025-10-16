import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'fake_token_storage.dart';

class FakeTokenManager implements TokenManager {
  final FakeTokenStorage _storage;
  final String _kind;
  final bool _usesRefreshTokens;

  FakeTokenManager(
    this._storage, {
    final String kind = 'jwt',
    final bool usesRefreshTokens = true,
  })  : _kind = kind,
        _usesRefreshTokens = usesRefreshTokens;

  @override
  String get kind => _kind;

  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    final tokenId = _storage.generateTokenId();
    final refreshTokenId =
        _usesRefreshTokens ? _storage.generateRefreshTokenId() : null;

    final scopeSet = scopes != null
        ? scopes
            .where((final scope) => scope.name != null)
            .map((final scope) => scope.name!)
            .toSet()
        : <String>{};

    final tokenInfo = TokenInfo(
      userId: authUserId.toString(),
      tokenProvider: _kind,
      tokenId: tokenId,
      scopes: scopes ?? {},
      method: method,
    );
    _storage.storeToken(tokenInfo);

    final authSuccess = AuthSuccess(
      token: tokenId,
      refreshToken: refreshTokenId,
      authUserId: authUserId,
      scopeNames: scopeSet,
      authStrategy: _kind,
    );

    return authSuccess;
  }

  @override
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
    final String? kind,
  }) async {
    // If kind is specified and doesn't match this manager's kind, do nothing
    if (kind != null && kind != _kind) return;

    final tokensToRevoke = _storage.getTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );

    _storage.removeTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );

    // Notify about revoked authentications
    if (tokensToRevoke.isNotEmpty) {
      if (authUserId != null) {
        // Revoking all tokens for a specific user
        await session.messages.authenticationRevoked(
          authUserId.uuid,
          RevokedAuthenticationUser(),
        );
      } else {
        // Revoking tokens for multiple users (notify each user)
        final userIds = tokensToRevoke.map((final t) => t.userId).toSet();
        for (final userId in userIds) {
          await session.messages.authenticationRevoked(
            userId,
            RevokedAuthenticationUser(),
          );
        }
      }
    }
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
    final String? kind,
  }) async {
    // If kind is specified and doesn't match this manager's kind, do nothing
    if (kind != null && kind != _kind) return;

    // Get token info before removing to notify about revocation
    final tokenInfo = _storage.getToken(tokenId);

    _storage.removeToken(tokenId);

    // Notify about revoked authentication
    if (tokenInfo != null) {
      await session.messages.authenticationRevoked(
        tokenInfo.userId,
        RevokedAuthenticationAuthId(authId: tokenId),
      );
    }
  }

  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
    final String? kind,
  }) async {
    // If kind is specified and doesn't match this manager's kind, return empty list
    if (kind != null && kind != _kind) return [];

    return _storage.getTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token, {
    final String? kind,
  }) async {
    // If kind is specified and doesn't match this manager's kind, return null
    if (kind != null && kind != _kind) return null;

    // Check if the token exists (hasn't been revoked)
    final tokenInfo = _storage.getToken(token);
    if (tokenInfo == null) return null;

    return AuthenticationInfo(
      tokenInfo.userId,
      tokenInfo.scopes,
      authId: token,
    );
  }

  void addToken(final TokenInfo token) {
    _storage.storeToken(token);
  }

  int get tokenCount => _storage.tokenCount;
  List<TokenInfo> get allTokens => _storage.allTokens;
}
