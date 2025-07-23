import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Base endpoint for auth sessions.
abstract class SessionBaseEndpoint extends Endpoint {
  /// Checks whether the caller is authenticated.
  ///
  /// Return `true` if the caller is authentication, `false` otherwise.
  /// Does not error on missing authentication.
  Future<bool> isAuthenticated(final Session session) async {
    return await session.authenticated != null;
  }

  /// Logs out the current user.
  ///
  /// Returns `true` if the user was actually logged out, and `false` if the
  /// calling session was not valid anymore.
  Future<bool> logout(
    final Session session, {
    /// Whether to destroy all of the user's sessions, or only the current one.
    final bool allSessions = false,
  }) async {
    final authInfo = await session.authenticated;

    if (authInfo == null) {
      return false;
    }

    if (allSessions) {
      await AuthSessions.destroyAllSessions(
        session,
        authUserId: authInfo.authUserId,
      );
    } else {
      await AuthSessions.destroySession(
        session,
        authSessionId: authInfo.authSessionId,
      );
    }

    return true;
  }
}
