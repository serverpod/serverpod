import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var userName = 'test';
  var email = 'test@serverpod.dev';
  var password = 'password';
  var session = await IntegrationTestServer().session();

  test(
      'Given no validation code length configuration when creating an account then validation code has the default length of 8.',
      () async {
    String? generatedValidationCode;
    AuthConfig.set(
      AuthConfig(
        sendValidationEmail: (session, email, validationCode) async {
          generatedValidationCode = validationCode;
          return true;
        },
      ),
    );

    await Emails.createAccountRequest(session, userName, email, password);

    expect(generatedValidationCode, hasLength(8));
  });

  test(
      'Given a positive integer as validation code length when creating an account then validation code has the specified length.',
      () async {
    String? generatedValidationCode;
    AuthConfig.set(
      AuthConfig(
        validationCodeLength: 4,
        sendValidationEmail: (session, email, validationCode) async {
          generatedValidationCode = validationCode;
          return true;
        },
      ),
    );

    await Emails.createAccountRequest(session, userName, email, password);

    expect(generatedValidationCode, hasLength(4));
  });

  test(
      'Given 0 as validation code length when trying to construct AuthConfig then throws.',
      () {
    expect(
        () => AuthConfig(validationCodeLength: 0),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains('must be at least 4'),
        )));
  });

  test(
      'Given a negative integer as validation code length when trying to construct AuthConfig then throws.',
      () {
    expect(
        () => AuthConfig(validationCodeLength: -4),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          contains('must be at least 4'),
        )));
  });
}
