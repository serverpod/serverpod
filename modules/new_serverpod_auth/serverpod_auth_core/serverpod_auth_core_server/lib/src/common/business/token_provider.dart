import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Information about an authentication token.
class TokenInfo {
  /// The ID of the user this token belongs to.
  final String userId;

  /// The unique identifier of this token.
  final String tokenId;

  /// The name of the provider that issued this token.
  final String tokenProvider;

  /// The scopes granted by this token.
  final Set<Scope> scopes;

  /// The authentication method used to create this token.
  final String method;

  /// Creates a new [TokenInfo] instance.
  TokenInfo({
    required this.userId,
    required this.tokenProvider,
    required this.tokenId,
    required this.scopes,
    required this.method,
  });

  @override
  String toString() {
    return 'TokenInfo(userId: $userId, tokenProvider: $tokenProvider, token: $tokenId, scopes: $scopes, method: $method)';
  }
}

/// Interface for token providers that can manage authentication tokens.
abstract interface class TokenProvider {
  /// Revokes all tokens matching the given criteria.
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  });

  /// Revokes a specific token by its ID.
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
  });

  /// Lists all [TokenInfo]s matching the given criteria.
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
  });
}
