import 'package:serverpod/serverpod.dart';
import 'package:uuid/v4.dart';

import '../../../../generated/protocol.dart';
import '../token_issuer.dart';
import '../token_provider.dart';

// Will probably use their own internal representation and not the public
// TokenInfo. But TokenInfo is used to simplify the example.
final Map<UuidValue, Set<TokenInfo>> _userTokens = {};

String _addToken(
  final UuidValue authUserId, {
  required final String method,
  required final String kind,
  required final Set<Scope> scope,
}) {
  final token = UuidValue.fromString(const UuidV4().generate()).toString();
  _userTokens.putIfAbsent(authUserId, () => {}).add(
        TokenInfo(
          userId: authUserId.toString(),
          tokenProvider: AuthStrategy.session.name,
          tokenId: token,
          scopes: scope,
          method: method,
          kind: kind,
        ),
      );
  return token;
}

class SSSTokenIssuer implements TokenIssuer {
  @override
  Future<AuthSuccess> issueToken({
    // required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final String kind,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    final token = _addToken(
      authUserId,
      method: method,
      kind: kind,
      scope: scopes ?? {},
    );

    return AuthSuccess(
      authStrategy: AuthStrategy.session,
      token: token,
      authUserId: authUserId,
      scopeNames: scopes?.map((final e) => e.name).nonNulls.toSet() ?? {},
      // ALEX: Needs to be added
      // kind: kind,
    );
  }
}

/// Implementation of a token provider using SSS tokens.
class SSSTokenProvider implements TokenProvider {
  @override
  Future<List<TokenInfo>> listTokens({
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
    required final String? kind,
  }) async {
    if (authUserId == null) {
      return _userTokens.values.expand((final tokens) => tokens).toList();
    }

    final tokens = _userTokens[authUserId] ?? {};
    return tokens.toList();
  }

  @override
  Future<void> revokeAllTokens({
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
    required final String? kind,
  }) async {
    if (authUserId == null && method == null && kind == null) {
      _userTokens.clear();
      return;
    }

    bool matchesMethod(
      final TokenInfo token,
    ) {
      return method != null && token.method == method;
    }

    bool matchesKind(final TokenInfo token) {
      return kind != null && token.kind == kind;
    }

    if (authUserId != null) {
      return _userTokens[authUserId]?.removeWhere(
          (final entry) => matchesMethod(entry) || matchesKind(entry));
    }

    final emptyUsers = <UuidValue>{};
    for (final entry in _userTokens.entries) {
      entry.value.removeWhere(
          (final token) => matchesMethod(token) || matchesKind(token));

      if (entry.value.isEmpty) {
        emptyUsers.add(entry.key);
      }
    }

    for (final userId in emptyUsers) {
      _userTokens.remove(userId);
    }
  }

  @override
  Future<void> revokeToken({
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    final emptyUsers = <UuidValue>{};
    for (final tokens in _userTokens.entries) {
      tokens.value.removeWhere((final token) => token.tokenId == tokenId);
      if (tokens.value.isEmpty) {
        emptyUsers.add(tokens.key);
      }
    }

    for (final userId in emptyUsers) {
      _userTokens.remove(userId);
    }
  }
}
