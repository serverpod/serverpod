import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:serverpod_auth_api_tokens_server/src/generated/api_token.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session expiring in 1 day,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().add(const Duration(days: 1));
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = await createAuthUser(session);

        await ApiTokens.createApiToken(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
        );
      });

      test('when calling `deleteExpiredTokens` right away, then it is kept.',
          () async {
        await ApiTokensAdmin().deleteExpiredTokens(session);

        expect(
          await ApiToken.db.count(session),
          1,
        );
      });

      test(
          'when calling `deleteExpiredTokens` after the expiration, then it is deleted.',
          () async {
        await withClock(
          Clock.fixed(expiresAt.add(const Duration(minutes: 1))),
          () async {
            await ApiTokensAdmin().deleteExpiredTokens(session);
          },
        );

        expect(
          await ApiToken.db.count(session),
          0,
        );
      });

      test(
          'when calling `deleteExpiredTokens` after the expiration with `deleteExpired: false`, then it is kept.',
          () async {
        await withClock(
          Clock.fixed(expiresAt.add(const Duration(minutes: 1))),
          () async {
            await ApiTokensAdmin().deleteExpiredTokens(
              session,
              deleteExpired: false,
            );
          },
        );

        expect(
          await ApiToken.db.count(session),
          1,
        );
      });
    },
  );
  withServerpod(
    'Given a session expiring after 10 minutes of inactivity,',
    (final sessionBuilder, final endpoints) {
      const expireAfterUnusedFor = Duration(minutes: 10);
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUserId = await createAuthUser(session);

        await ApiTokens.createApiToken(
          session,
          authUserId: authUserId,
          scopes: {},
          expireAfterUnusedFor: expireAfterUnusedFor,
        );
      });

      test('when calling `deleteExpiredTokens` right away, then it is kept.',
          () async {
        await ApiTokensAdmin().deleteExpiredTokens(session);

        expect(
          await ApiToken.db.count(session),
          1,
        );
      });

      test(
          'when calling `deleteExpiredTokens` after the expiration, then it is deleted.',
          () async {
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            await ApiTokensAdmin().deleteExpiredTokens(session);
          },
        );

        expect(
          await ApiToken.db.count(session),
          0,
        );
      });

      test(
          'when calling `deleteExpiredTokens` after the expiration with `deleteInactive: false`, then it is kept.',
          () async {
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () async {
            await ApiTokensAdmin().deleteExpiredTokens(
              session,
              deleteInactive: false,
            );
          },
        );

        expect(
          await ApiToken.db.count(session),
          1,
        );
      });
    },
  );
}
