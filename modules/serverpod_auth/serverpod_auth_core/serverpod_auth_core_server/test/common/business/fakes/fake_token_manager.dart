import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'fake_token_storage.dart';

class FakeTokenManager extends TokenManager {
  final FakeTokenStorage _storage;
  final String _tokenIssuer;
  final bool _usesRefreshTokens;
  final AuthUsers _authUsers;

  FakeTokenManager(
    this._storage, {
    AuthUsers authUsers = const AuthUsers(),
    String tokenIssuer = 'fake',
    bool usesRefreshTokens = true,
  }) : _tokenIssuer = tokenIssuer,
       _usesRefreshTokens = usesRefreshTokens,
       _authUsers = authUsers;

  @override
  Future<AuthSuccess> createToken(
    Session session, {
    required UuidValue authUserId,
    required String method,
    Set<Scope>? scopes,
    Transaction? transaction,
  }) async {
    {
      final authUser = await _authUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );

      if (authUser.blocked) {
        throw AuthUserBlockedException();
      }

      scopes ??= authUser.scopes;
    }

    final tokenId = _storage.generateTokenId();
    final refreshTokenId = _usesRefreshTokens
        ? _storage.generateRefreshTokenId()
        : null;

    final scopeSet = scopes
        .where((scope) => scope.name != null)
        .map((scope) => scope.name!)
        .toSet();

    final tokenInfo = TokenInfo(
      userId: authUserId.toString(),
      tokenIssuer: _tokenIssuer,
      tokenId: tokenId,
      scopes: scopes,
      method: method,
    );
    _storage.storeToken(tokenInfo);

    final authSuccess = AuthSuccess(
      token: base64Encode(utf8.encode(tokenId)),
      refreshToken: refreshTokenId,
      authUserId: authUserId,
      scopeNames: scopeSet,
      authStrategy: _tokenIssuer,
    );

    return authSuccess;
  }

  @override
  Future<void> revokeAllTokens(
    Session session, {
    required UuidValue? authUserId,
    Transaction? transaction,
    String? method,
    String? tokenIssuer,
  }) async {
    // If kind is specified and doesn't match this manager's kind, do nothing
    if (tokenIssuer != null && tokenIssuer != _tokenIssuer) return;

    final tokensToRevoke = _storage.getTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );

    _storage.removeTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );

    // Notify about revoked authentications
    for (final tokenInfo in tokensToRevoke) {
      await session.messages.authenticationRevoked(
        tokenInfo.userId,
        RevokedAuthenticationAuthId(authId: tokenInfo.tokenId),
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
    // If kind is specified and doesn't match this manager's kind, do nothing
    if (tokenIssuer != null && tokenIssuer != _tokenIssuer) return;

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
  Future<List<TokenInfo>> listTokens(
    Session session, {
    required UuidValue? authUserId,
    String? method,
    String? tokenIssuer,
    Transaction? transaction,
  }) async {
    // If kind is specified and doesn't match this manager's kind, return empty list
    if (tokenIssuer != null && tokenIssuer != _tokenIssuer) return [];

    return _storage.getTokensWhere(
      userId: authUserId?.toString(),
      method: method,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    Session session,
    String token, {
    String? tokenManager,
  }) async {
    // If kind is specified and doesn't match this manager's kind, return null
    if (tokenManager != null && tokenManager != _tokenIssuer) return null;

    final String tokenId;
    try {
      tokenId = utf8.decode(base64Decode(token));
    } catch (e) {
      /// Silence if the token is not a valid base64 encoded string.
      /// The token is received from client requests and could be anything.
      return null;
    }

    // Check if the token exists (hasn't been revoked)
    final tokenInfo = _storage.getToken(tokenId);
    if (tokenInfo == null) return null;

    return AuthenticationInfo(
      tokenInfo.userId,
      tokenInfo.scopes,
      authId: tokenId,
    );
  }

  int get tokenCount => _storage.tokenCount;
  List<TokenInfo> get allTokens => _storage.allTokens;

  /// Exposes the authUsers instance for testing purposes.
  AuthUsers get authUsers => _authUsers;
}
