import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Endpoint for testing authentication.
class AuthTestEndpoint extends Endpoint {
  /// Creates a new test user.
  Future<UuidValue> createTestUser(final Session session) async {
    final authUser = await AuthUsers.create(session);
    return authUser.id;
  }

  /// Creates a new session authentication for the test user.
  Future<AuthSuccess> createSasToken(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return AuthSessions.createSession(
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
    await AuthSessions.destroyAllSessions(session, authUserId: authUserId);
  }

  /// Creates a new JWT token for the test user.
  Future<AuthSuccess> createJwtToken(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return AuthenticationTokens.createTokens(
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
    await AuthenticationTokens.destroyAllRefreshTokens(
      session,
      authUserId: authUserId,
    );
  }

  /// Checks if the session is authenticated for the test user.
  Future<bool> checkSession(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final userId = await session.authenticated;
    return userId?.authUserId == authUserId;
  }
}
