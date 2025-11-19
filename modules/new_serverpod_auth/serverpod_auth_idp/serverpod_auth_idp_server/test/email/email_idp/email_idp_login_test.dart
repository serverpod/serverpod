import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an existing email account with scopes',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);

        await fixture.authUsers.update(
          session,
          authUserId: authUser.id,
          scopes: {const Scope('test-scope'), const Scope('admin')},
        );

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when login is called with correct credentials then it returns auth session token',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: password,
          );

          await expectLater(result, completion(isA<AuthSuccess>()));
        },
      );

      test(
        'when login is called with invalid credentials then it throws EmailAccountLoginException with invalidCredentials',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: 'WrongPassword123!',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      test(
        'when login is called, then the returned AuthSuccess contains the users scopes',
        () async {
          final result = await fixture.emailIDP.login(
            session,
            email: email,
            password: password,
          );

          expect(result.scopeNames, contains('test-scope'));
          expect(result.scopeNames, contains('admin'));
          expect(result.scopeNames, hasLength(2));
        },
      );
    },
  );

  withServerpod(
    'Given blocked auth user with email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);
        await fixture.authUsers.update(
          session,
          authUserId: authUser.id,
          blocked: true,
        );

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when login is called with correct credentials then it throws AuthUserBlockedException',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: password,
          );

          await expectLater(
            result,
            throwsA(isA<AuthUserBlockedException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given email account with invalid logins matching rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const maxLoginAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            failedLoginRateLimit: maxLoginAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        // Make initial failed login attempt to hit the rate limit
        try {
          await fixture.emailIDP.login(
            session,
            email: email,
            password: 'WrongPassword123!',
          );
        } on EmailAccountLoginException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when login is called with valid credentials then it throws EmailAccountLoginException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: password,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );

      test(
        'when login is called with invalid credentials then it throws EmailAccountLoginException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: '$password-invalid',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given no email account',
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
        'when login is called then it throws EmailAccountLoginException with invalidCredentials',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: 'nonexistent@serverpod.dev',
            password: 'Password123!',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given maximum allowed invalid login attempts for non-existent email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const maxLoginAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );
      const email = 'nonexistent@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            failedLoginRateLimit: maxLoginAttempts,
          ),
        );

        // Make initial failed login attempt to hit the rate limit
        try {
          await fixture.emailIDP.login(
            session,
            email: email,
            password: 'WrongPassword123!',
          );
        } on EmailAccountLoginException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when login is called then it throws EmailAccountLoginException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.login(
            session,
            email: email,
            password: 'Password123!',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );
}
