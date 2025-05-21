import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:test/test.dart';

void main() {
  group('Given the default `EmailAccountConfig`,', () {
    final config = EmailAccountConfig();

    test(
        'when a password surrounded by whitespace is validated, then is it not accepted.',
        () {
      expect(
        config.registrationPasswordValidationFunction(' short '),
        isFalse,
      );
      expect(
        config.registrationPasswordValidationFunction(' long1235 '),
        isFalse,
      );
    });

    test(
        'when a short (<8 characters) password is validated, then is it not accepted.',
        () {
      expect(
        config.registrationPasswordValidationFunction('1234567'),
        isFalse,
      );
      expect(
        config.registrationPasswordValidationFunction('abcdefg'),
        isFalse,
      );
      expect(
        config.registrationPasswordValidationFunction('Abc123!'),
        isFalse,
      );
    });

    test(
        'when a long (>=8 characters) password is validated, then is it not accepted.',
        () {
      expect(
        config.registrationPasswordValidationFunction('12345678'),
        isTrue,
      );
      expect(
        config.registrationPasswordValidationFunction('123456789'),
        isTrue,
      );
      expect(
        config.registrationPasswordValidationFunction('abcdefgh'),
        isTrue,
      );
      expect(
        config.registrationPasswordValidationFunction('Abc1234!'),
        isTrue,
      );
    });
  });
}
