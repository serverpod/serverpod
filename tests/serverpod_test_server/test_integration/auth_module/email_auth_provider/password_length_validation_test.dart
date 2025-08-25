import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  withServerpod('Given an existing user ', (sessionBuilder, _) {
    final session = sessionBuilder.build();

    const userName = 'user-change';
    const email = 'user.change@serverpod.dev';
    const oldPassword = 'oldPassword1';

    // Capture latest reset code here
    String? latestResetCode;

    setUpAll(() async {
      // Configure sending reset emails to capture the verification code
      AuthConfig.set(
        AuthConfig(
          sendPasswordResetEmail: (sess, userInfo, validationCode) async {
            latestResetCode = validationCode;
            return true;
          },
          // Some other tests set this to false; keep defaults suitable for test
          extraSaltyHash: false,
          sendValidationEmail: (sess, email, code) async => true,
        ),
      );
    });

    setUp(() async {
      await Emails.createUser(session, userName, email, oldPassword);
      latestResetCode = null;
    });

    test(
        'when changing to a password that is shorter than minimum required password length then password change is rejected',
        () async {
      final user = await Users.findUserByEmail(session, email);
      expect(user, isNotNull, reason: 'User should exist');

      final success = await Emails.changePassword(
        session,
        user!.id!,
        oldPassword,
        '123', // too short
      );

      expect(success, isFalse);
    });

    test(
        'when changing to a password that is in range within required password length then password change is accepted',
        () async {
      final user = await Users.findUserByEmail(session, email);
      expect(user, isNotNull, reason: 'User should exist');

      final success = await Emails.changePassword(
        session,
        user!.id!,
        oldPassword,
        '12345678', // min length
      );

      expect(success, isTrue);
    });

    test(
        'when resetting a password that is shorter than minimum required password length then password change is rejected',
        () async {
      final initiated = await Emails.initiatePasswordReset(session, email);
      expect(initiated, isTrue, reason: 'Password reset should be initiated');
      expect(latestResetCode, isNotNull,
          reason: 'Reset code should be captured');

      final success = await Emails.resetPassword(
        session,
        latestResetCode!,
        '123', // too short
      );

      expect(success, isFalse);
    });

    test(
        'when resetting a password that is in range within required password length then password change is accepted',
        () async {
      // Initiate a fresh reset to get a valid code
      final initiated = await Emails.initiatePasswordReset(session, email);
      expect(initiated, isTrue, reason: 'Password reset should be initiated');
      expect(latestResetCode, isNotNull,
          reason: 'Reset code should be captured');

      final success = await Emails.resetPassword(
        session,
        latestResetCode!,
        '12345678', // min length
      );

      expect(success, isTrue);
    });
  });

  withServerpod('Given create account request ', (sessionBuilder, _) async {
    var session = sessionBuilder.build();
    var userName = 'test';
    var email = 'test@serverpod.dev';

    test(
        'when creating an account with a password that is shorter than minimum required password length then password change is rejected',
        () async {
      final response = await Emails.createAccountRequest(
        session,
        userName,
        email,
        '123',
      );

      expect(response, isFalse);
    });

    test(
        'when creating an account with a password that is in range within required password length then password change is accepted',
        () async {
      final response = await Emails.createAccountRequest(
        session,
        userName,
        email,
        'password',
      );

      var createAccountRequest =
          await EmailCreateAccountRequest.db.findFirstRow(
        session,
        where: (t) => t.userName.equals(userName) & t.email.equals(email),
      );

      expect(response, isTrue);
      expect(
        createAccountRequest,
        isNotNull,
        reason: 'Failed to find create account request',
      );
    });
  });
}
