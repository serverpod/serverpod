import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'token_manager.dart';

/// A composite token manager that delegates operations to multiple underlying token managers.
///
/// This class allows for managing multiple token types or providers through a single interface.
/// The [primaryTokenManager] is used for issuing new tokens, while all managers in
/// [_allTokenManagers] (which includes both the primary and additional managers) are used for
/// management operations like listing and revoking tokens.
class MultiTokenManager implements TokenManager {
  /// The primary token manager used for issuing new tokens.
  final TokenManager primaryTokenManager;

  /// Map of all token managers including the primary and additional managers,
  /// keyed by their kind (e.g., 'jwt', 'session').
  late final List<TokenManager> _allTokenManagers;

  /// Creates a new [MultiTokenManager] instance.
  ///
  /// The [primaryTokenManager] is always included in the internal manager list.
  /// Additional managers can be provided via [additionalTokenManagers].
  MultiTokenManager({
    required this.primaryTokenManager,
    required final List<TokenManager> additionalTokenManagers,
  }) {
    _allTokenManagers = [
      primaryTokenManager,
      ...additionalTokenManagers,
    ];
  }

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) {
    return primaryTokenManager.issueToken(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {
    await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.revokeAllTokens(
          session,
          authUserId: authUserId,
          transaction: transaction,
          method: method,
          tokenIssuer: tokenIssuer,
        ),
      ),
    );
  }

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {
    await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.revokeToken(
          session,
          tokenId: tokenId,
          transaction: transaction,
          tokenIssuer: tokenIssuer,
        ),
      ),
    );
  }

  @override
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
  }) async {
    final tokenLists = await Future.wait(
      _allTokenManagers.map(
        (final manager) => manager.listTokens(
          session,
          authUserId: authUserId,
          method: method,
          tokenIssuer: tokenIssuer,
          transaction: transaction,
        ),
      ),
    );

    return tokenLists.expand((final tokens) => tokens).toList();
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    for (final manager in _allTokenManagers) {
      final authInfo = await manager.validateToken(
        session,
        token,
      );
      if (authInfo != null) {
        return authInfo;
      }
    }
    return null;
  }

  /// Retrieves the token manager of type [T].
  T getTokenManager<T extends TokenManager>() {
    for (final manager in _allTokenManagers) {
      if (manager is T) {
        return manager;
      }
    }
    throw StateError('No token manager of type $T found');
  }
}
