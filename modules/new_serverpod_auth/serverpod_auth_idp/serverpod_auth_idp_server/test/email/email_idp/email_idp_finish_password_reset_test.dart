import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given password reset request created',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const allowedNewPassword = 'NewPassword123!';
      late String verificationCode;
      const passwordResetVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            passwordHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
            passwordValidationFunction: (final password) =>
                password == allowedNewPassword,
          ),
        );

        final authUser = await fixture.createAuthUser(session);
        authUserId = authUser.id;

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.emailIDP.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when finishPasswordReset is called with valid parameters then it returns auth session token',
          () async {
        final result = session.db.transaction(
          (final transaction) => fixture.emailIDP.finishPasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: allowedNewPassword,
            transaction: transaction,
          ),
        );

        await expectLater(result, completion(isA<AuthSuccess>()));
      });

      test(
          'when finishPasswordReset is called with invalid verification code then it throws EmailAccountPasswordResetException',
          () async {
        final result = session.db.transaction(
          (final transaction) => fixture.emailIDP.finishPasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: '$verificationCode-invalid',
            newPassword: allowedNewPassword,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.invalid,
            ),
          ),
        );
      });

      test(
          'when finishPasswordReset is called with password that violates policy then it throws EmailAccountPasswordResetException with policyViolation reason',
          () async {
        final result = session.db.transaction(
          (final transaction) => fixture.emailIDP.finishPasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: '$allowedNewPassword-invalid',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.policyViolation,
            ),
          ),
        );
      });
    },
  );

  withServerpod('Given expired password reset request',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
      (final sessionBuilder, final endpoints) {
    late Session session;
    late EmailIDPTestFixture fixture;
    late UuidValue passwordResetRequestId;
    const email = 'test@serverpod.dev';
    const password = 'Password123!';
    late String verificationCode;
    const passwordResetVerificationCodeLifetime = Duration(hours: 1);

    setUp(() async {
      session = sessionBuilder.build();

      verificationCode = const Uuid().v4().toString();
      fixture = EmailIDPTestFixture(
        config: EmailIDPConfig(
          passwordHashPepper: 'pepper',
          passwordResetVerificationCodeGenerator: () => verificationCode,
          passwordResetVerificationCodeLifetime:
              passwordResetVerificationCodeLifetime,
        ),
      );

      final authUser = await fixture.createAuthUser(session);

      await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
        password: EmailAccountPassword.fromString(password),
      );

      await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ), () async {
        passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.emailIDP.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
        'when finishPasswordReset is called with valid parameters then it throws EmailAccountPasswordResetException with expired reason',
        () async {
      final result = session.db.transaction(
        (final transaction) => fixture.emailIDP.finishPasswordReset(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          newPassword: 'NewPassword123!',
          transaction: transaction,
        ),
      );

      await expectLater(
        result,
        throwsA(
          isA<EmailAccountPasswordResetException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountPasswordResetExceptionReason.expired,
          ),
        ),
      );
    });
  });

  withServerpod('Given no password reset request created',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
      (final sessionBuilder, final endpoints) {
    late Session session;
    late EmailIDPTestFixture fixture;

    setUp(() async {
      session = sessionBuilder.build();
      fixture = EmailIDPTestFixture();
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
        'when finishPasswordReset is called then it throws EmailAccountPasswordResetException with invalid reason',
        () async {
      final result = session.db.transaction(
        (final transaction) => fixture.emailIDP.finishPasswordReset(
          session,
          passwordResetRequestId: const Uuid().v4obj(),
          verificationCode: 'some-code',
          newPassword: 'NewPassword123!',
          transaction: transaction,
        ),
      );

      await expectLater(
        result,
        throwsA(
          isA<EmailAccountPasswordResetException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountPasswordResetExceptionReason.invalid,
          ),
        ),
      );
    });
  });

  // TODO: This scenario is a bit strange since it allows the password reset
  // to be completed even though the auth user is blocked and just prevents
  // a new session from being created.
  withServerpod('Given password reset request exists for blocked auth user',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
      (final sessionBuilder, final endpoints) {
    late Session session;
    late EmailIDPTestFixture fixture;
    late UuidValue passwordResetRequestId;
    const email = 'test@serverpod.dev';
    const password = 'Password123!';
    late String verificationCode;

    setUp(() async {
      session = sessionBuilder.build();

      verificationCode = const Uuid().v4().toString();
      fixture = EmailIDPTestFixture(
        config: EmailIDPConfig(
          passwordHashPepper: 'pepper',
          passwordResetVerificationCodeGenerator: () => verificationCode,
        ),
      );

      final authUser = await fixture.createAuthUser(session);

      await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
        password: EmailAccountPassword.fromString(password),
      );

      passwordResetRequestId = await session.db.transaction(
        (final transaction) => fixture.emailIDP.startPasswordReset(
          session,
          email: email,
          transaction: transaction,
        ),
      );

      // Block the auth user after creating the password reset request
      await AuthUsers.update(
        session,
        authUserId: authUser.id,
        blocked: true,
      );
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
        'when finishPasswordReset is called then it throws AuthUserBlockedException',
        () async {
      final result = session.db.transaction(
        (final transaction) => fixture.emailIDP.finishPasswordReset(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          newPassword: 'NewPassword123!',
          transaction: transaction,
        ),
      );

      await expectLater(
        result,
        throwsA(isA<AuthUserBlockedException>()),
      );
    });
  });

  withServerpod('Given user with multiple sessions and password reset request',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
      (final sessionBuilder, final endpoints) {
    late Session session;
    late EmailIDPTestFixture fixture;
    late UuidValue passwordResetRequestId;
    late UuidValue authUserId;
    const email = 'test@serverpod.dev';
    const password = 'Password123!';
    late String verificationCode;
    const newPassword = 'NewPassword123!';

    setUp(() async {
      session = sessionBuilder.build();
      verificationCode = const Uuid().v4().toString();
      fixture = EmailIDPTestFixture(
        config: EmailIDPConfig(
          passwordHashPepper: 'pepper',
          passwordResetVerificationCodeGenerator: () => verificationCode,
        ),
      );
      final authUser = await fixture.createAuthUser(session);
      authUserId = authUser.id;

      // Create a session before password reset
      // ignore: unused_result
      await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        method: 'email',
        scopes: {},
      );

      await fixture.createEmailAccount(
        session,
        authUserId: authUserId,
        email: email,
        password: EmailAccountPassword.fromString(password),
      );

      passwordResetRequestId = await session.db.transaction(
        (final transaction) => fixture.emailIDP.startPasswordReset(
          session,
          email: email,
          transaction: transaction,
        ),
      );
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });
    test(
        'when finishPasswordReset is called with valid parameters then it destroys all existing sessions',
        () async {
      // Complete password reset
      final authSuccess = await session.db.transaction(
        (final transaction) => fixture.emailIDP.finishPasswordReset(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          newPassword: newPassword,
          transaction: transaction,
        ),
      );

      // Verify the session was destroyed by checking if it still exists
      final sessions = await AuthSessions.admin.findSessions(
        session,
        authUserId: authUserId,
      );

      expect(sessions, hasLength(1));
      expect(sessions.single.authUserId, authSuccess.authUserId);
    });
  });
}
