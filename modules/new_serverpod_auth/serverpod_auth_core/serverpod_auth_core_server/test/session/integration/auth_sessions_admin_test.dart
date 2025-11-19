import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final authSessions = AuthSessions(
    config: AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod('Given an auth session,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue authSessionId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await authSessions.authUsers.create(session)).id;

      // ignore: unused_result
      await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );

      authSessionId = (await AuthSession.db.find(session)).single.id!;
    });

    test(
      'when calling `findSessions`, then it is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(session);

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          authSessionId,
        );
      },
    );

    test(
      'when calling `findSessions` for the user, then it is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
          session,
          authUserId: authUserId,
        );

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          authSessionId,
        );
      },
    );

    test(
      'when calling `findSessions` for another user, then nothing is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(sessions, isEmpty);
      },
    );

    test(
      'when calling `findSessions` for its `method`, then it is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
          session,
          method: 'test',
        );

        expect(
          sessions,
          hasLength(1),
        );
        expect(
          sessions.single.id,
          authSessionId,
        );
      },
    );

    test(
      'when calling `findSessions` for another `method`, then nothing is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
          session,
          method: 'something else',
        );

        expect(sessions, isEmpty);
      },
    );

    test(
      'when calling `findSessions` for the user with its `method`, then it is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
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
          authSessionId,
        );
      },
    );

    test(
      'when calling `findSessions` for the user with another `method`, then nothing is returned.',
      () async {
        final sessions = await AuthSessionsAdmin().findSessions(
          session,
          authUserId: authUserId,
          method: 'some other method',
        );

        expect(sessions, isEmpty);
      },
    );
  });

  withServerpod('Given an auth session,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue authSessionId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await authSessions.authUsers.create(session)).id;

      // ignore: unused_result
      await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );

      authSessionId = (await AuthSession.db.find(session)).single.id!;
    });

    test(
      'when calling `deleteSessions`, then it is deleted and tuple returned.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(session);

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, authSessionId);
        expect(await AuthSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for the user, then it is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          authUserId: authUserId,
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, authSessionId);
        expect(await AuthSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for another user, then nothing is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(deleted, isEmpty);
        expect(await AuthSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for its `method`, then it is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          method: 'test',
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, authSessionId);
        expect(await AuthSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for another `method`, then nothing is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          method: 'something else',
        );

        expect(deleted, isEmpty);
        expect(await AuthSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for the session id, then it is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          authSessionId: authSessionId,
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, authSessionId);
        expect(await AuthSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` with another session id, then nothing is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          authSessionId: const Uuid().v4obj(),
        );

        expect(deleted, isEmpty);
        expect(await AuthSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for the user with another `method`, then nothing is deleted.',
      () async {
        final deleted = await AuthSessionsAdmin().deleteSessions(
          session,
          authUserId: authUserId,
          method: 'some other method',
        );

        expect(deleted, isEmpty);
        expect(await AuthSession.db.count(session), 1);
      },
    );
  });

  withServerpod(
    'Given an auth session expiring in 1 day,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().add(const Duration(days: 1));
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = (await authSessions.authUsers.create(session)).id;

        // ignore: unused_result
        await authSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
          method: 'test',
        );
      });

      test(
        'when calling `deleteExpiredSessions` right away, then it is kept.',
        () async {
          await AuthSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await AuthSession.db.count(session),
            1,
          );
        },
      );
    },
  );

  withServerpod(
    'Given an expired auth session,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().subtract(const Duration(days: 1));
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = (await authSessions.authUsers.create(session)).id;

        // ignore: unused_result
        await authSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
          method: 'test',
        );
      });

      test(
        'when calling `deleteExpiredSessions`, then it is deleted.',
        () async {
          await AuthSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await AuthSession.db.count(session),
            0,
          );
        },
      );

      test(
        'when calling `deleteExpiredSessions` with `deleteExpired: false`, then it is kept.',
        () async {
          await AuthSessionsAdmin().deleteExpiredSessions(
            session,
            deleteExpired: false,
          );

          expect(
            await AuthSession.db.count(session),
            1,
          );
        },
      );
    },
  );

  withServerpod(
    'Given an auth session expiring after 10 minutes of inactivity,',
    (final sessionBuilder, final endpoints) {
      const expireAfterUnusedFor = Duration(minutes: 10);
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = (await authSessions.authUsers.create(session)).id;

        // ignore: unused_result
        await authSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expireAfterUnusedFor: expireAfterUnusedFor,
          method: 'test',
        );
      });

      test('when calling `deleteExpiredSessions`, then it is kept.', () async {
        await AuthSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await AuthSession.db.count(session),
          1,
        );
      });
    },
  );

  withServerpod(
    'Given an auth session which expired due to more than 10 minutes of inactivity,',
    (final sessionBuilder, final endpoints) {
      const expireAfterUnusedFor = Duration(minutes: 10);
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = (await authSessions.authUsers.create(session)).id;

        await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            return authSessions.createSession(
              session,
              authUserId: authUserId,
              scopes: {},
              expireAfterUnusedFor: expireAfterUnusedFor,
              method: 'test',
            );
          },
        );
      });

      test(
        'when calling `deleteExpiredSessions`, then it is deleted.',
        () async {
          await AuthSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await AuthSession.db.count(session),
            0,
          );
        },
      );

      test(
        'when calling `deleteExpiredSessions` with `deleteInactive: false`, then it is kept.',
        () async {
          await AuthSessionsAdmin().deleteExpiredSessions(
            session,
            deleteInactive: false,
          );

          expect(
            await AuthSession.db.count(session),
            1,
          );
        },
      );
    },
  );
}
