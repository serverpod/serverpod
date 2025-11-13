import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when start registration is called for the same email address', () {
        late Future<UuidValue> accountRequestIdFuture;

        setUp(() async {
          accountRequestIdFuture = fixture.emailIDP.startRegistration(
            session,
            email: email,
          );
        });

        test(
          'then it returns dummy uuid with the same version as the real request to prevent leaking the fact that the email is not registered',
          () async {
            const nonRegisteredEmail = 'non-registered-$email';
            final capturedAccountRequestId = await fixture.emailIDP
                .startRegistration(
                  session,
                  email: nonRegisteredEmail,
                );

            await expectLater(
              accountRequestIdFuture,
              completion(
                isA<UuidValue>().having(
                  (final uuid) => uuid.version,
                  'version',
                  equals(capturedAccountRequestId.version),
                ),
              ),
            );
          },
        );
      });

      group(
        'when start registration is called for the same email address in uppercase',
        () {
          late Future<UuidValue> accountRequestIdFuture;

          setUp(() async {
            accountRequestIdFuture = fixture.emailIDP.startRegistration(
              session,
              email: email.toUpperCase(),
            );
          });

          test(
            'then it returns dummy uuid with the same version as the real request to prevent leaking the fact that the email is not registered',
            () async {
              const nonRegisteredEmail = 'non-registered-$email';
              final capturedAccountRequestId = await fixture.emailIDP
                  .startRegistration(
                    session,
                    email: nonRegisteredEmail,
                  );

              await expectLater(
                accountRequestIdFuture,
                completion(
                  isA<UuidValue>().having(
                    (final uuid) => uuid.version,
                    'version',
                    equals(capturedAccountRequestId.version),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given no email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'newuser@serverpod.dev';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when startRegistration is called', () {
        late Future<UuidValue> accountRequestIdFuture;
        setUp(() async {
          accountRequestIdFuture = fixture.emailIDP.startRegistration(
            session,
            email: email,
          );
        });

        test('then it returns account registration request id', () async {
          await expectLater(
            accountRequestIdFuture,
            completion(isA<UuidValue>()),
          );
        });
      });
    },
  );
}
