import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final serverSideSessions = ServerSideSessions(
    config: ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod('Given an auth session for a user,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue serverSideSessionId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await serverSideSessions.authUsers.create(session)).id;

      // ignore: unused_result
      await serverSideSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );

      serverSideSessionId = (await ServerSideSession.db.find(
        session,
      )).single.id!;
    });

    test(
      'when listing all sessions, then it is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(session);

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          serverSideSessionId,
        );
      },
    );

    test(
      'when listing sessions for the user, then it is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          authUserId: authUserId,
        );

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          serverSideSessionId,
        );
      },
    );

    test(
      'when listing sessions for another user, then nothing is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(sessions, isEmpty);
      },
    );

    test(
      'when listing sessions for its method, then it is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          method: 'test',
        );

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          serverSideSessionId,
        );
      },
    );

    test(
      'when listing sessions for another method, then nothing is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          method: 'something else',
        );

        expect(sessions, isEmpty);
      },
    );

    test(
      'when listing sessions for the user with its method, then it is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          authUserId: authUserId,
          method: 'test',
        );

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          serverSideSessionId,
        );
      },
    );

    test(
      'when listing sessions for the user with another method, then nothing is returned.',
      () async {
        final sessions = await serverSideSessions.listSessions(
          session,
          authUserId: authUserId,
          method: 'some other method',
        );

        expect(sessions, isEmpty);
      },
    );
  });
}
