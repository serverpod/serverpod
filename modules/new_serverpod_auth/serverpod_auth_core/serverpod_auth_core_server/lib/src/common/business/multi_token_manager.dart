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
  late final Map<String, TokenManager> _allTokenManagers;

  /// Creates a new [MultiTokenManager] instance.
  ///
  /// The [primaryTokenManager] is always included in the internal manager list.
  /// Additional managers can be provided via [additionalTokenManagers].
  MultiTokenManager({
    required this.primaryTokenManager,
    required final Map<String, TokenManager> additionalTokenManagers,
  }) {
    _allTokenManagers = {
      primaryTokenManager.kind: primaryTokenManager,
      ...additionalTokenManagers,
    };
  }

  @override
  String get kind => 'multi';

  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) {
    return primaryTokenManager.issueToken(
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
    final String? kind,
  }) async {
    final managersToUse =
        kind != null ? {kind: _allTokenManagers[kind]!} : _allTokenManagers;

    await Future.wait(
      managersToUse.values.map(
        (final manager) => manager.revokeAllTokens(
          session: session,
          authUserId: authUserId,
          transaction: transaction,
          method: method,
          kind: null,
        ),
      ),
    );
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
    final String? kind,
  }) async {
    final managersToUse =
        kind != null ? {kind: _allTokenManagers[kind]!} : _allTokenManagers;

    await Future.wait(
      managersToUse.values.map(
        (final manager) => manager.revokeToken(
          session: session,
          tokenId: tokenId,
          transaction: transaction,
          kind: null,
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
    final String? kind,
  }) async {
    final managersToUse =
        kind != null ? {kind: _allTokenManagers[kind]!} : _allTokenManagers;

    final tokenLists = await Future.wait(
      managersToUse.values.map(
        (final manager) => manager.listTokens(
          session: session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
          kind: null,
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
    final String token, {
    final String? kind,
  }) async {
    final managersToUse =
        kind != null ? {kind: _allTokenManagers[kind]!} : _allTokenManagers;

    for (final manager in managersToUse.values) {
      final authInfo = await manager.validateToken(
        session,
        token,
        kind: null,
      );
      if (authInfo != null) {
        return authInfo;
      }
    }
    return null;
  }
}
