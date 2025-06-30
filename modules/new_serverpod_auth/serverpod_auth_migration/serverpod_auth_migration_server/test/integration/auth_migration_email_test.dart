import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as new_email_account;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as new_profile;
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as new_auth_user;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no legacy or new auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() {
        session = sessionBuilder.build();
      });

      test(
        'when attempting to run `migrateOnLogin` for a non-existent account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: '404@serverpod.dev',
              password: 'thepassword!',
            ),
            completes,
          );
        },
      );

      test(
        'when attempting to run `migrateWithoutPassword` for a non-existent account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: '404@serverpod.dev',
            ),
            completes,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        );
      });

      test(
        'when running `migrateOnLogin` with the correct password, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when running `migrateOnLogin` with the correct password, then it imports the user.',
        () async {
          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: password,
          );

          expect(await new_auth_user.AuthUser.db.find(session), hasLength(1));
        },
      );

      test(
        'when running `migrateOnLogin` with an incorrect password, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: 'some other password',
            ),
            completes,
          );
        },
      );

      test(
        'when running `migrateOnLogin` with an incorrect password, then it does not import the user.',
        () async {
          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: 'some other password',
          );

          expect(await new_auth_user.AuthUser.db.find(session), isEmpty);
        },
      );

      test(
        'when running `migrateWithoutPassword`, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: email,
            ),
            completes,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account and a throwing `userMigrationHook`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        );

        AuthMigrationEmail.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) {
            throw UnimplementedError();
          },
        );
      });

      tearDown(() {
        AuthMigrationEmail.config = AuthMigrationConfig();
      });

      test(
        'when running `migrateWithoutPassword`, then it forwards the error and does not create an `AuthUser`.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: email,
            ),
            throwsUnimplementedError,
          );

          expect(await new_auth_user.AuthUser.db.find(session), isEmpty);
        },
      );

      test(
        'when running `migrateOnLogin`, then it forwards the error and does not create an `AuthUser`.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: password,
            ),
            throwsUnimplementedError,
          );

          expect(await new_auth_user.AuthUser.db.find(session), isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account which is blocked,',
    (final sessionBuilder, final endpoints) {
      const email = 'blocked@serverpod.dev';
      const password = 'Somepassword123!';

      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final user = await legacy_auth.Emails.createUser(
          session,
          'user name',
          email,
          password,
        );
        await legacy_auth.Users.blockUser(session, user!.id!);
      });

      test(
        'when running `migrateOnLogin` with the correct password, then it does not import the user.',
        () async {
          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: password,
          );

          expect(await new_auth_user.AuthUser.db.find(session), isEmpty);
        },
      );

      test(
        'when running `migrateWithoutPassword`, then it is imported and its blocked status retained.',
        () async {
          await AuthMigrationEmail.migrateWithoutPassword(
            session,
            email: email,
          );

          final authUser =
              (await new_auth_user.AuthUser.db.find(session)).single;
          expect(authUser.blocked, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using `migrateOnLogin`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;
      late UuidValue authUserId;
      late ({int oldUserId, UuidValue newAuthUserId})? migratedUser;

      setUp(() async {
        session = sessionBuilder.build();

        AuthMigrationEmail.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            migratedUser = (oldUserId: oldUserId, newAuthUserId: newAuthUserId);
          },
        );

        userInfo = (await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        ))!;

        await AuthMigrationEmail.migrateOnLogin(
          session,
          email: email,
          password: password,
        );

        authUserId = (await new_email_account.EmailAccounts.admin.findAccount(
          session,
          email: email,
        ))!
            .authUserId;
      });

      tearDown(() {
        AuthMigrationEmail.config = AuthMigrationConfig();
      });

      test(
        'when the migration is done, then no session has been created in the legacy system.',
        () async {
          expect(
            await legacy_auth.AuthKey.db.find(session),
            isEmpty,
          );
        },
      );

      test(
        'when the migration is done, then the migration hook has been invoked.',
        () async {
          expect(
            migratedUser?.oldUserId,
            userInfo.id!,
          );

          expect(
            migratedUser?.newAuthUserId,
            authUserId,
          );
        },
      );

      test(
        'when checking the migrated users table, then an entry has been written for it.',
        () async {
          final migratedUser = (await MigratedUser.db.find(session)).single;

          expect(migratedUser.oldUserId, userInfo.id);
          expect(migratedUser.newAuthUserId, authUserId);
        },
      );

      test(
        'when attempting to run `migrateOnLogin` again for that account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when attempting to run `migrateOnLogin` again for that account, then does not invoke the migration hook again.',
        () async {
          expect(migratedUser, isNotNull);
          migratedUser = null;

          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: password,
            ),
            completes,
          );

          expect(migratedUser, isNull);
        },
      );

      test(
        'when attempting to run `migrateWithoutPassword` for that account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: email,
            ),
            completes,
          );
        },
      );

      test(
        'when attempting to log into the new system with the credentials, then that succeeds.',
        () async {
          expect(
            await new_email_account.EmailAccounts.login(
              session,
              email: email,
              password: password,
              transaction: session.transaction,
            ),
            isNotNull,
          );
        },
      );

      test('when reading the profile, then it matches the original user info.',
          () async {
        final profile = await new_profile.UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(profile.email, userInfo.email);
        expect(profile.userName, userInfo.userName);
        expect(profile.fullName, userInfo.fullName);
        expect(profile.email, email.toLowerCase());
      });
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using `migrateOnLogin` and `importProfile: false`,',
    (final sessionBuilder, final endpoints) {
      const email = 'foo@serverpod.dev';
      const password = 'Somepassword123!';

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        await legacy_auth.Emails.createUser(
          session,
          'user name',
          email,
          password,
        );

        AuthMigrationEmail.config = AuthMigrationConfig(
          importProfile: false,
        );

        await AuthMigrationEmail.migrateOnLogin(
          session,
          email: email,
          password: password,
        );

        AuthMigrationEmail.config = AuthMigrationConfig();

        authUserId = (await new_email_account.EmailAccounts.admin.findAccount(
          session,
          email: email,
        ))!
            .authUserId;
      });

      test(
        'when reading the profile, then it throws because none has been created.',
        () async {
          await expectLater(
            () => new_profile.UserProfiles.findUserProfileByUserId(
              session,
              authUserId,
            ),
            throwsA(isA<new_profile.UserProfileNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using `migrateWithoutPassword` and `importProfile: false`,',
    (final sessionBuilder, final endpoints) {
      const email = 'foo@serverpod.dev';
      const password = 'Somepassword123!';

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        await legacy_auth.Emails.createUser(
          session,
          'user name',
          email,
          password,
        );

        AuthMigrationEmail.config = AuthMigrationConfig(
          importProfile: false,
        );

        await AuthMigrationEmail.migrateWithoutPassword(
          session,
          email: email,
        );

        AuthMigrationEmail.config = AuthMigrationConfig();

        authUserId = (await new_email_account.EmailAccounts.admin.findAccount(
          session,
          email: email,
        ))!
            .authUserId;
      });

      test(
        'when reading the profile, then it throws because none has been created.',
        () async {
          await expectLater(
            () => new_profile.UserProfiles.findUserProfileByUserId(
              session,
              authUserId,
            ),
            throwsA(isA<new_profile.UserProfileNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using `migrateWithoutPassword`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;
      late UuidValue authUserId;

      late ({int oldUserId, UuidValue newAuthUserId})? migratedUser;

      setUp(() async {
        session = sessionBuilder.build();

        AuthMigrationEmail.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            migratedUser = (oldUserId: oldUserId, newAuthUserId: newAuthUserId);
          },
        );

        userInfo = (await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        ))!;

        await AuthMigrationEmail.migrateWithoutPassword(
          session,
          email: email,
        );

        authUserId = (await new_email_account.EmailAccounts.admin.findAccount(
          session,
          email: email,
        ))!
            .authUserId;
      });

      tearDown(() {
        AuthMigrationEmail.config = AuthMigrationConfig();
      });

      test(
        'when the migration is done, then no session has been created in the legacy system.',
        () async {
          expect(
            await legacy_auth.AuthKey.db.find(session),
            isEmpty,
          );
        },
      );

      test(
        'when the migration is done, then the migration hook has been invoked.',
        () async {
          expect(
            migratedUser?.oldUserId,
            userInfo.id!,
          );

          expect(
            migratedUser?.newAuthUserId,
            authUserId,
          );
        },
      );

      test(
        'when checking the migrated users table, then an entry has been written for it.',
        () async {
          final migratedUser = (await MigratedUser.db.find(session)).single;

          expect(migratedUser.oldUserId, userInfo.id);
          expect(migratedUser.newAuthUserId, authUserId);
        },
      );

      test(
        'when attempting to run `migrateOnLogin` for that account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateOnLogin(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when running `migrateOnLogin` with the correct password, then no session is created in the legacy system.',
        () async {
          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: password,
          );

          expect(
            await legacy_auth.AuthKey.db.find(session),
            isEmpty,
          );
        },
      );

      test(
        'when running `migrateOnLogin` with the correct password, then this password can be used for the login.',
        () async {
          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: password,
          );

          expect(
            await new_email_account.EmailAccounts.login(
              session,
              email: email,
              password: password,
              transaction: session.transaction,
            ),
            isNotNull,
          );
        },
      );

      test(
        'when running `migrateOnLogin` with a wrong password, then this password can not be used for the login.',
        () async {
          const wrongPassword = 'asdf456789!';

          await AuthMigrationEmail.migrateOnLogin(
            session,
            email: email,
            password: wrongPassword,
          );

          await expectLater(
            () => new_email_account.EmailAccounts.login(
              session,
              email: email,
              password: wrongPassword,
              transaction: session.transaction,
            ),
            throwsA(isA<new_email_account.EmailAccountLoginException>()),
          );
        },
      );

      test(
        'when attempting to run `migrateWithoutPassword` again for that account, then it completes without error.',
        () async {
          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: email,
            ),
            completes,
          );
        },
      );

      test(
        'when attempting to run `migrateWithoutPassword` again for that account, then does not invoke the migration hook again.',
        () async {
          expect(migratedUser, isNotNull);
          migratedUser = null;

          await expectLater(
            AuthMigrationEmail.migrateWithoutPassword(
              session,
              email: email,
            ),
            completes,
          );

          expect(migratedUser, isNull);
        },
      );

      test(
        'when attempting to log into the new system with the credentials, then that fails (because the password has not been set).',
        () async {
          await expectLater(
            () => new_email_account.EmailAccounts.login(
              session,
              email: email,
              // This is the user's password in the legacy system, but since it has not been set during the import,
              // it does not work on the login in the new system (without importing it first).
              password: password,
              transaction: session.transaction,
            ),
            throwsA(isA<new_email_account.EmailAccountLoginException>()),
          );
        },
      );

      test('when reading the profile, then it matches the original user info.',
          () async {
        final profile = await new_profile.UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(profile.email, userInfo.email);
        expect(profile.userName, userInfo.userName);
        expect(profile.fullName, userInfo.fullName);
        expect(profile.email, email.toLowerCase());
      });
    },
  );
}
