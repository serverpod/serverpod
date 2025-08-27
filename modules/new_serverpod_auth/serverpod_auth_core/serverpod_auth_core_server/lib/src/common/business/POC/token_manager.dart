// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'token_provider.dart';

class TokenManager {
  final Map<String, TokenProvider> _tokenProvider;

  TokenManager(final Map<String, TokenProvider> tokenProviders)
      : _tokenProvider = {for (var p in tokenProviders.entries) p.key: p.value};

  Future<void> revokeAllTokens({
    final UuidValue? authUserId,
    final Transaction? transaction,
    final String? tokenProvider,
    final String? method,
    final String? kind,
  }) async {
    if (tokenProvider != null) {
      final delegate = _lookupProvider(tokenProvider);
      return await delegate.revokeAllTokens(
        authUserId: authUserId,
        transaction: transaction,
        method: method,
        kind: kind,
      );
    }

    for (final delegate in _tokenProvider.values) {
      await delegate.revokeAllTokens(
        authUserId: authUserId,
        transaction: transaction,
        method: method,
        kind: kind,
      );
    }
  }

  Future<void> revokeToken({
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    for (final provider in _tokenProvider.values) {
      await provider.revokeToken(
        tokenId: tokenId,
        transaction: transaction,
      );
    }
  }

  Future<List<TokenInfo>> listTokens({
    final UuidValue? authUserId,
    final Transaction? transaction,
    final String? tokenProvider,
    final String? method,
    final String? kind,
  }) async {
    if (tokenProvider != null) {
      final TokenProvider delegate = _lookupProvider(tokenProvider);

      return delegate.listTokens(
        authUserId: authUserId,
        transaction: transaction,
        method: method,
        kind: kind,
      );
    }

    final tokenLists = await Future.wait(
      _tokenProvider.values.map(
        (final tokenProvider) => tokenProvider.listTokens(
          authUserId: authUserId,
          transaction: transaction,
          method: method,
          kind: kind,
        ),
      ),
    );

    return tokenLists.expand((final tokens) => tokens).toList();
  }

  TokenProvider _lookupProvider(final String provider) {
    final TokenProvider? delegate = _tokenProvider[provider];
    if (delegate == null) {
      throw ArgumentError('No provider found for symbol $provider');
    }
    return delegate;
  }
}
