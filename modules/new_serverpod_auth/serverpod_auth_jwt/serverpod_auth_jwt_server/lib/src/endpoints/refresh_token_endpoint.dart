import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';

/// Refresh token rotation endpoint.
@doNotGenerate
class RefreshTokenEndpoint extends Endpoint {
  /// Creates a new token pair for the given [refreshToken].
  ///
  /// - Throws a [RefreshTokenMalformedException] in case the refresh token is malformed.
  /// - Throws a [RefreshTokenNotFoundException] in case the refresh token is unknown.
  /// - Throws a [RefreshTokenExpiredException] in case the refresh token has expired, meaning it has not been used in the timeframe configured in `refreshTokenLifetime`.
  /// - Throws a [RefreshTokenInvalidSecretException] in case the refresh token is incorrect, meaning it does not refer to the current secret refresh token.
  ///   This indicates either a malfunctioning client or a malicious attempt by someone who has obtained the refresh token.
  ///   In this case the underlying refresh token will be deleted, and access to it will expire fully when the last access token is elapsed.
  Future<TokenPair> rotateTokens(
    final Session session, {
    required final String refreshToken,
  }) async {
    return AuthenticationTokens.rotateRefreshToken(
      session,
      refreshToken: refreshToken,
    );
  }
}
