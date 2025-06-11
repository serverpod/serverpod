import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
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

      test(
          'when calling `deleteExpiredSessions` after the expiration, then it is deleted.',
          () async {
        await withClock(
          Clock.fixed(expiresAt.add(const Duration(minutes: 1))),
          () async {
            await AuthSessionsAdmin().deleteExpiredSessions(session);
          },
        );

        expect(
          await AuthSession.db.count(session),
          0,
        );
      });

      test(
          'when calling `deleteExpiredSessions` after the expiration with `deleteExpired: false`, then it is kept.',
          () async {
        await withClock(
          Clock.fixed(expiresAt.add(const Duration(minutes: 1))),
          () async {
            await AuthSessionsAdmin().deleteExpiredSessions(
              session,
              deleteExpired: false,
            );
          },
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

      test('when calling `deleteExpiredSessions` right away, then it is kept.',
          () async {
        await AuthSessionsAdmin().deleteExpiredSessions(session);

        expect(
          await AuthSession.db.count(session),
          1,
        );
      });

      test(
          'when calling `deleteExpiredSessions` after the expiration, then it is deleted.',
          () async {
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            await AuthSessionsAdmin().deleteExpiredSessions(session);
          },
        );

        expect(
          await AuthSession.db.count(session),
          0,
        );
      });

      test(
          'when calling `deleteExpiredSessions` after the expiration with `deleteInactive: false`, then it is kept.',
          () async {
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            await AuthSessionsAdmin().deleteExpiredSessions(
              session,
              deleteInactive: false,
            );
          },
        );

        expect(
          await AuthSession.db.count(session),
          1,
        );
      });
    },
  );
}
