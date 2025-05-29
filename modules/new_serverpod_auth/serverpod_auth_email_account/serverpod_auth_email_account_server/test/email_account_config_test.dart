import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:test/test.dart';

void main() {
  group('Given the default `EmailAccountConfig`,', () {
    final config = EmailAccountConfig();

    test(
        'when a password surrounded by whitespace is validated, then is it not accepted.',
        () {
      expect(
        config.passwordValidationFunction(' short '),
        isFalse,
      );
      expect(
        config.passwordValidationFunction(' long1235 '),
        isFalse,
      );
    });

    test(
        'when a short (<8 characters) password is validated, then is it not accepted.',
        () {
      expect(
        config.passwordValidationFunction('1234567'),
        isFalse,
      );
      expect(
        config.passwordValidationFunction('abcdefg'),
        isFalse,
      );
      expect(
        config.passwordValidationFunction('Abc123!'),
        isFalse,
      );
    });

    test(
        'when a long (>=8 characters) password is validated, then is it not accepted.',
        () {
      expect(
        config.passwordValidationFunction('12345678'),
        isTrue,
      );
      expect(
        config.passwordValidationFunction('123456789'),
        isTrue,
      );
      expect(
        config.passwordValidationFunction('abcdefgh'),
        isTrue,
      );
      expect(
        config.passwordValidationFunction('Abc1234!'),
        isTrue,
      );
    });

    test(
        'when a account creation verification code is generated, then it is lower-case alpha-numeric and 8 characters long.',
        () {
      expect(
        config.registrationVerificationCodeGenerator(),
        matches(RegExp(r'^[a-z0-9]{8}$')),
      );
    });

    test(
        'when a password reset verification code is generated, then it is lower-case alpha-numeric and 8 characters long.',
        () {
      expect(
        config.passwordResetVerificationCodeGenerator(),
        matches(RegExp(r'^[a-z0-9]{8}$')),
      );
    });
  });
}
