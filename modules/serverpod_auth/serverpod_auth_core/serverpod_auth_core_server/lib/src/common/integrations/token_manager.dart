import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';

import 'cookie_auth_success.dart';

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

/// A base class for issuing authentication tokens.
///
/// Implementations provide the token creation through [createToken], while
/// the non-virtual [issueToken] applies the sign-in policy and the delivery
/// of the issued secrets, uniformly for every token type.
abstract class TokenIssuer {
  /// Creates a new [TokenIssuer].
  const TokenIssuer();

  /// Issues an authentication token for [authUserId] and delivers it
  /// according to the request.
  ///
  /// An authenticated caller may only re-issue a token for themself; issuing
  /// for a different user throws a [SignInWhileAuthenticatedException]
  /// (switching users requires a sign-out first). To mint a token on behalf
  /// of another user (e.g. an admin flow), call [createToken] directly.
  ///
  /// On a cookie-mode web request the issued secrets are set as `HttpOnly`
  /// cookies and hidden from the response body: a refresh token moves to the
  /// refresh cookie, otherwise a non-empty token moves to the auth cookie.
  ///
  /// Returns an [AuthSuccess] containing the token and user information.
  @nonVirtual
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) async {
    final callerIdentifier = session.authenticated?.userIdentifier;
    if (callerIdentifier != null && callerIdentifier != authUserId.toString()) {
      throw SignInWhileAuthenticatedException();
    }

    final authSuccess = await createToken(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
    if (!session.isWebAuthCookieRequest) return authSuccess;

    final refreshToken = authSuccess.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      session.writeWebAuthRefreshCookie(
        refreshToken,
        maxAgeSeconds: _maxAgeSeconds(refreshTokenExpiresAt()),
        path: refreshCookiePath(session),
      );
      return CookieAuthSuccess(authSuccess, maskRefreshToken: true);
    }
    if (authSuccess.token.isNotEmpty) {
      session.writeWebAuthCookie(
        authSuccess.token,
        maxAgeSeconds: _maxAgeSeconds(authSuccess.tokenExpiresAt),
      );
      return CookieAuthSuccess(authSuccess, maskToken: true);
    }
    return authSuccess;
  }

  /// Creates a new authentication token for the specified user with the
  /// given authentication method and optional scopes.
  ///
  /// Unlike [issueToken] this performs no sign-in policy check and no cookie
  /// delivery; the returned [AuthSuccess] always carries the secrets.
  Future<AuthSuccess> createToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  });

  /// The expiry of a cookie-delivered refresh token, or null for a browser
  /// session cookie.
  DateTime? refreshTokenExpiresAt() => null;

  /// The cookie `Path` for a cookie-delivered refresh token, or null for the
  /// configured auth cookie path.
  String? refreshCookiePath(final Session session) => null;

  static int? _maxAgeSeconds(final DateTime? expiresAt) {
    if (expiresAt == null) return null;
    final seconds = expiresAt.difference(clock.now()).inSeconds;
    return seconds > 0 ? seconds : null;
  }
}

/// A base class for managing authentication tokens.
///
/// This class extends [TokenIssuer] to provide comprehensive token management
/// capabilities including issuing, validating, listing, and revoking tokens.
abstract class TokenManager extends TokenIssuer {
  /// Creates a new [TokenManager].
  const TokenManager();

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
