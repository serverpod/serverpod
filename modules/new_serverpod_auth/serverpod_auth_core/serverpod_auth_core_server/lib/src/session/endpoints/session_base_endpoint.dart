import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';

/// Base endpoint for auth sessions.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
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
