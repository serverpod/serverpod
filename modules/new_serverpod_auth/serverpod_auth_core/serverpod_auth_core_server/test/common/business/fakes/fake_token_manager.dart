import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'fake_token_storage.dart';

class FakeTokenManager implements TokenManager {
  final FakeTokenStorage _storage;

  FakeTokenManager(this._storage);

  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    final tokenId = _storage.generateTokenId();
    final refreshTokenId = _storage.generateRefreshTokenId();

    final scopeSet = scopes != null
        ? scopes
            .where((final scope) => scope.name != null)
            .map((final scope) => scope.name!)
            .toSet()
        : <String>{};

    final tokenInfo = TokenInfo(
      userId: authUserId.toString(),
      tokenProvider: 'jwt',
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
      authStrategy: 'jwt',
    );

    return authSuccess;
  }

  @override
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    _storage.removeTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
  }) async {
    _storage.removeToken(tokenId);
  }

  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
  }) async {
    return _storage.getTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    // Check if the token exists (hasn't been revoked)
    final tokenInfo = _storage.getToken(token);
    if (tokenInfo == null) return null;

    return AuthenticationInfo(
      tokenInfo.userId,
      tokenInfo.scopes,
    );
  }

  void addToken(final TokenInfo token) {
    _storage.storeToken(token);
  }

  int get tokenCount => _storage.tokenCount;
  List<TokenInfo> get allTokens => _storage.allTokens;
}
