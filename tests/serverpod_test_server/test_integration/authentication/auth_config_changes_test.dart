import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var userName = 'test';
  var email = 'test@serverpod.dev';
  var password = 'password';
  var session = await IntegrationTestServer().session();

  var codeLengthsToTest = [-16, -8, -4, -1, 0, 1, 4, 16];

  test(
      'Not setting validationCodeLength will generate a code with default length 8',
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

  for (var length in codeLengthsToTest) {
    final willPass = length >= 1;
    test(
        willPass
            ? 'Setting validationCodeLength to $length will generate a code with the given length'
            : 'Setting validationCodeLength to $length will return null',
        () async {
      String? generatedValidationCode;
      AuthConfig.set(
        AuthConfig(
          validationCodeLength: length,
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
        willPass ? isTrue : isFalse,
        reason: willPass
            ? 'Generated validation code is $length characters long, which is valid'
            : 'Generated validation code is null, which is invalid',
      );

      if (willPass) {
        assert(generatedValidationCode?.length == length);
      } else {
        assert(generatedValidationCode == null);
      }
    });
  }
}
