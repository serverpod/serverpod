import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Endpoint for testing authentication.
class AuthTestEndpoint extends Endpoint {
  late final AuthSessions _authSessions =
      AuthServices.getTokenManager<AuthSessionsTokenManager>().authSessions;

  late final AuthenticationTokens _authenticationTokens =
      AuthServices.getTokenManager<AuthenticationTokensTokenManager>()
          .authenticationTokens;

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
    return _authenticationTokens.createTokens(
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
    await _authenticationTokens.destroyAllRefreshTokens(
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
