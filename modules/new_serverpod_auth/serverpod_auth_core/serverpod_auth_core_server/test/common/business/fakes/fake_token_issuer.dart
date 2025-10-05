import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'fake_token_storage.dart';

/// A fake implementation of [TokenIssuer] for testing purposes.
///
/// This implementation provides predictable responses and stores issued tokens
/// in shared storage that can be accessed by other components.
class FakeTokenIssuer implements TokenIssuer {
  final FakeTokenStorage _storage;

  FakeTokenIssuer(this._storage);

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

  int get tokenCount => _storage.currentTokenCounter;
}
