import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'token_manager.dart';

/// A composite token manager that delegates operations to multiple underlying token managers.
///
/// This class allows for managing multiple token types or providers through a single interface.
/// The [defaultTokenManager] is used for issuing new tokens, while all managers (including
/// additional ones) are used for management operations like listing and revoking tokens.
class MultiTokenManager implements TokenManager {
  /// The primary token manager used for issuing new tokens.
  final TokenManager defaultTokenManager;

  late final List<TokenManager> _allTokenManagers;

  /// Creates a new [MultiTokenManager] instance.
  MultiTokenManager({
    required this.defaultTokenManager,
    required final List<TokenManager> additionalTokenManagers,
  }) {
    _allTokenManagers = [defaultTokenManager, ...additionalTokenManagers];
  }

  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) {
    return defaultTokenManager.issueToken(
      session: session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.revokeAllTokens(
          session: session,
          authUserId: authUserId,
          transaction: transaction,
          method: method,
        ),
      ),
    );
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
  }) async {
    await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.revokeToken(
          session: session,
          tokenId: tokenId,
          transaction: transaction,
        ),
      ),
    );
  }

  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
  }) async {
    final tokenLists = await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.listTokens(
          session: session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
        ),
      ),
    );

    final allTokens = <TokenInfo>[];
    for (final tokenList in tokenLists) {
      allTokens.addAll(tokenList);
    }

    return allTokens;
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    for (final manager in _allTokenManagers) {
      final authInfo = await manager.validateToken(session, token);
      if (authInfo != null) {
        return authInfo;
      }
    }
    return null;
  }
}
