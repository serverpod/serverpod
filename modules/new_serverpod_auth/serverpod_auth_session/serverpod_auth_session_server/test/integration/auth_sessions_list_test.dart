import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a session,', (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

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
    });

    test(
      'when calling `listsessions`, then it is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(session);

        expect(
          sessions,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `listSessions` for the user, then it is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          authUserId: authUserId,
        );

        expect(
          sessions,
          hasLength(1),
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

    test(
      'when calling `listSessions` for its `method`, then it is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          method: 'test',
        );

        expect(
          sessions,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `listSessions` for another `method`, then nothing is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          method: 'something else',
        );

        expect(sessions, isEmpty);
      },
    );

    test(
      'when calling `listSessions` for the user with its `method`, then it is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          authUserId: authUserId,
          method: 'test',
        );

        expect(
          sessions,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `listSessions` for the user with another `method`, then nothing is returned.',
      () async {
        final sessions = await AuthSessions.listSessions(
          session,
          authUserId: authUserId,
          method: 'some other method',
        );

        expect(sessions, isEmpty);
      },
    );
  });
}
