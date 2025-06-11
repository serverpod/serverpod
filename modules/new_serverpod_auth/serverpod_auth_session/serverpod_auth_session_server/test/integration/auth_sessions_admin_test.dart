import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an auth session,',
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

  withServerpod(
    'Given an auth session expiring in 1 day,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().add(const Duration(days: 1));
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = await createAuthUser(session);

        // ignore: unused_result
        await AuthSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
          method: 'test',
        );
      });

      test('when calling `deleteExpiredSessions` right away, then it is kept.',
          () async {
        await AuthSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await AuthSession.db.count(session),
          1,
        );
      });
    },
  );

  withServerpod(
    'Given an expired auth session,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().subtract(const Duration(days: 1));
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = await createAuthUser(session);

        // ignore: unused_result
        await AuthSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
          method: 'test',
        );
      });

      test('when calling `deleteExpiredSessions`, then it is deleted.',
          () async {
        await AuthSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await AuthSession.db.count(session),
          0,
        );
      });

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
      });
    },
  );

  withServerpod(
    'Given an auth session expiring after 10 minutes of inactivity,',
    (final sessionBuilder, final endpoints) {
      const expireAfterUnusedFor = Duration(minutes: 10);
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = await createAuthUser(session);

        // ignore: unused_result
        await AuthSessions.createSession(
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

        final authUserId = await createAuthUser(session);

        await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            return AuthSessions.createSession(
              session,
              authUserId: authUserId,
              scopes: {},
              expireAfterUnusedFor: expireAfterUnusedFor,
              method: 'test',
            );
          },
        );
      });

      test('when calling `deleteExpiredSessions`, then it is deleted.',
          () async {
        await AuthSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await AuthSession.db.count(session),
          0,
        );
      });

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
      });
    },
  );
}
