import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';

/// In-memory token storage for testing purposes.
///
/// This class provides shared storage that can be injected into both
/// [FakeTokenIssuer] and [FakeTokenProvider] to ensure they work with
/// the same token data during tests.
class FakeTokenStorage {
  final Map<String, TokenInfo> _tokens = {};
  int _tokenCounter = 0;

  void storeToken(final TokenInfo token) {
    _tokens[token.tokenId] = token;
  }

  void removeToken(final String tokenId) {
    _tokens.remove(tokenId);
  }

  void removeTokensWhere({
    final String? userId,
    final String? method,
  }) {
    final tokensToRemove = _tokens.values.where((final token) {
      if (userId != null && token.userId != userId) {
        return false;
      }
      if (method != null && token.method != method) {
        return false;
      }
      return true;
    }).toList();

    for (final token in tokensToRemove) {
      _tokens.remove(token.tokenId);
    }
  }

  List<TokenInfo> getTokensWhere({
    final String? userId,
    final String? method,
  }) {
    return _tokens.values.where((final token) {
      if (userId != null && token.userId != userId) {
        return false;
      }
      if (method != null && token.method != method) {
        return false;
      }
      return true;
    }).toList();
  }

  String generateTokenId() {
    _tokenCounter++;
    return 'token-$_tokenCounter';
  }

  String generateRefreshTokenId() {
    return 'refresh-token-$_tokenCounter';
  }

  void clear() {
    _tokens.clear();
    _tokenCounter = 0;
  }

  int get tokenCount => _tokens.length;
  List<TokenInfo> get allTokens => _tokens.values.toList();
  int get currentTokenCounter => _tokenCounter;
}
