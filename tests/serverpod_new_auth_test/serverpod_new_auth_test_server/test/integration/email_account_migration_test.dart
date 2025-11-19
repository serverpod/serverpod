import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import '../util/test_tags.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerFactory = AuthSessionsTokenManagerFactory(
    AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  tearDown(() {
    AuthServices.set(
      primaryTokenManager: tokenManagerFactory,
      identityProviders: [],
    );
  });

  withServerpod(
    'Given a non-migrated user (legacy user),',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const legacyPassword = 'LegacyPass123!';

      late int legacyUserId;
      String? receivedVerificationCode;

      setUp(() async {
        // Initialize receivedVerificationCode to null
        receivedVerificationCode = null;

        // Create a legacy user (non-migrated)
        legacyUserId = await endpoints.emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            );

        // Verify the user is NOT migrated
        expect(
          await endpoints.emailAccountBackwardsCompatibilityTest
              .getNewAuthUserId(
                sessionBuilder,
                userId: legacyUserId,
              ),
          isNull,
        );

        // Configure EmailAccounts for password reset verification
        final config = EmailIDPConfig(
          secretHashPepper: 'test',
          sendPasswordResetVerificationCode:
              (
                final session, {
                required final email,
                required final passwordResetRequestId,
                required final transaction,
                required final verificationCode,
              }) {
                receivedVerificationCode = verificationCode;
              },
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when starting password reset, then no verification code is sent because user does not exist in new system.',
        () async {
          // The new system should not find the user since they're not migrated
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          // No verification code should be sent because the user doesn't exist in the new system
          expect(receivedVerificationCode, isNull);
        },
      );

      test(
        'when migrating user and then starting password reset, then verification code is sent.',
        () async {
          // First migrate the user
          await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
            sessionBuilder,
            legacyUserId: legacyUserId,
          );

          // Verify the user is now migrated
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .getNewAuthUserId(
                  sessionBuilder,
                  userId: legacyUserId,
                ),
            isNotNull,
          );

          // Now the password reset should work
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          expect(receivedVerificationCode, isNotNull);
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given a migrated user whose first action is password reset (after migration),',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const legacyPassword = 'LegacyPass123!';
      const newPassword = 'NewPassword456!';

      late int legacyUserId;
      late UuidValue newAuthUserId;
      String? receivedVerificationCode;
      UuidValue? receivedPasswordResetRequestId;

      setUp(() async {
        // Initialize variables to null
        receivedVerificationCode = null;
        receivedPasswordResetRequestId = null;

        // Create a legacy user
        legacyUserId = await endpoints.emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            );

        // Migrate the user without setting a password (simulating migration without login)
        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: legacyUserId,
        );

        // Get the new auth user ID
        final newAuthUserIdResult = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .getNewAuthUserId(
              sessionBuilder,
              userId: legacyUserId,
            );
        newAuthUserId = newAuthUserIdResult!;

        // Configure EmailAccounts for password reset verification
        final config = EmailIDPConfig(
          secretHashPepper: 'test',
          sendPasswordResetVerificationCode:
              (
                final session, {
                required final email,
                required final passwordResetRequestId,
                required final transaction,
                required final verificationCode,
              }) {
                receivedPasswordResetRequestId = passwordResetRequestId;
                receivedVerificationCode = verificationCode;
              },
          onPasswordResetCompleted:
              AuthBackwardsCompatibility.clearLegacyPassword,
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when completing password reset, then it succeeds.',
        () async {
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          final finishPasswordResetToken = await endpoints.emailAccount
              .verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: receivedPasswordResetRequestId!,
                verificationCode: receivedVerificationCode!,
              );

          final passwordReset = endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: newPassword,
          );

          await expectLater(passwordReset, completes);
        },
      );

      test(
        'when logging in with the new password after reset, then it succeeds.',
        () async {
          // First complete the password reset
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          final finishPasswordResetToken = await endpoints.emailAccount
              .verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: receivedPasswordResetRequestId!,
                verificationCode: receivedVerificationCode!,
              );

          await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: newPassword,
          );

          // Now test login with the new password
          final authSuccess = await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          final authInfo = await AuthServices.instance.tokenManager
              .validateToken(
                sessionBuilder.build(),
                authSuccess.token,
              );

          expect(authInfo, isNotNull);
          expect(authInfo!.authUserId, newAuthUserId);
        },
      );

      test(
        'when completing password reset, then legacy password is cleared for security.',
        () async {
          // Verify legacy password still exists before reset
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
                  sessionBuilder,
                  email: email,
                  password: legacyPassword,
                ),
            isTrue,
          );

          // Complete password reset
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          final finishPasswordResetToken = await endpoints.emailAccount
              .verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: receivedPasswordResetRequestId!,
                verificationCode: receivedVerificationCode!,
              );

          await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: newPassword,
          );

          // Verify legacy password is cleared after reset (for security)
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
                  sessionBuilder,
                  email: email,
                  password: legacyPassword,
                ),
            isFalse,
          );
        },
      );

      test(
        'when legacy password is cleared, then it remains cleared after subsequent login operations.',
        () async {
          // First, complete password reset to clear legacy password
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          final finishPasswordResetToken = await endpoints.emailAccount
              .verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: receivedPasswordResetRequestId!,
                verificationCode: receivedVerificationCode!,
              );

          await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: newPassword,
          );

          // Verify legacy password is cleared
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
                  sessionBuilder,
                  email: email,
                  password: legacyPassword,
                ),
            isFalse,
          );

          // Login with the new password using regular endpoint
          await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          // Verify legacy password remains cleared after regular login
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
                  sessionBuilder,
                  email: email,
                  password: legacyPassword,
                ),
            isFalse,
          );

          // Login using the password importing endpoint
          await endpoints.passwordImportingEmailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          // Verify legacy password remains cleared after password importing login
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
                  sessionBuilder,
                  email: email,
                  password: legacyPassword,
                ),
            isFalse,
          );
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

Future<void> _cleanUpDatabase(final Session session) async {
  await AuthUser.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountPasswordResetCompleteAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountFailedLoginAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );
}
