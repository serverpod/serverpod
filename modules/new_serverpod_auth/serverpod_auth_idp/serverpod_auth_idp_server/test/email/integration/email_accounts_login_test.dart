import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../../test_tags.dart';
import '../test_utils.dart';

void main() {
  withServerpod(
    'Given a registered email account,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      const password = 'asdf1234';
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        await createVerifiedEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
        );
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when authenticating with the original credentials, then it succeeds.',
          () async {
        final loggedInUser = await EmailAccounts.authenticate(
          session,
          email: email,
          password: password,
        );

        expect(loggedInUser, authUserId);
      });

      test(
          'when authenticating with the lower-case email variant of the credentials, then it succeeds.',
          () async {
        final loggedInUser = await EmailAccounts.authenticate(
          session,
          email: email.toLowerCase(),
          password: password,
        );

        expect(loggedInUser, authUserId);
      });

      test(
          'when trying to authenticate with an invalid password, then it throws a `EmailAccountLoginException` initially with `invalidCredentials` and then blocks further attempts with `tooManyAttempts`.',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          failedLoginRateLimit: (
            maxAttempts: 1,
            timeframe: const Duration(hours: 1),
          ),
        );

        await expectLater(
          () => EmailAccounts.authenticate(
            session,
            email: email,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.invalidCredentials,
          )),
        );

        await expectLater(
          () => EmailAccounts.authenticate(
            session,
            email: email,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.tooManyAttempts,
          )),
        );
      });

      test(
          'when attempting to log into a non-existent account, then it throws a `EmailAccountLoginException` initially with `invalidCredentials` and then blocks further attempts with `tooManyAttempts`.',
          () async {
        const unknownEmail = '404@serverpod.dev';

        EmailAccounts.config = EmailAccountConfig(
          failedLoginRateLimit: (
            maxAttempts: 1,
            timeframe: const Duration(hours: 1),
          ),
        );

        await expectLater(
          () => EmailAccounts.authenticate(
            session,
            email: unknownEmail,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.invalidCredentials,
          )),
        );

        await expectLater(
          () => EmailAccounts.authenticate(
            session,
            email: unknownEmail,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.tooManyAttempts,
          )),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );
}
