import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

void _noopSender(
  final Session session, {
  required final String email,
  required final UuidValue loginRequestId,
  required final String verificationCode,
  required final Transaction? transaction,
}) {}

const _passwordless = EmailPasswordlessLoginConfig(
  sendSignUpVerificationCode: _noopSender,
  sendSignInVerificationCode: _noopSender,
);

String _customCodeGenerator() => 'custom';

void main() {
  group('Given an EmailIdpConfig with only the secret hash pepper', () {
    const config = EmailIdpConfig(secretHashPepper: 'pepper');

    test('then the password login is enabled with the defaults.', () {
      expect(config.password, isNotNull);
      expect(
        config.effectivePassword!.registrationVerificationCodeLifetime,
        const Duration(minutes: 15),
      );
    });

    test('then the passwordless login is disabled.', () {
      expect(config.passwordless, isNull);
    });

    test('then it is valid.', () {
      expect(config.validate, returnsNormally);
    });
  });

  group('Given an EmailIdpConfig with deprecated password settings', () {
    const config = EmailIdpConfig(
      secretHashPepper: 'pepper',
      password: EmailPasswordLoginConfig(
        registrationVerificationCodeAllowedAttempts: 7,
        passwordResetVerificationCodeAllowedAttempts: 8,
      ),
      // ignore: deprecated_member_use_from_same_package
      registrationVerificationCodeAllowedAttempts: 5,
      // ignore: deprecated_member_use_from_same_package
      registrationVerificationCodeGenerator: _customCodeGenerator,
    );

    test(
      'when reading the effective password config then the deprecated settings override the password config.',
      () {
        final password = config.effectivePassword!;

        expect(password.registrationVerificationCodeAllowedAttempts, 5);
        expect(
          password.registrationVerificationCodeGenerator,
          same(_customCodeGenerator),
        );
      },
    );

    test(
      'when reading the effective password config then the other settings of the password config are kept.',
      () {
        expect(
          config
              .effectivePassword!
              .passwordResetVerificationCodeAllowedAttempts,
          8,
        );
      },
    );
  });

  test(
    'Given an EmailIdpConfig with neither login enabled when validating then it throws an ArgumentError.',
    () {
      const config = EmailIdpConfig(secretHashPepper: 'pepper', password: null);

      expect(config.validate, throwsArgumentError);
    },
  );

  test(
    'Given an EmailIdpConfig with only the passwordless login enabled when validating then it is valid.',
    () {
      const config = EmailIdpConfig(
        secretHashPepper: 'pepper',
        password: null,
        passwordless: _passwordless,
      );

      expect(config.validate, returnsNormally);
      expect(config.effectivePassword, isNull);
    },
  );

  test(
    'Given an EmailIdpConfig with deprecated password settings and the password login disabled when validating then it throws an ArgumentError.',
    () {
      const config = EmailIdpConfig(
        secretHashPepper: 'pepper',
        password: null,
        passwordless: _passwordless,
        // ignore: deprecated_member_use_from_same_package
        registrationVerificationCodeAllowedAttempts: 5,
      );

      expect(config.validate, throwsArgumentError);
    },
  );

  test(
    'Given an EmailIdpConfig with a salt length below 8 when validating then it throws an ArgumentError.',
    () {
      const config = EmailIdpConfig(
        secretHashPepper: 'pepper',
        secretHashSaltLength: 7,
      );

      expect(config.validate, throwsArgumentError);
    },
  );
}
