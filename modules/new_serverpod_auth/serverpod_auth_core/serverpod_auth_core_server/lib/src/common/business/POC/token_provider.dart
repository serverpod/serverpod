// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Assumption: All token providers need to issue unique ids for their tokens.

/// Should we have two versions of this? One public that strips potential sensitive information
/// such as `method` and one private that retains all information.
class TokenInfo {
  final String userId;
  final String tokenId;
  // Provider name is required since we need something if we would like to clear out a now untrusted provider.
  // Or should we consider this not an option?
  final String tokenProvider;
  final Set<Scope> scopes;
  final String method;
  final String kind;

  TokenInfo({
    required this.userId,
    required this.tokenProvider,
    required this.tokenId,
    required this.scopes,
    required this.method,
    required this.kind,
  });

  @override
  String toString() {
    return 'TokenInfo(userId: $userId, tokenProvider: $tokenProvider, token: $tokenId, scopes: $scopes, method: $method, kind: $kind)';
  }
}

abstract interface class TokenProvider {
  Future<void> revokeAllTokens({
    required final UuidValue? authUserId,
    // required final Session session,
    required final Transaction? transaction,
    required final String? method,
    required final String? kind,
  });

  Future<void> revokeToken({
    required final String tokenId,
    // required final Session session,
    required final Transaction? transaction,
  });

  Future<List<TokenInfo>> listTokens({
    required final UuidValue? authUserId,
    required final String? method,
    required final String? kind,
    // required final Session session,
    required final Transaction? transaction,
  });
}
