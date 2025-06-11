import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/generated/auth_session.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an auth session for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue authSessionId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      // ignore: unused_result
      await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
      authSessionId = (await AuthSession.db.find(session)).single.id!;
    });

    test(
      'when calling `listSessions` for the user, then it is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          authUserId: authUserId,
        );

        expect(
          sessions.single.id,
          authSessionId,
        );
      },
    );

    test(
      'when calling `listSessions` for another user, then nothing is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(sessions, isEmpty);
      },
    );
  });
}
