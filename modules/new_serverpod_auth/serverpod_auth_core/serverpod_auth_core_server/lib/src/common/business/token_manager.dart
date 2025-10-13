import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

/// Information about an authentication token.
class TokenInfo {
  /// The ID of the user this token belongs to.
  final String userId;

  /// The unique identifier of this token.
  final String tokenId;

  /// The name of the token manager that issued this token.
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

/// A unified interface that combines token issuing and token management capabilities.
///
/// This class provides a single point of access for both creating new authentication
/// tokens and managing existing ones (listing, revoking, etc.).
abstract interface class TokenManager {
  /// Issues an authentication token.
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  });

  /// Revokes all tokens matching the given criteria.
  ///
  /// If [authUserId] is provided, only tokens for that user will be revoked.
  /// If [method] is provided, only tokens created with that authentication method will be revoked.
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  });

  /// Revokes a specific token by its ID.
  ///
  /// If the [tokenId] doesn't exist, the operation completes without error.
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
  });

  /// Lists all [TokenInfo]s matching the given criteria.
  ///
  /// If [authUserId] is provided, only tokens for that user will be listed.
  /// If [method] is provided, only tokens created with that authentication method will be listed.
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
  });

  /// Validates an authentication token and returns the associated authentication information.
  ///
  /// Returns [AuthenticationInfo] if the token is valid, or `null` if the token is invalid,
  /// expired, or revoked.
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  );
}
