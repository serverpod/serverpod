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

    var createAccountRequest =
        await Emails.createAccountRequest(session, userName, email, password);

    expect(
      createAccountRequest,
      isTrue,
      reason: 'Generated validation code is 8 characters long, which is valid',
    );

    assert(generatedValidationCode?.length == 8);
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

    var createAccountRequest =
        await Emails.createAccountRequest(session, userName, email, password);

    expect(
      createAccountRequest,
      isTrue,
      reason: 'Generated validation code is 4 characters long, which is valid',
    );

    assert(generatedValidationCode?.length == 4);
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
