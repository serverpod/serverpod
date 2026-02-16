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

  withServerpod(
    'Given sessions with different expiration states',
    (
      final sessionBuilder,
      final endpoints,
    ) {
      late Session session;
      late UuidValue authUserId;
      late UuidValue activeSessionId;
      late UuidValue expiredByDateSessionId;
      late UuidValue expiredByInactivitySessionId;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = (await serverSideSessions.authUsers.create(session)).id;

        // Create an active session (no expiration)
        // ignore: unused_result
        await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'active',
        );

        // Create a session that will be expired by date
        // ignore: unused_result
        await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'expired-by-date',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );

        // Create a session that will be expired by inactivity
        // ignore: unused_result
        await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'expired-by-inactivity',
          expireAfterUnusedFor: const Duration(hours: 1),
        );

        // Update the last used time to make it expired
        final expiredByInactivitySession = (await ServerSideSession.db.find(
          session,
          where: (final t) => t.method.equals('expired-by-inactivity'),
        )).single;

        await ServerSideSession.db.updateRow(
          session,
          expiredByInactivitySession.copyWith(
            lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        );

        final sessions = await ServerSideSession.db.find(session);
        activeSessionId = sessions.firstWhere((final s) => s.method == 'active').id!;
        expiredByDateSessionId = sessions
            .firstWhere((final s) => s.method == 'expired-by-date')
            .id!;
        expiredByInactivitySessionId = sessions
            .firstWhere((final s) => s.method == 'expired-by-inactivity')
            .id!;
      });

      test(
        'when listing all sessions without filter then all sessions are returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(session);

          expect(sessions, hasLength(3));
        },
      );

      test(
        'when listing only non-expired sessions then only active session is returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(
            session,
            expired: false,
          );

          expect(sessions, hasLength(1));
          expect(sessions.single.id, activeSessionId);
        },
      );

      test(
        'when listing only expired sessions then both expired sessions are returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(
            session,
            expired: true,
          );

          expect(sessions, hasLength(2));
          expect(
            sessions.map((final s) => s.id).toSet(),
            {expiredByDateSessionId, expiredByInactivitySessionId},
          );
        },
      );

      test(
        'when filtering by user and expired status then correct sessions are returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(
            session,
            authUserId: authUserId,
            expired: false,
          );

          expect(sessions, hasLength(1));
          expect(sessions.single.id, activeSessionId);
        },
      );

      test(
        'when filtering by method and expired status then correct session is returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(
            session,
            method: 'expired-by-date',
            expired: true,
          );

          expect(sessions, hasLength(1));
          expect(sessions.single.id, expiredByDateSessionId);
        },
      );

      test(
        'when filtering non-expired by method that is expired then no sessions are returned.',
        () async {
          final sessions = await serverSideSessions.listSessions(
            session,
            method: 'expired-by-date',
            expired: false,
          );

          expect(sessions, isEmpty);
        },
      );
    },
  );
}
