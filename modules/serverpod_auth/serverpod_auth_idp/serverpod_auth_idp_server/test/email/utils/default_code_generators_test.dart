import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

void main() {
  group('Given defaultSixDigitVerificationCodeGenerator', () {
    test('when generating a code then it consists of exactly 6 digits.', () {
      for (var i = 0; i < 200; i++) {
        expect(defaultSixDigitVerificationCodeGenerator(), matches(r'^\d{6}$'));
      }
    });

    test(
      'when generating a code then it is accepted by the Serverpod Cloud email service (1-16 alphanumeric characters).',
      () {
        for (var i = 0; i < 200; i++) {
          expect(
            defaultSixDigitVerificationCodeGenerator(),
            matches(r'^[A-Za-z0-9]{1,16}$'),
          );
        }
      },
    );

    test(
      'when generating many codes then every digit including 0 is used.',
      () {
        final digits = {
          for (var i = 0; i < 500; i++)
            ...defaultSixDigitVerificationCodeGenerator().split(''),
        };

        expect(digits, hasLength(10));
      },
    );

    test('when generating two codes then they are not always equal.', () {
      final codes = {
        for (var i = 0; i < 20; i++) defaultSixDigitVerificationCodeGenerator(),
      };

      expect(codes.length, greaterThan(1));
    });
  });
}
