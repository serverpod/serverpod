import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart';

class SessionTestEndpoint extends Endpoint {
  Future<UuidValue> createTestUser(final Session session) async {
    final authUser = await AuthUsers.create(session);

    return authUser.id;
  }

  Future<AuthSuccess> createSession(
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

  Future<bool> checkSession(
    final Session session,
    final UuidValue authUserId,
  ) async {
    return (await session.authenticated)?.userUuid == authUserId;
  }
}
