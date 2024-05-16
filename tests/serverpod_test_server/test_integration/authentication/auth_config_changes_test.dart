import 'package:serverpod_auth_server/module.dart';
import 'package:test/test.dart';

void main() async {
  test(
      'Given no validation code length when constructing AuthConfig then validation code has the default length of 8.',
      () {
    final auth = AuthConfig();
    expect(auth.validationCodeLength, 8);
  });

  test(
      'Given a positive integer as validation code length when constructing AuthConfig then validation code has the specified length.',
      () {
    final auth = AuthConfig(validationCodeLength: 4);
    expect(auth.validationCodeLength, 4);
  });

  test(
      'Given 0 as validation code length when trying to construct AuthConfig then throws.',
      () {
    expect(
        () => AuthConfig(validationCodeLength: 0),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid validation code length'),
        )));
  });

  test(
      'Given a negative integer as validation code length when trying to construct AuthConfig then throws.',
      () {
    expect(
        () => AuthConfig(validationCodeLength: -4),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid validation code length'),
        )));
  });
}
