import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final serverSideSessions = ServerSideSessions(
    config: ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod('Given an auth session,', (
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
      'when calling `deleteSessions`, then it is deleted and tuple returned.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(session);

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, serverSideSessionId);
        expect(await ServerSideSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for the user, then it is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          authUserId: authUserId,
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, serverSideSessionId);
        expect(await ServerSideSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for another user, then nothing is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(deleted, isEmpty);
        expect(await ServerSideSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for its `method`, then it is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          method: 'test',
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, serverSideSessionId);
        expect(await ServerSideSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` for another `method`, then nothing is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          method: 'something else',
        );

        expect(deleted, isEmpty);
        expect(await ServerSideSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for the session id, then it is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          serverSideSessionId: serverSideSessionId,
        );

        expect(deleted, hasLength(1));
        expect(deleted.single.authUserId, authUserId);
        expect(deleted.single.sessionId, serverSideSessionId);
        expect(await ServerSideSession.db.count(session), 0);
      },
    );

    test(
      'when calling `deleteSessions` with another session id, then nothing is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          serverSideSessionId: const Uuid().v4obj(),
        );

        expect(deleted, isEmpty);
        expect(await ServerSideSession.db.count(session), 1);
      },
    );

    test(
      'when calling `deleteSessions` for the user with another `method`, then nothing is deleted.',
      () async {
        final deleted = await ServerSideSessionsAdmin().deleteSessions(
          session,
          authUserId: authUserId,
          method: 'some other method',
        );

        expect(deleted, isEmpty);
        expect(await ServerSideSession.db.count(session), 1);
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

        final authUserId = (await serverSideSessions.authUsers.create(
          session,
        )).id;

        // ignore: unused_result
        await serverSideSessions.createSession(
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
          await ServerSideSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await ServerSideSession.db.count(session),
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

        final authUserId = (await serverSideSessions.authUsers.create(
          session,
        )).id;

        // ignore: unused_result
        await serverSideSessions.createSession(
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
          await ServerSideSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await ServerSideSession.db.count(session),
            0,
          );
        },
      );

      test(
        'when calling `deleteExpiredSessions` with `deleteExpired: false`, then it is kept.',
        () async {
          await ServerSideSessionsAdmin().deleteExpiredSessions(
            session,
            deleteExpired: false,
          );

          expect(
            await ServerSideSession.db.count(session),
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

        final authUserId = (await serverSideSessions.authUsers.create(
          session,
        )).id;

        // ignore: unused_result
        await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expireAfterUnusedFor: expireAfterUnusedFor,
          method: 'test',
        );
      });

      test('when calling `deleteExpiredSessions`, then it is kept.', () async {
        await ServerSideSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await ServerSideSession.db.count(session),
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

        final authUserId = (await serverSideSessions.authUsers.create(
          session,
        )).id;

        await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            return serverSideSessions.createSession(
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
          await ServerSideSessionsAdmin().deleteExpiredSessions(session);

          expect(
            await ServerSideSession.db.count(session),
            0,
          );
        },
      );

      test(
        'when calling `deleteExpiredSessions` with `deleteInactive: false`, then it is kept.',
        () async {
          await ServerSideSessionsAdmin().deleteExpiredSessions(
            session,
            deleteInactive: false,
          );

          expect(
            await ServerSideSession.db.count(session),
            1,
          );
        },
      );
    },
  );
}
