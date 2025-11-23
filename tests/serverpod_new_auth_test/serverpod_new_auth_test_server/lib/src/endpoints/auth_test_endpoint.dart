import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Endpoint for testing authentication.
class AuthTestEndpoint extends Endpoint {
  late final ServerSideSessions _serverSideSessions =
      AuthServices.getTokenManager<ServerSideSessionsTokenManager>()
          .serverSideSessions;

  late final Jwt jwt = AuthServices.getTokenManager<JwtTokenManager>().jwt;

  /// Creates a new test user.
  Future<UuidValue> createTestUser(final Session session) async {
    const authUsers = AuthUsers();
    final authUser = await authUsers.create(session);
    return authUser.id;
  }

  /// Creates a new session authentication for the test user.
  Future<AuthSuccess> createSasToken(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return _serverSideSessions.createSession(
      session,
      authUserId: authUserId,
      method: 'test',
      scopes: {},
    );
  }

  Future<void> deleteSasTokens(
    final Session session,
    final UuidValue authUserId,
  ) async {
    await _serverSideSessions.destroyAllSessions(
      session,
      authUserId: authUserId,
    );
  }

  /// Creates a new JWT token for the test user.
  Future<AuthSuccess> createJwtToken(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return jwt.createTokens(
      session,
      authUserId: authUserId,
      method: 'test',
      scopes: {},
    );
  }

  /// Deletes all refresh tokens for the test user.
  Future<void> deleteJwtRefreshTokens(
    final Session session,
    final UuidValue authUserId,
  ) async {
    await jwt.destroyAllRefreshTokens(
      session,
      authUserId: authUserId,
    );
  }

  /// Destroys a specific refresh token by ID.
  Future<bool> destroySpecificRefreshToken(
    final Session session,
    final String token,
  ) async {
    final authInfo = await AuthServices.instance.authenticationHandler(
      session,
      token,
    );
    if (authInfo == null) {
      throw StateError(
        'Expected caller to be authenticated with a valid refresh token',
      );
    }

    return jwt.destroyRefreshToken(
      session,
      refreshTokenId: authInfo.serverSideSessionId,
    );
  }

  /// Checks if the session is authenticated for the test user.
  Future<bool> checkSession(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final userId = session.authenticated;
    return userId?.authUserId == authUserId;
  }
}
