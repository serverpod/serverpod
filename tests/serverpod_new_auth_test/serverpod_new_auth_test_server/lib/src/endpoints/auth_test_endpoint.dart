import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_new_auth_test_server/server.dart';

/// Endpoint for testing authentication.
class AuthTestEndpoint extends Endpoint {
  final _authSessions = AuthSessions(
    config: AuthSessionsConfig(sessionKeyHashPepper: sessionKeyHashPepper),
  );

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
    return _authSessions.createSession(
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
    await _authSessions.destroyAllSessions(session, authUserId: authUserId);
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
