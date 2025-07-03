import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/src/generated/email_account.dart'
    as new_email_account_db;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;

      setUp(() async {
        session = sessionBuilder.build();

        userInfo = (await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        ))!;
      });

      test(
        'when calling `isUserMigrated`, then it returns `false`.',
        () async {
          expect(
            await AuthMigrations.isUserMigrated(session, userInfo.id!),
            isFalse,
          );
        },
      );

      test(
        'when calling `getNewAuthUserId`, then it returns `null`.',
        () async {
          expect(
            await AuthMigrations.getNewAuthUserId(session, userInfo.id!),
            isNull,
          );
        },
      );

      test(
        'when calling `migrateNextUserBatch`, then it completes.',
        () async {
          await expectLater(
            AuthMigrations.migrateNextUserBatch(
              session,
              transaction: session.transaction,
            ),
            completes,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account migrated with `migrateNextUserBatch`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();
        AuthMigrations.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            assert(migratedUsers[oldUserId] == null);
            migratedUsers[oldUserId] = newAuthUserId;
          },
        );

        userInfo = (await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        ))!;

        await AuthMigrations.migrateNextUserBatch(
          session,
          transaction: session.transaction,
        );
      });

      tearDown(() {
        AuthMigrations.config = AuthMigrationConfig();
        migratedUsers.clear();
      });

      test(
        'when calling `migrateNextUserBatch` again, then it completes.',
        () async {
          await expectLater(
            AuthMigrations.migrateNextUserBatch(
              session,
              transaction: session.transaction,
            ),
            completes,
          );
        },
      );

      test(
        'when calling `isUserMigrated`, then it returns `true`.',
        () async {
          expect(
            await AuthMigrations.isUserMigrated(session, userInfo.id!),
            isTrue,
          );
        },
      );

      test(
        'when checking the custom migration hook, then it has been called for the user.',
        () async {
          expect(
            migratedUsers[userInfo.id!],
            isNotNull,
          );
        },
      );

      test(
        'when calling `getNewAuthUserId`, then it returns the new ID.',
        () async {
          expect(
            await AuthMigrations.getNewAuthUserId(session, userInfo.id!),
            migratedUsers[userInfo.id!],
          );
        },
      );

      test(
        'when checking the `EmailAccount`, then it has been created with the lower-case email variant.',
        () async {
          final emailAccount =
              await new_email_account_db.EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(
              migratedUsers.values.single,
            ),
          );

          expect(
            emailAccount,
            isNotNull,
          );
          expect(
            emailAccount?.email,
            email.toLowerCase(),
          );
        },
      );

      test(
        'when checking the `LegacyUserIdentifier`, then it has been created with the lower-case email variant.',
        () async {
          final legacyUserIdentifier =
              await LegacyUserIdentifier.db.findFirstRow(
            session,
            where: (final t) => t.newAuthUserId.equals(
              migratedUsers.values.single,
            ),
          );

          expect(
            legacyUserIdentifier,
            isNotNull,
          );
          expect(
            legacyUserIdentifier?.userIdentifier,
            email.toLowerCase(),
          );
        },
      );

      test(
        'when fetching the `UserProfile`, then it exists.',
        () async {
          expect(
            await UserProfiles.findUserProfileByUserId(
              session,
              migratedUsers.values.single,
            ),
            isNotNull,
          );
        },
      );
    },
  );

  withServerpod(
    'Given five legacy `serverpod_auth` email-based user accounts,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();
        AuthMigrations.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            migratedUsers[oldUserId] = newAuthUserId;
          },
        );

        for (var i = 0; i < 5; i++) {
          await legacy_auth.Emails.createUser(
            session,
            'user name',
            'test_$i@serverpod.dev',
            'Somepassword123!',
          );
        }
      });

      tearDown(() {
        AuthMigrations.config = AuthMigrationConfig();
        migratedUsers.clear();
      });

      test(
        'when calling `migrateNextUserBatch` successively, then accounts are migrated in the desired batch size.',
        () async {
          final migratedAccountsStep1 =
              await AuthMigrations.migrateNextUserBatch(
            session,
            maxUsers: 2,
            transaction: session.transaction,
          );
          expect(migratedAccountsStep1, 2);
          expect(migratedUsers, hasLength(2));
          expect(await MigratedUser.db.count(session), 2);

          final migratedAccountsStep2 =
              await AuthMigrations.migrateNextUserBatch(
            session,
            maxUsers: 2,
            transaction: session.transaction,
          );
          expect(migratedAccountsStep2, 2);
          expect(migratedUsers, hasLength(4));
          expect(await MigratedUser.db.count(session), 4);

          final migratedAccountsStep3 =
              await AuthMigrations.migrateNextUserBatch(
            session,
            maxUsers: 2,
            transaction: session.transaction,
          );
          expect(migratedAccountsStep3, 1);
          expect(migratedUsers, hasLength(5));
          expect(await MigratedUser.db.count(session), 5);
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` social-login-based user account migrated with `migrateNextUserBatch`,',
    (final sessionBuilder, final endpoints) {
      const externalUserIdentifier = 'Apple-UserId-123';

      late Session session;
      late legacy_auth.UserInfo userInfo;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();
        AuthMigrations.config = AuthMigrationConfig(
          userMigrationHook: (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            assert(migratedUsers[oldUserId] == null);
            migratedUsers[oldUserId] = newAuthUserId;
          },
        );

        userInfo = (await legacy_auth.Users.createUser(
          session,
          legacy_auth.UserInfo(
            userIdentifier: externalUserIdentifier,
            userName: null,
            fullName: null,
            email: null,
            blocked: false,
            created: DateTime.now(),
            scopeNames: [],
          ),
          'apple',
          null,
          null,
        ))!;

        await AuthMigrations.migrateNextUserBatch(
          session,
          transaction: session.transaction,
        );
      });

      tearDown(() {
        AuthMigrations.config = AuthMigrationConfig();
        migratedUsers.clear();
      });

      test(
        'when calling `isUserMigrated`, then it returns `true`.',
        () async {
          expect(
            await AuthMigrations.isUserMigrated(session, userInfo.id!),
            isTrue,
          );
        },
      );

      test(
        'when checking the custom migration hook, then it has been called for the user.',
        () async {
          expect(
            migratedUsers[userInfo.id!],
            isNotNull,
          );
        },
      );

      test(
        'when calling `getNewAuthUserId`, then it returns the new ID.',
        () async {
          expect(
            await AuthMigrations.getNewAuthUserId(session, userInfo.id!),
            migratedUsers[userInfo.id!],
          );
        },
      );

      test(
        'when checking the `EmailAccount`, then no entry has been created for the social-backed account.',
        () async {
          expect(
            await new_email_account_db.EmailAccount.db.find(session),
            isEmpty,
          );
        },
      );

      test(
        'when checking the `LegacyUserIdentifier`, then it has been created with the external user ID.',
        () async {
          final legacyUserIdentifier =
              await LegacyUserIdentifier.db.findFirstRow(
            session,
            where: (final t) => t.newAuthUserId.equals(
              migratedUsers.values.single,
            ),
          );

          expect(
            legacyUserIdentifier,
            isNotNull,
          );
          expect(
            legacyUserIdentifier?.userIdentifier,
            externalUserIdentifier,
          );
        },
      );

      test(
        'when fetching the `UserProfile`, then it exists.',
        () async {
          expect(
            await UserProfiles.findUserProfileByUserId(
              session,
              migratedUsers.values.single,
            ),
            isNotNull,
          );
        },
      );
    },
  );
}
