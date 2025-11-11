import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class SessionAuthenticationEndpoint extends Endpoint {
  /// Returns authenticated user identifier or null
  Future<String?> getAuthenticatedUserId(Session session) async {
    return session.authenticated?.userIdentifier;
  }

  /// Returns all scope names
  Future<List<String>> getAuthenticatedScopes(Session session) async {
    return session.authenticated?.scopes.map((s) => s.name).nonNulls.toList() ??
        [];
  }

  /// Returns authenticated auth ID or null
  Future<String?> getAuthenticatedAuthId(Session session) async {
    return session.authenticated?.authId;
  }

  /// Returns full authentication info
  Future<SessionAuthInfo> getAuthenticationInfo(Session session) async {
    var auth = session.authenticated;
    return SessionAuthInfo(
      isAuthenticated: auth != null,
      userId: auth?.userIdentifier,
      scopes: auth?.scopes.map((s) => s.name).nonNulls.toList() ?? [],
      authId: auth?.authId,
    );
  }

  /// Returns authentication status as boolean
  Future<bool> isAuthenticated(Session session) async {
    return session.authenticated != null;
  }

  // ========== Streaming Methods ==========

  /// Stream that yields authenticated user ID
  Stream<String?> streamAuthenticatedUserId(Session session) async* {
    yield session.authenticated?.userIdentifier;
  }

  /// Stream that yields authentication status
  Stream<bool> streamIsAuthenticated(Session session) async* {
    yield session.authenticated != null;
  }
}
