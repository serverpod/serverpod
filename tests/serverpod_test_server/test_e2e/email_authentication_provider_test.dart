import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );
  // ".bar" is the only valid top level domain for test email addresses
  const email = 'test@serverpod.bar';
  const password = 'password';
  const userName = 'test';

  tearDown(() async => await client.emailAuthTestMethods.tearDown());
  test(
      'Given no user exists when creating user then user is created and can be authenticated',
      () async {
    var createAccountRequest =
        await client.modules.auth.email.createAccountRequest(
      userName,
      email,
      password,
    );
    expect(createAccountRequest, isTrue,
        reason: 'Failed to submit create account request');

    var verificationCode =
        await client.emailAuthTestMethods.findVerificationCode(userName, email);
    expect(verificationCode, isNotNull,
        reason: 'Failed to find verification code');

    var response = await client.modules.auth.email.createAccount(
      email,
      verificationCode!,
    );

    expect(response, isNotNull,
        reason: 'Failed to create account using verification code');

    var authResponse =
        await client.modules.auth.email.authenticate(email, password);
    expect(authResponse.success, isTrue, reason: 'Failed to authenticate user');
  });

  group('Given existing user', () {
    setUp(
      () async {
        var createUserRequest = await client.emailAuthTestMethods.createUser(
          userName,
          email,
          password,
        );
        assert(createUserRequest, 'Failed to create user');

        var authResponse =
            await client.modules.auth.email.authenticate(email, password);
        assert(authResponse.success, 'Failed to authenticate user');
      },
    );

    test(
        'when changing password using password reset then user can authenticate using new password',
        () async {
      var initiatePasswordResetResponse =
          await client.modules.auth.email.initiatePasswordReset(email);
      expect(
        initiatePasswordResetResponse,
        isTrue,
        reason: 'Failed to initiate password reset',
      );

      var resetCode = await client.emailAuthTestMethods.findResetCode(email);
      expect(
        resetCode,
        isNotNull,
        reason: 'Failed to find password reset code',
      );

      var newPassword = '$password-with-addition';
      var resetPasswordResponse = await client.modules.auth.email.resetPassword(
        resetCode!,
        newPassword,
      );
      expect(
        resetPasswordResponse,
        isTrue,
        reason: 'Failed to reset password',
      );

      var authResponse =
          await client.modules.auth.email.authenticate(email, newPassword);
      expect(
        authResponse.success,
        isTrue,
        reason: 'Failed to authenticate user with new password',
      );
    });

    test('when authenticating with wrong password then authentication fails',
        () async {
      var wrongPassword = '$password-wrong';
      var authResponse =
          await client.modules.auth.email.authenticate(email, wrongPassword);

      expect(
        authResponse.success,
        isFalse,
        reason: 'User authenticated with wrong password',
      );
    });
  });

  group('Given existing and authenticated user', () {
    setUp(
      () async {
        var createUserRequest = await client.emailAuthTestMethods.createUser(
          userName,
          email,
          password,
        );
        assert(createUserRequest, 'Failed to create user');

        var authResponse =
            await client.modules.auth.email.authenticate(email, password);
        assert(authResponse.success, 'Failed to authenticate user');
        assert(authResponse.key != null, 'Failed to retrieve auth key');
        await client.authenticationKeyManager
            ?.put('${authResponse.keyId}:${authResponse.key}');

        assert(await client.modules.auth.status.isSignedIn(),
            'User not signed in');
      },
    );

    tearDown(() async => await client.authenticationKeyManager?.remove());

    test('when changing password then user can authenticate with new password',
        () async {
      var newPassword = '$password-with-addition';
      var changePasswordResponse =
          await client.modules.auth.email.changePassword(
        password,
        newPassword,
      );

      expect(
        changePasswordResponse,
        isTrue,
        reason: 'Password change request failed.',
      );

      var authResponse =
          await client.modules.auth.email.authenticate(email, newPassword);
      expect(
        authResponse.success,
        isTrue,
        reason: 'Failed to authenticate user with new password',
      );
    });
  });
}
