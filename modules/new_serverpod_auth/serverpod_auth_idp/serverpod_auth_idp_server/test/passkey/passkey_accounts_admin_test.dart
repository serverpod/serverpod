import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a pending challenge,',
    (final sessionBuilder, final _) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        PasskeyAccounts.config = PasskeyAccountConfig(
          hostname: 'localhost',
        );

        await PasskeyAccounts.createChallenge(session);
      });

      test(
          'when calling `PasskeyAccounts.admin.deleteExpiredChallenges` immediately, then the challenge is kept.',
          () async {
        await PasskeyAccounts.admin.deleteExpiredChallenges(session);

        expect(
          await PasskeyChallenge.db.find(session),
          hasLength(1),
        );
      });

      test(
          'when calling `PasskeyAccounts.admin.deleteExpiredChallenges` after the expiration time, then the challenge is removed.',
          () async {
        await withClock(
          Clock.fixed(
            DateTime.now().add(PasskeyAccounts.config.challengeLifetime),
          ),
          () => PasskeyAccounts.admin.deleteExpiredChallenges(session),
        );

        expect(
          await PasskeyChallenge.db.find(session),
          isEmpty,
        );
      });
    },
  );
}
