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

/// An interface for issuing authentication tokens.
///
/// Implementations of this interface are responsible for creating and storing
/// new authentication tokens for users.
abstract interface class TokenIssuer {
  /// The kind/type identifier for this token issuer.
  ///
  /// This is used to identify the token manager type
  String get kind;

  /// Issues an authentication token.
  ///
  /// Creates a new authentication token for the specified user with the given
  /// authentication method and optional scopes.
  ///
  /// Returns an [AuthSuccess] containing the generated token and user information.
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
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
  /// If [kind] is provided, only tokens from that specific token manager will be revoked.
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
    final String? kind,
  });

  /// Revokes a specific token by its ID.
  ///
  /// If the [tokenId] doesn't exist, the operation completes without error.
  /// If [kind] is provided, only tokens from that specific token manager will be revoked.
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
    final String? kind,
  });

  /// Lists all [TokenInfo]s matching the given criteria.
  ///
  /// If [authUserId] is provided, only tokens for that user will be listed.
  /// If [method] is provided, only tokens created with that authentication method will be listed.
  /// If [kind] is provided, only tokens from that specific token manager will be listed.
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
    final String? kind,
  });

  /// Validates an authentication token and returns the associated authentication information.
  ///
  /// Returns [AuthenticationInfo] if the token is valid, or `null` if the token is invalid,
  /// expired, or revoked.
  /// If [kind] is provided, only that specific token manager will be used for validation.
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token, {
    final String? kind,
  });
}
