import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';

// TODO: Name TBD, just repository is already taken
final class Sessions {
  /// Returns session key.
  static Future<String> create(
    Session session, {
    required UuidValue userId,
  }) async {
    final sessionKey = 'random${DateTime.now()}';

    await ActiveSession.db.insertRow(
      session,
      ActiveSession(
        userId: userId,
        created: DateTime.now(),
        sessionKey: sessionKey,
      ),
    );

    return sessionKey;
  }

  /// Returns user ID if session is active
  static Future<UuidValue> check(
    Session session, {
    required String sessionKey,
  }) async {
    return (await ActiveSession.db.findFirstRow(session,
            where: (r) => r.sessionKey.equals(sessionKey)))!
        .userId;
  }
}
