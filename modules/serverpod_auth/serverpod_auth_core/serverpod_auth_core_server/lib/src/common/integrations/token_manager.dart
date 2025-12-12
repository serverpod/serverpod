import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

/// Information about an authentication token.
class TokenInfo {
  /// The ID of the user this token belongs to.
  final String userId;

  /// The unique identifier of this token.
  final String tokenId;

  /// The name of the token issuer that issued this token.
  final String tokenIssuer;

  /// The scopes granted by this token.
  final Set<Scope> scopes;

  /// The authentication method used to create this token.
  final String method;

  /// Creates a new [TokenInfo] instance.
  TokenInfo({
    required this.userId,
    required this.tokenIssuer,
    required this.tokenId,
    required this.scopes,
    required this.method,
  });

  @override
  String toString() {
    return 'TokenInfo(userId: $userId, tokenIssuer: $tokenIssuer, tokenId: $tokenId, scopes: $scopes, method: $method)';
  }
}

/// An interface for issuing authentication tokens.
///
/// Implementations of this interface are responsible for creating and storing
/// new authentication tokens for users.
abstract interface class TokenIssuer {
  /// Issues an authentication token.
  ///
  /// Creates a new authentication token for the specified user with the given
  /// authentication method and optional scopes.
  ///
  /// Returns an [AuthSuccess] containing the generated token and user information.
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  });
}

/// An interface for managing authentication tokens.
///
/// This interface extends [TokenIssuer] to provide comprehensive token management
/// capabilities including issuing, validating, listing, and revoking tokens.
abstract interface class TokenManager implements TokenIssuer {
  /// Revokes all tokens matching the given criteria.
  ///
  /// If [authUserId] is provided, only tokens for that user will be revoked.
  /// If [method] is provided, only tokens created with that authentication method will be revoked.
  /// If [tokenIssuer] is provided, only tokens from that specific token manager will be revoked.
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  });

  /// Revokes a specific token by its ID.
  ///
  /// If the [tokenId] doesn't exist, the operation completes without error.
  /// If [tokenIssuer] is provided, only tokens from that specific token manager will be revoked.
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  });

  /// Lists all [TokenInfo]s matching the given criteria.
  ///
  /// If [authUserId] is provided, only tokens for that user will be listed.
  /// If [method] is provided, only tokens created with that authentication method will be listed.
  /// If [tokenIssuer] is provided, only tokens from that specific token manager will be listed.
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
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
