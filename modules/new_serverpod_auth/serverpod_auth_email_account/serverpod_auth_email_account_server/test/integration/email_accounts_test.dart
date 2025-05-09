import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `EmailAccounts` utility,',
    (final sessionBuilder, final endpoints) {
      group('when creating a new email authentication,', () {
        final session = sessionBuilder.build();
        const email = 'INTEGRATION_TEST_1@serverpod.DEV';
        const password = 'admin';

        String? sentVerificationToken;
        String? sentPasswordResetToken;
        EmailAccountConfig.current = EmailAccountConfig(
          sendRegistrationVerificationMail: ({
            required final email,
            required final verificationToken,
          }) {
            sentVerificationToken = verificationToken;
          },
          sendPasswordResetMail: ({
            required final email,
            required final resetToken,
          }) {
            sentPasswordResetToken = resetToken;
          },
        );

        UuidValue? accountRequestId;
        test('then a verification code is sent out via the callback.',
            () async {
          accountRequestId = await EmailAccounts.requestAccount(
            session,
            email: email,
            password: password,
          );

          expect(sentVerificationToken, isNotNull);
          expect(accountRequestId, isNotNull);
        });

        test('then the pending account can be verified with the mail token.',
            () async {
          final verificationResult = await EmailAccounts.verifyAccountRequest(
            session,
            verificationCode: sentVerificationToken!,
          );

          expect(verificationResult, isNotNull);
          expect(verificationResult?.emailAccountRequestId, accountRequestId);
          expect(verificationResult?.email, email.toLowerCase());
        });

        test(
            'then the same email can not be used for a second account request while the other one is pending.',
            () async {
          await expectLater(
            () => EmailAccounts.requestAccount(
              session,
              email: email,
              password: password,
            ),
            throwsA(
              isA<Exception>().having(
                (final e) => e.toString(),
                'message',
                contains('duplicate key value violates unique'),
              ),
            ),
          );
        });

        test(
            'then a lower-case variant of the same email can not be used for a second account request while the other one is pending.',
            () async {
          await expectLater(
            () => EmailAccounts.requestAccount(
              session,
              email: email.toLowerCase(),
              password: password,
            ),
            throwsA(
              isA<Exception>().having(
                (final e) => e.toString(),
                'message',
                contains('duplicate key value violates unique'),
              ),
            ),
          );
        });

        UuidValue? authUserId;
        test('then the request can be converted into an account.', () async {
          authUserId = (await AuthUser.db.insertRow(
            session,
            AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
          ))
              .id;

          final result = await EmailAccounts.createAccount(
            session,
            verificationCode: sentVerificationToken!,
            authUserId: authUserId!,
          );

          expect(result.email, email.toLowerCase());
        });

        test('then the user can log in with their new credentials.', () async {
          final loggedInUser = await EmailAccounts.login(
            session,
            email: email,
            password: password,
          );

          expect(loggedInUser, authUserId!);
        });

        test(
            'then the user can log in with their new credentials in a different case.',
            () async {
          final loggedInUser = await EmailAccounts.login(
            session,
            email: email.toUpperCase(),
            password: password,
          );

          expect(loggedInUser, authUserId!);
        });

        test('then no further user can be registered with the same email.',
            () async {
          await expectLater(
            () => EmailAccounts.requestAccount(
              session,
              email: email.toUpperCase(),
              password: password,
            ),
            throwsA(
              isA<Exception>().having(
                (final e) => e.toString(),
                'message',
                contains('Email already registered'),
              ),
            ),
          );
        });

        test('then a password reset can be requests for the account.',
            () async {
          await EmailAccounts.requestPasswordReset(
            session,
            email: email.toUpperCase(),
          );

          expect(sentPasswordResetToken, isNotNull);
        });

        const newPassword = 'newpw123';
        test('then the password can be changed with the received token.',
            () async {
          final userId = await EmailAccounts.completePasswordReset(
            session,
            resetCode: sentPasswordResetToken!,
            newPassword: newPassword,
          );

          expect(userId, authUserId);
        });

        test(
            'then the password can not be changed a second time with the received token.',
            () async {
          await expectLater(
            () => EmailAccounts.completePasswordReset(
              session,
              resetCode: sentPasswordResetToken!,
              newPassword: 'xxxxxxx',
            ),
            throwsA(isA<Exception>()),
          );
        });

        test('then the user can log in with the new credentials.', () async {
          final userId = await EmailAccounts.login(
            session,
            email: email.toUpperCase(),
            password: newPassword,
          );

          expect(userId, authUserId!);
        });

        test('then the user can not log in with the old credentials.',
            () async {
          await expectLater(
            () => EmailAccounts.login(
              session,
              email: email,
              password: password,
            ),
            throwsA(isA<Exception>()),
          );
        });

        test('then requesting a reset for a non-existing email errs.',
            () async {
          await expectLater(
            () => EmailAccounts.requestPasswordReset(
              session,
              email: '404@serverpod.dev',
            ),
            throwsA(isA<Exception>()),
          );
        });
      });
    },
    rollbackDatabase: RollbackDatabase.afterAll,
  );
}
