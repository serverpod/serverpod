import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'jwt_refresh_endpoint.dart';

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
    return AuthServices.getTokenManager<ServerSideSessionsTokenManager>()
        .issueToken(
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
    await _serverSideSessions.revokeAllSessions(
      session,
      authUserId: authUserId,
    );
  }

  /// Creates a new JWT token for the test user.
  Future<AuthSuccess> createJwtToken(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return AuthServices.getTokenManager<JwtTokenManager>().issueToken(
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
    await jwt.revokeAllRefreshTokens(
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

    return jwt.revokeRefreshToken(
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

  @unauthenticatedClientCall
  Future<bool> checkSessionUnauthenticated(final Session session) async {
    return session.isUserSignedIn;
  }

  @unauthenticatedClientCall
  Stream<bool> checkSessionUnauthenticatedStream(
    final Session session,
  ) async* {
    yield session.isUserSignedIn;
  }

  Stream<String?> openPublicUserStream(final Session session) async* {
    yield session.authenticated?.userIdentifier;
    await Completer<void>().future;
  }

  Future<void> resetJwtRefreshConcurrency(final Session session) async {
    JwtRefreshEndpoint.resetConcurrencyTracking();
  }

  Future<int> getMaxConcurrentJwtRefreshes(final Session session) async {
    return JwtRefreshEndpoint.maxConcurrentRefreshes;
  }

  Future<int> getJwtRefreshCallCount(final Session session) async {
    return JwtRefreshEndpoint.refreshCallCount;
  }

  /// Returns the auth-mode marker and whether an authorization header was
  /// received, as seen by the server on this authenticated call.
  Future<List<String?>> getReceivedAuthHeaders(final Session session) async {
    return _receivedAuthHeaders(session);
  }

  /// Like [getReceivedAuthHeaders], for an unauthenticated call.
  @unauthenticatedClientCall
  Future<List<String?>> getReceivedAuthHeadersUnauthenticated(
    final Session session,
  ) async {
    return _receivedAuthHeaders(session);
  }

  static List<String?> _receivedAuthHeaders(final Session session) {
    final headers = session.request?.headers;
    return [
      headers?[webAuthModeHeaderName]?.firstOrNull,
      headers?['authorization'] == null ? null : 'present',
    ];
  }
}

class UnauthenticatedRequireLoginAuthTestEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @unauthenticatedClientCall
  Future<void> call(final Session session) async {}
}
