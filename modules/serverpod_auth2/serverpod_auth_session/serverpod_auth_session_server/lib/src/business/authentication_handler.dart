import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';

Future<AuthenticationInfo?> authenticationHandler(
  Session session,
  String key, [
  Future<UuidValue?> Function(Session session, String key)?
      sessionMigrationCallback,
]) async {
  final userSession = await ActiveSession.db.findFirstRow(
    session,
    where: (r) => r.sessionKey.equals(key),
  );

  if (userSession != null) {
    return AuthenticationInfo(
      userSession.userId,
      {}, // TODO: Thread scopes for join?
      authId: userSession.id!.toString(),
    );
  }

  if (sessionMigrationCallback != null) {
    final userId = await sessionMigrationCallback(session, key);
    if (userId == null) {
      return null;
    }

    await ActiveSession.db.insertRow(
      session,
      ActiveSession(
        userId: userId,
        // we keep re-using the key here, so that we can look it up quickly the next time
        // (as the migration package can not really help us here, as it does not want to create
        // a dependency on this specific session handling)
        // maybe we could prefix this imported key though, and use an $key or $foo$key query above
        sessionKey: key,
        created: DateTime.now(),
      ),
    );

    return AuthenticationInfo(
      userId,
      {}, // TODO: Thread scopes
      authId: '', // TODO
    );
  }

  return null;
}

AuthenticationHandler authenticationHandlerWithMigration(
  Future<UuidValue?> Function(Session session, String key)?
      sessionMigrationCallback,
) {
  return (session, key) {
    return authenticationHandler(session, key, sessionMigrationCallback);
  };
}
