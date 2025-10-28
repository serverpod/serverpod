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
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            passwordHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.createAuthUser(session);

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

      group('when startPasswordReset is called', () {
        late Future<UuidValue> passwordResetRequestIdFuture;
        setUp(() async {
          passwordResetRequestIdFuture = fixture.emailIDP.startPasswordReset(
            session,
            email: email,
          );
        });

        test('then it returns password reset request id', () async {
          await expectLater(
              passwordResetRequestIdFuture, completion(isA<UuidValue>()));
        });

        test(
            'then password reset request can be used to complete password reset',
            () async {
          final passwordResetRequestId = await passwordResetRequestIdFuture;

          final authSuccessFuture = fixture.emailIDP.finishPasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: 'NewPassword123!',
          );

          await expectLater(authSuccessFuture, completion(isA<AuthSuccess>()));
        });
      });
    },
  );

  withServerpod(
    'Given no email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when startPasswordReset is called then it returns dummy uuid without throwing',
          () async {
        final result = fixture.emailIDP.startPasswordReset(
          session,
          email: 'nonexistent@serverpod.dev',
        );

        await expectLater(result, completion(isA<UuidValue>()));
      });
    },
  );
}
