import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';

/// Manages multiple [TokenProvider]s and delegates operations to them.
class TokenManager {
  /// The map of token providers keyed by their provider name.
  @internal
  final Map<String, TokenProvider> tokenProviders;

  /// Creates a new [TokenManager] with the given token providers.
  TokenManager(final Map<String, TokenProvider> providers)
      : tokenProviders = {for (var p in providers.entries) p.key: p.value};

  /// Revokes all tokens matching the given criteria.
  Future<void> revokeAllTokens({
    required final Session session,
    final UuidValue? authUserId,
    final Transaction? transaction,
    final String? tokenProvider,
    final String? method,
  }) async {
    if (tokenProvider != null) {
      final delegate = _lookupProvider(tokenProvider);
      return await delegate.revokeAllTokens(
        session: session,
        authUserId: authUserId,
        transaction: transaction,
        method: method,
      );
    }

    await Future.wait([
      for (final delegate in tokenProviders.values)
        delegate.revokeAllTokens(
          session: session,
          authUserId: authUserId,
          transaction: transaction,
          method: method,
        ),
    ]);
  }

  /// Revokes a specific token by ID.
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    await Future.wait([
      for (final provider in tokenProviders.values)
        provider.revokeToken(
          session: session,
          tokenId: tokenId,
          transaction: transaction,
        ),
    ]);
  }

  /// Lists all [TokenInfo]s matching the given criteria.
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    final UuidValue? authUserId,
    final Transaction? transaction,
    final String? tokenProvider,
    final String? method,
  }) async {
    if (tokenProvider != null) {
      final TokenProvider delegate = _lookupProvider(tokenProvider);

      return delegate.listTokens(
        session: session,
        authUserId: authUserId,
        transaction: transaction,
        method: method,
      );
    }

    final tokenLists = await Future.wait(
      tokenProviders.values.map(
        (final tokenProvider) => tokenProvider.listTokens(
          session: session,
          authUserId: authUserId,
          transaction: transaction,
          method: method,
        ),
      ),
    );

    return tokenLists.expand((final tokens) => tokens).toList();
  }

  TokenProvider _lookupProvider(final String provider) {
    final TokenProvider? delegate = tokenProviders[provider];
    if (delegate == null) {
      throw ArgumentError('No provider found for symbol $provider');
    }
    return delegate;
  }
}
