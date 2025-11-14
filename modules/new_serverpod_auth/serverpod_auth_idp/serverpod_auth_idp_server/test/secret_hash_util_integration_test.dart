import 'package:serverpod_auth_idp_server/src/providers/email/business/email_idp_config.dart';
import 'package:serverpod_auth_idp_server/src/utils/secret_hash_util.dart';
import 'package:test/test.dart';

import 'email/test_utils/email_idp_test_fixture.dart';

void main() {
  group('Given fallback pepper integration scenario', () {
    test(
      'when rotating pepper for production deployment then existing users can still authenticate and get rehashed',
      () async {
        // Scenario: Production has been running with 'old-production-pepper' for 2 years
        // Security team requires rotating to 'new-production-pepper'

        const oldPepper = 'old-production-pepper';
        const newPepper = 'new-production-pepper';
        const userPassword = 'user-secure-password-123';

        // Step 1: Create password hash with old pepper (existing user's password)
        final oldFixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: oldPepper),
        );
        final oldUtil = oldFixture.passwordHashUtil;
        final existingPasswordHash = await oldUtil.createHash(
          value: userPassword,
        );

        // Verify old pepper works
        expect(
          await oldUtil.validateHash(
            value: userPassword,
            hash: existingPasswordHash.hash,
            salt: existingPasswordHash.salt,
          ),
          isTrue,
          reason: 'Old password hash should validate with old pepper',
        );

        // Step 2: Deploy new configuration with new primary pepper and old fallback pepper
        final newFixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: newPepper,
            fallbackSecretHashPepper: oldPepper,
          ),
        );
        final newUtil = newFixture.passwordHashUtil;

        // Step 3: User logs in - password validates using fallback and gets rehashed
        HashResult? rehashedPassword;
        final validationSucceeded = await newUtil.validateHash(
          value: userPassword,
          hash: existingPasswordHash.hash,
          salt: existingPasswordHash.salt,
          onFallbackValidated: (final newHash) async {
            // This would be stored in the database in production
            rehashedPassword = newHash;
          },
        );

        expect(validationSucceeded, isTrue, reason: 'User should be able to log in');
        expect(rehashedPassword, isNotNull, reason: 'Password should be rehashed');

        // Step 4: Verify the new hash uses the new pepper
        final utilWithNewPepperOnly = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: newPepper),
        ).passwordHashUtil;

        final newHashValidatesWithNewPepper = await utilWithNewPepperOnly.validateHash(
          value: userPassword,
          hash: rehashedPassword!.hash,
          salt: rehashedPassword!.salt,
        );

        expect(
          newHashValidatesWithNewPepper,
          isTrue,
          reason: 'Rehashed password should validate with new pepper only',
        );

        // Step 5: Old hash no longer validates with new pepper only
        final oldHashValidatesWithNewPepper = await utilWithNewPepperOnly.validateHash(
          value: userPassword,
          hash: existingPasswordHash.hash,
          salt: existingPasswordHash.salt,
        );

        expect(
          oldHashValidatesWithNewPepper,
          isFalse,
          reason: 'Old password hash should not validate with new pepper only',
        );

        // Step 6: After all users have logged in and been rehashed, fallback can be removed
        // This is the final state - no fallback pepper configured
        // All users now have passwords hashed with the new pepper
      },
    );

    test(
      'when new user registers during pepper rotation then uses new primary pepper',
      () async {
        const oldPepper = 'old-production-pepper';
        const newPepper = 'new-production-pepper';
        const newUserPassword = 'new-user-password-456';

        // Configuration during rotation
        final fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: newPepper,
            fallbackSecretHashPepper: oldPepper,
          ),
        );
        final util = fixture.passwordHashUtil;

        // New user registers
        final newPasswordHash = await util.createHash(value: newUserPassword);

        // Verify it uses the new pepper (validates without fallback)
        final utilWithNewPepperOnly = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: newPepper),
        ).passwordHashUtil;

        final validatesWithNewPepper = await utilWithNewPepperOnly.validateHash(
          value: newUserPassword,
          hash: newPasswordHash.hash,
          salt: newPasswordHash.salt,
        );

        expect(
          validatesWithNewPepper,
          isTrue,
          reason: 'New user password should use new pepper',
        );

        // Verify it doesn't use the old pepper
        final utilWithOldPepperOnly = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: oldPepper),
        ).passwordHashUtil;

        final validatesWithOldPepper = await utilWithOldPepperOnly.validateHash(
          value: newUserPassword,
          hash: newPasswordHash.hash,
          salt: newPasswordHash.salt,
        );

        expect(
          validatesWithOldPepper,
          isFalse,
          reason: 'New user password should not validate with old pepper',
        );
      },
    );
  });
}
