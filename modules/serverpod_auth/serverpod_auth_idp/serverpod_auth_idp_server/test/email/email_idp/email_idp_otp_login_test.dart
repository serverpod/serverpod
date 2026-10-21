import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  const email = 'otp@serverpod.dev';
  const allowedPassword = 'AllowedPassword123!';

  withServerpod(
    'Given default email idp configuration',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late List<String> sentCodes;

      setUp(() {
        session = sessionBuilder.build();
        sentCodes = [];
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode:
                (
                  final session, {
                  required final email,
                  required final otpLoginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => sentCodes.add(verificationCode),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startOtpLogin is called then a 6 digit numeric code is sent',
        () async {
          await fixture.emailIdp.startOtpLogin(session, email: email);

          expect(sentCodes, hasLength(1));
          expect(sentCodes.single, matches(RegExp(r'^[0-9]{6}$')));
        },
      );

      test(
        'when startOtpLogin is called with an invalid email then it throws EmailAccountRequestException with reason "policyViolation"',
        () async {
          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: 'not-an-email'),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );

      test(
        'when startOtpLogin is called more often than allowed then it throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final maxAttempts = fixture.config.maxOtpLoginAttempts.maxAttempts;
          for (var i = 0; i < maxAttempts; i++) {
            await fixture.emailIdp.startOtpLogin(session, email: email);
          }

          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: email),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );

      test(
        'when startOtpLogin is called twice then only the latest code can be verified',
        () async {
          final firstRequestId = await fixture.emailIdp.startOtpLogin(
            session,
            email: email,
          );
          final secondRequestId = await fixture.emailIdp.startOtpLogin(
            session,
            email: email,
          );

          await expectLater(
            fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: firstRequestId,
              verificationCode: sentCodes.first,
            ),
            throwsA(isA<EmailAccountRequestException>()),
          );

          await expectLater(
            fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: secondRequestId,
              verificationCode: sentCodes.last,
            ),
            completion(isA<EmailAccountOtpVerificationResult>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an otp login code generator for 8 digit codes',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late List<String> sentCodes;

      setUp(() {
        session = sessionBuilder.build();
        sentCodes = [];
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            otpLoginVerificationCodeGenerator: () =>
                defaultVerificationCodeGenerator(length: 8),
            sendOtpLoginVerificationCode:
                (
                  final session, {
                  required final email,
                  required final otpLoginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => sentCodes.add(verificationCode),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startOtpLogin is called then an 8 digit numeric code is sent',
        () async {
          await fixture.emailIdp.startOtpLogin(session, email: email);

          expect(sentCodes.single, matches(RegExp(r'^[0-9]{8}$')));
        },
      );
    },
  );

  withServerpod(
    'Given an existing email account and a started otp login',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late UuidValue authUserId;
      late UuidValue otpLoginRequestId;
      const verificationCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            otpLoginVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(allowedPassword),
        );

        otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyOtpLoginCode is called with the correct code then it reports that the account exists',
        () async {
          final result = await fixture.emailIdp.verifyOtpLoginCode(
            session,
            otpLoginRequestId: otpLoginRequestId,
            verificationCode: verificationCode,
          );

          expect(result.accountExists, isTrue);
        },
      );

      test(
        'when the user signs in with one-time passwords more often than maxOtpLoginAttempts allows then new codes can still be requested',
        () async {
          final maxAttempts = fixture.config.maxOtpLoginAttempts.maxAttempts;
          var requestId = otpLoginRequestId;
          for (var i = 0; i <= maxAttempts; i++) {
            final result = await fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: requestId,
              verificationCode: verificationCode,
            );
            await fixture.emailIdp.finishOtpLogin(
              session,
              otpLoginToken: result.token,
            );
            requestId = await fixture.emailIdp.startOtpLogin(
              session,
              email: email,
            );
          }
        },
      );

      test(
        'when the user signs in and then requests more codes than maxOtpLoginAttempts allows then it throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final result = await fixture.emailIdp.verifyOtpLoginCode(
            session,
            otpLoginRequestId: otpLoginRequestId,
            verificationCode: verificationCode,
          );
          await fixture.emailIdp.finishOtpLogin(
            session,
            otpLoginToken: result.token,
          );

          final maxAttempts = fixture.config.maxOtpLoginAttempts.maxAttempts;
          for (var i = 0; i < maxAttempts; i++) {
            await fixture.emailIdp.startOtpLogin(session, email: email);
          }

          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: email),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );

      test(
        'when verifyOtpLoginCode is called with an invalid code then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          await expectLater(
            fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: otpLoginRequestId,
              verificationCode: '654321',
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when verifyOtpLoginCode is called with invalid codes more often than allowed then it throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final allowedAttempts =
              fixture.config.otpLoginVerificationCodeAllowedAttempts;
          for (var i = 0; i < allowedAttempts; i++) {
            await expectLater(
              fixture.emailIdp.verifyOtpLoginCode(
                session,
                otpLoginRequestId: otpLoginRequestId,
                verificationCode: '654321',
              ),
              throwsA(isA<EmailAccountRequestException>()),
            );
          }

          await expectLater(
            fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: otpLoginRequestId,
              verificationCode: verificationCode,
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );

      test(
        'when verifyOtpLoginCode is called after the code expired then it throws EmailAccountRequestException with reason "expired"',
        () async {
          final result = withClock(
            Clock.fixed(
              clock.now().add(
                fixture.config.otpLoginVerificationCodeLifetime +
                    const Duration(seconds: 1),
              ),
            ),
            () => fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: otpLoginRequestId,
              verificationCode: verificationCode,
            ),
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.expired,
              ),
            ),
          );
        },
      );

      group('when the code is verified', () {
        late String otpLoginToken;

        setUp(() async {
          final result = await fixture.emailIdp.verifyOtpLoginCode(
            session,
            otpLoginRequestId: otpLoginRequestId,
            verificationCode: verificationCode,
          );
          otpLoginToken = result.token;
        });

        test(
          'then finishOtpLogin signs in the existing user with a token tagged with the email method',
          () async {
            final authSuccess = await fixture.emailIdp.finishOtpLogin(
              session,
              otpLoginToken: otpLoginToken,
            );

            expect(authSuccess.authUserId, authUserId);

            final tokens = await fixture.tokenManager.listTokens(
              session,
              authUserId: authUserId,
            );
            expect(tokens.map((final t) => t.method), [
              fixture.emailIdp.method,
            ]);
          },
        );

        test(
          'then the code can not be verified again',
          () async {
            await expectLater(
              fixture.emailIdp.verifyOtpLoginCode(
                session,
                otpLoginRequestId: otpLoginRequestId,
                verificationCode: verificationCode,
              ),
              throwsA(isA<EmailAccountRequestException>()),
            );
          },
        );

        test(
          'then finishOtpLogin can not be called twice with the same token',
          () async {
            await fixture.emailIdp.finishOtpLogin(
              session,
              otpLoginToken: otpLoginToken,
            );

            await expectLater(
              fixture.emailIdp.finishOtpLogin(
                session,
                otpLoginToken: otpLoginToken,
              ),
              throwsA(
                isA<EmailAccountRequestException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailAccountRequestExceptionReason.invalid,
                ),
              ),
            );
          },
        );

        test(
          'then finishOtpRegistration throws EmailAccountRequestException with reason "invalid"',
          () async {
            await expectLater(
              fixture.emailIdp.finishOtpRegistration(
                session,
                otpLoginToken: otpLoginToken,
              ),
              throwsA(
                isA<EmailAccountRequestException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailAccountRequestExceptionReason.invalid,
                ),
              ),
            );
          },
        );

        test(
          'then finishOtpLogin with a tampered token throws EmailAccountRequestException with reason "invalid"',
          () async {
            await expectLater(
              fixture.emailIdp.finishOtpLogin(
                session,
                otpLoginToken: '$otpLoginToken-invalid',
              ),
              throwsA(
                isA<EmailAccountRequestException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailAccountRequestExceptionReason.invalid,
                ),
              ),
            );
          },
        );
      });
    },
  );

  withServerpod(
    'Given passwords are allowed on otp registration and a verified otp login without account',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late EmailAccountOtpVerificationResult verificationResult;
      late List<UuidValue> createdAccounts;
      const verificationCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        createdAccounts = [];
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            otpLoginVerificationCodeGenerator: () => verificationCode,
            allowPasswordOnOtpRegistration: true,
            passwordValidationFunction: (final password) =>
                password == allowedPassword,
            onAfterAccountCreated:
                (
                  final session, {
                  required final email,
                  required final authUserId,
                  required final emailAccountId,
                  required final transaction,
                }) => createdAccounts.add(emailAccountId),
          ),
        );

        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        verificationResult = await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('then the result reports that no account exists', () {
        expect(verificationResult.accountExists, isFalse);
      });

      test('then the result reports that a password may be set', () {
        expect(verificationResult.allowPassword, isTrue);
      });

      test(
        'when finishOtpLogin is called then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          await expectLater(
            fixture.emailIdp.finishOtpLogin(
              session,
              otpLoginToken: verificationResult.token,
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      group('when finishOtpRegistration is called without a password', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await fixture.emailIdp.finishOtpRegistration(
            session,
            otpLoginToken: verificationResult.token,
          );
        });

        test('then an email account without password is created', () async {
          final account = await fixture.emailIdp.admin.findAccount(
            session,
            email: email,
          );

          expect(account?.authUserId, authSuccess.authUserId);
          expect(account?.hasPassword, isFalse);
          expect(createdAccounts, [account?.id]);
        });

        test('then a user profile is created', () async {
          final profile = await fixture.userProfiles
              .maybeFindUserProfileByUserId(session, authSuccess.authUserId);

          expect(profile?.email, email);
        });

        test('then the token is tagged with the email method', () async {
          final tokens = await fixture.tokenManager.listTokens(
            session,
            authUserId: authSuccess.authUserId,
          );

          expect(tokens.map((final t) => t.method), [fixture.emailIdp.method]);
        });

        test(
          'then as many new codes as maxOtpLoginAttempts allows can be requested',
          () async {
            final maxAttempts = fixture.config.maxOtpLoginAttempts.maxAttempts;
            for (var i = 0; i < maxAttempts; i++) {
              await fixture.emailIdp.startOtpLogin(session, email: email);
            }
          },
        );

        test('then the token can not be used again', () async {
          await expectLater(
            fixture.emailIdp.finishOtpRegistration(
              session,
              otpLoginToken: verificationResult.token,
            ),
            throwsA(isA<EmailAccountRequestException>()),
          );
        });

        test(
          'then a password login is rejected with "invalidCredentials"',
          () async {
            await expectLater(
              fixture.emailIdp.login(
                session,
                email: email,
                password: '',
              ),
              throwsA(
                isA<EmailAccountLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailAccountLoginExceptionReason.invalidCredentials,
                ),
              ),
            );
          },
        );
      });

      test(
        'when finishOtpRegistration is called with a valid password then the account can log in with it',
        () async {
          await fixture.emailIdp.finishOtpRegistration(
            session,
            otpLoginToken: verificationResult.token,
            password: allowedPassword,
          );

          await expectLater(
            fixture.emailIdp.login(
              session,
              email: email,
              password: allowedPassword,
            ),
            completion(isA<AuthSuccess>()),
          );
        },
      );

      test(
        'when finishOtpRegistration is called with a password violating the policy then it throws EmailAccountRequestException with reason "policyViolation"',
        () async {
          await expectLater(
            fixture.emailIdp.finishOtpRegistration(
              session,
              otpLoginToken: verificationResult.token,
              password: 'short',
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );

      test(
        'when an account is registered for the email before finishOtpRegistration is called then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: email,
          );

          await expectLater(
            fixture.emailIdp.finishOtpRegistration(
              session,
              otpLoginToken: verificationResult.token,
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given the default otp registration config and a verified otp login without account',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late EmailAccountOtpVerificationResult verificationResult;
      const verificationCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            otpLoginVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        verificationResult = await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('then the result reports that no password may be set', () {
        expect(verificationResult.allowPassword, isFalse);
      });

      test(
        'when finishOtpRegistration is called with a password then it throws EmailAccountRequestException with reason "policyViolation"',
        () async {
          await expectLater(
            fixture.emailIdp.finishOtpRegistration(
              session,
              otpLoginToken: verificationResult.token,
              password: allowedPassword,
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );

      test(
        'when finishOtpRegistration is called without a password then it returns auth success',
        () async {
          await expectLater(
            fixture.emailIdp.finishOtpRegistration(
              session,
              otpLoginToken: verificationResult.token,
            ),
            completion(isA<AuthSuccess>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an existing email account with sessions from password and otp logins',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late UuidValue authUserId;
      const verificationCode = '12345678';
      const otpCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            passwordResetVerificationCodeGenerator: () => verificationCode,
            otpLoginVerificationCodeGenerator: () => otpCode,
          ),
        );
        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(allowedPassword),
        );

        await fixture.emailIdp.login(
          session,
          email: email,
          password: allowedPassword,
        );
        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        final verificationResult = await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: otpCode,
        );
        await fixture.emailIdp.finishOtpLogin(
          session,
          otpLoginToken: verificationResult.token,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when the password is reset then all sessions are revoked',
        () async {
          final passwordResetRequestId = await fixture.emailIdp
              .startPasswordReset(session, email: email);
          final finishPasswordResetToken = await fixture.emailIdp
              .verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
              );

          await fixture.emailIdp.finishPasswordReset(
            session,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: allowedPassword,
          );

          final tokens = await fixture.tokenManager.listTokens(
            session,
            authUserId: authUserId,
          );
          expect(tokens, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a started otp login',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: const EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
          ),
        );
        await fixture.emailIdp.startOtpLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteExpiredOtpLoginRequests is called before the request expired then the request is kept',
        () async {
          await fixture.emailIdp.admin.deleteExpiredOtpLoginRequests(session);

          expect(await EmailAccountOtpLoginRequest.db.count(session), 1);
        },
      );

      test(
        'when deleteExpiredOtpLoginRequests is called after the request expired then the request is deleted',
        () async {
          await withClock(
            Clock.fixed(
              clock.now().add(
                fixture.config.otpLoginVerificationCodeLifetime +
                    const Duration(seconds: 1),
              ),
            ),
            () => fixture.emailIdp.admin.deleteExpiredOtpLoginRequests(session),
          );

          expect(await EmailAccountOtpLoginRequest.db.count(session), 0);
        },
      );

      test(
        'when deleteOtpLoginAttempts is called for the email then new codes can be requested beyond the rate limit',
        () async {
          final maxAttempts = fixture.config.maxOtpLoginAttempts.maxAttempts;
          for (var i = 1; i < maxAttempts; i++) {
            await fixture.emailIdp.startOtpLogin(session, email: email);
          }

          await fixture.emailIdp.admin.deleteOtpLoginAttempts(
            session,
            olderThan: Duration.zero,
            email: email,
          );

          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: email),
            completion(isA<UuidValue>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an email idp configured with a registration sender, but no otp sender',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late List<(UuidValue, String)> registrationSends;

      setUp(() {
        session = sessionBuilder.build();
        registrationSends = [];
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendRegistrationVerificationCode:
                (
                  final session, {
                  required final email,
                  required final accountRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => registrationSends.add((
                  accountRequestId,
                  verificationCode,
                )),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startOtpLogin is called then the code is sent with the registration sender for the login request',
        () async {
          final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
            session,
            email: email,
          );

          expect(registrationSends, hasLength(1));
          expect(registrationSends.single.$1, otpLoginRequestId);
        },
      );

      test(
        'when the code sent with the registration sender is verified then the login continues',
        () async {
          final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
            session,
            email: email,
          );

          await expectLater(
            fixture.emailIdp.verifyOtpLoginCode(
              session,
              otpLoginRequestId: otpLoginRequestId,
              verificationCode: registrationSends.single.$2,
            ),
            completion(
              isA<EmailAccountOtpVerificationResult>().having(
                (final r) => r.accountExists,
                'accountExists',
                isFalse,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an email idp configured with both a registration and an otp sender',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late List<String> registrationCodes;
      late List<String> otpCodes;

      setUp(() {
        session = sessionBuilder.build();
        registrationCodes = [];
        otpCodes = [];
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendRegistrationVerificationCode:
                (
                  final session, {
                  required final email,
                  required final accountRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => registrationCodes.add(verificationCode),
            sendOtpLoginVerificationCode:
                (
                  final session, {
                  required final email,
                  required final otpLoginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => otpCodes.add(verificationCode),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startOtpLogin is called then only the otp sender is used',
        () async {
          await fixture.emailIdp.startOtpLogin(session, email: email);

          expect(otpCodes, hasLength(1));
          expect(registrationCodes, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given an email idp configured without registration or otp sender',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;

      setUp(() {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startOtpLogin is called then it throws a StateError naming the missing sender',
        () async {
          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: email),
            throwsA(
              isA<StateError>().having(
                (final e) => e.message,
                'message',
                contains('sendOtpLoginVerificationCode'),
              ),
            ),
          );
        },
      );

      test(
        'when startOtpLogin is called then no login request is stored and no request attempt is counted',
        () async {
          await expectLater(
            fixture.emailIdp.startOtpLogin(session, email: email),
            throwsA(isA<StateError>()),
          );

          expect(await EmailAccountOtpLoginRequest.db.count(session), 0);
          expect(
            await RateLimitedRequestAttempt.db.count(
              session,
              where: (final t) => t.domain.equals('email'),
            ),
            0,
          );
        },
      );
    },
  );

  withServerpod(
    'Given an existing email account and an otp login that was verified but expired before it was finished',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late String otpLoginToken;
      const verificationCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            otpLoginVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(allowedPassword),
        );

        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        otpLoginToken = (await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
        )).token;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when finishOtpLogin is called then it throws EmailAccountRequestException with reason "expired" and the request is deleted',
        () async {
          await withClock(
            Clock.fixed(
              clock.now().add(
                fixture.config.otpLoginVerificationCodeLifetime +
                    const Duration(seconds: 1),
              ),
            ),
            () async {
              await expectLater(
                fixture.emailIdp.finishOtpLogin(
                  session,
                  otpLoginToken: otpLoginToken,
                ),
                throwsA(
                  isA<EmailAccountRequestException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailAccountRequestExceptionReason.expired,
                  ),
                ),
              );
            },
          );

          expect(await EmailAccountOtpLoginRequest.db.count(session), 0);
        },
      );
    },
  );

  withServerpod(
    'Given no email account and an otp login that was verified but expired before it was finished',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late String otpLoginToken;
      const verificationCode = '123456';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode: _ignoreOtpCode,
            otpLoginVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        otpLoginToken = (await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
        )).token;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when finishOtpRegistration is called then it throws EmailAccountRequestException with reason "expired" and no account is created',
        () async {
          await withClock(
            Clock.fixed(
              clock.now().add(
                fixture.config.otpLoginVerificationCodeLifetime +
                    const Duration(seconds: 1),
              ),
            ),
            () async {
              await expectLater(
                fixture.emailIdp.finishOtpRegistration(
                  session,
                  otpLoginToken: otpLoginToken,
                ),
                throwsA(
                  isA<EmailAccountRequestException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailAccountRequestExceptionReason.expired,
                  ),
                ),
              );
            },
          );

          expect(
            await fixture.emailIdp.admin.findAccount(session, email: email),
            isNull,
          );
          expect(await EmailAccountOtpLoginRequest.db.count(session), 0);
        },
      );
    },
  );
}

void _ignoreOtpCode(
  final Session session, {
  required final String email,
  required final UuidValue otpLoginRequestId,
  required final String verificationCode,
  required final Transaction? transaction,
}) {}
