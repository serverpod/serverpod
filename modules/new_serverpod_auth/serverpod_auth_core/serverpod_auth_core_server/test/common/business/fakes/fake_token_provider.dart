import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';

import 'fake_token_storage.dart';

/// A fake implementation of [TokenProvider] for testing purposes.
class FakeTokenProvider implements TokenProvider {
  final FakeTokenStorage _storage;

  FakeTokenProvider(this._storage);

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

  void addToken(final TokenInfo token) {
    _storage.storeToken(token);
  }

  int get tokenCount => _storage.tokenCount;
  List<TokenInfo> get allTokens => _storage.allTokens;
}
