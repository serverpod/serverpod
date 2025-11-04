import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:uuid/uuid.dart';

/// In-memory token storage for testing purposes.
///
/// This class provides shared storage that can be injected into
/// [FakeTokenManager] and related test classes to ensure they work with
/// the same token data during tests.
class FakeTokenStorage {
  final Map<String, TokenInfo> _tokens = {};

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

  TokenInfo? getToken(final String tokenId) {
    return _tokens[tokenId];
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
    return 'fake-token-${const Uuid().v4()}';
  }

  String generateRefreshTokenId() {
    return 'fake-refresh-token-${const Uuid().v4()}';
  }

  void clear() {
    _tokens.clear();
  }

  /// Should never be called.
  int get tokenCount => _tokens.length;

  /// Should be removed.
  List<TokenInfo> get allTokens => _tokens.values.toList();
}
