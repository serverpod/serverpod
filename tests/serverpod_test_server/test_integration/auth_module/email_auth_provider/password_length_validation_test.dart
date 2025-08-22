import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  group('Given the password of a particular length', () {
    test(
        'then isValidPasswordLength returns true with password length in acceptable range',
        () {
      final tester = Emails.isValidPasswordLength(
        password: '12345678',
      );
      expect(tester, isTrue);
    });

    test(
        'then isValidPasswordLength returns false with password length not in acceptable range',
        () {
      final tester = Emails.isValidPasswordLength(
        password: '123',
      );
      expect(tester, isFalse);
    });
  });

  withServerpod('Given a created user when changing password',
      (sessionBuilder, _) {
    final session = sessionBuilder.build();

    const userName = 'user-change';
    const email = 'user.change@serverpod.dev';
    const oldPassword = 'oldPassword1';

    setUp(() async {
      await Emails.createUser(session, userName, email, oldPassword);
    });

    test('then new password shorter than minimum is rejected', () async {
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

    test('then new password with acceptable length is accepted', () async {
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
  });

  withServerpod('Given a created user when resetting password',
      (sessionBuilder, _) {
    final session = sessionBuilder.build();

    const userName = 'user-reset';
    const email = 'user.reset@serverpod.dev';

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
      await Emails.createUser(session, userName, email, 'initialPass1');
      latestResetCode = null;
    });

    test('then reset with too short password is rejected', () async {
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

    test('then reset with acceptable password length is accepted', () async {
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
}
