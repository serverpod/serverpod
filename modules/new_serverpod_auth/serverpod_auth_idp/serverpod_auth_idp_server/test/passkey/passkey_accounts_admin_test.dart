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

        PasskeyIDP.config = PasskeyIDPConfig(
          hostname: 'localhost',
        );

        await PasskeyIDP.createChallenge(session);
      });

      test(
          'when calling `PasskeyAccounts.admin.deleteExpiredChallenges` immediately, then the challenge is kept.',
          () async {
        await PasskeyIDP.admin.deleteExpiredChallenges(session);

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
            DateTime.now().add(PasskeyIDP.config.challengeLifetime),
          ),
          () => PasskeyIDP.admin.deleteExpiredChallenges(session),
        );

        expect(
          await PasskeyChallenge.db.find(session),
          isEmpty,
        );
      });
    },
  );
}
