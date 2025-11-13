import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_idp_server/core.dart' as new_auth_core;
import 'package:serverpod_auth_idp_server/providers/email.dart' as new_auth_idp;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManager = new_auth_core.AuthSessionsTokenManager(
    config: new_auth_core.AuthSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
  );

  const config = new_auth_idp.EmailIDPConfig(secretHashPepper: 'test');
  final newEmailIDP = new_auth_idp.EmailIDP(config, tokenManager: tokenManager);

  setUp(() async {
    AuthMigrations.config = AuthMigrationConfig(emailIDP: newEmailIDP);
  });

  withServerpod('Given a legacy `serverpod_auth` email-based user account,', (
    final sessionBuilder,
    final endpoints,
  ) {
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

    test('when calling `isUserMigrated`, then it returns `false`.', () async {
      expect(
        await AuthMigrations.isUserMigrated(session, userInfo.id!),
        isFalse,
      );
    });

    test('when calling `getNewAuthUserId`, then it returns `null`.', () async {
      expect(
        await AuthMigrations.getNewAuthUserId(session, userInfo.id!),
        isNull,
      );
    });

    test('when calling `migrateUsers`, then it completes.', () async {
      await expectLater(
        AuthMigrations.migrateUsers(
          session,
          userMigration: null,
          transaction: session.transaction,
        ),
        completes,
      );
    });
  });

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account migrated with `migrateUsers`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();

        userInfo = (await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
        ))!;

        await AuthMigrations.migrateUsers(
          session,
          userMigration:
              (
                final session, {
                required final newAuthUserId,
                required final oldUserId,
                final transaction,
              }) async {
                assert(migratedUsers[oldUserId] == null);
                migratedUsers[oldUserId] = newAuthUserId;
              },
          transaction: session.transaction,
        );
      });

      tearDown(() {
        migratedUsers.clear();
      });

      test('when calling `migrateUsers` again, then it completes.', () async {
        await expectLater(
          AuthMigrations.migrateUsers(
            session,
            userMigration: null,
            transaction: session.transaction,
          ),
          completes,
        );
      });

      test('when calling `isUserMigrated`, then it returns `true`.', () async {
        expect(
          await AuthMigrations.isUserMigrated(session, userInfo.id!),
          isTrue,
        );
      });

      test(
        'when checking the custom migration hook, then it has been called for the user.',
        () async {
          expect(migratedUsers[userInfo.id!], isNotNull);
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
          final emailAccount = await new_auth_idp.EmailAccount.db.findFirstRow(
            session,
            where: (final t) =>
                t.authUserId.equals(migratedUsers.values.single),
          );

          expect(emailAccount, isNotNull);
          expect(emailAccount?.email, email.toLowerCase());
        },
      );

      test(
        'when checking the `LegacyUserIdentifier`, then it has been created with the lower-case email variant.',
        () async {
          final authUserId =
              await AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
                session,
                userIdentifier: email.toLowerCase(),
              );

          expect(authUserId, migratedUsers.values.single);
        },
      );

      test('when fetching the `UserProfile`, then it exists.', () async {
        const userProfiles = UserProfiles();
        expect(
          await userProfiles.findUserProfileByUserId(
            session,
            migratedUsers.values.single,
          ),
          isNotNull,
        );
      });
    },
  );

  withServerpod('Given five legacy `serverpod_auth` email-based user accounts,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UserMigrationFunction userMigration;

    final migratedUsers = <int, UuidValue>{};

    setUp(() async {
      session = sessionBuilder.build();

      userMigration =
          (
            final session, {
            required final newAuthUserId,
            required final oldUserId,
            final transaction,
          }) async {
            migratedUsers[oldUserId] = newAuthUserId;
          };

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
      migratedUsers.clear();
    });

    test(
      'when calling `migrateUsers` successively, then accounts are migrated in the desired batch size.',
      () async {
        final migratedAccountsStep1 = await AuthMigrations.migrateUsers(
          session,
          userMigration: userMigration,
          maxUsers: 2,
          transaction: session.transaction,
        );
        expect(migratedAccountsStep1, 2);
        expect(migratedUsers, hasLength(2));
        expect(await MigratedUser.db.count(session), 2);

        final migratedAccountsStep2 = await AuthMigrations.migrateUsers(
          session,
          userMigration: userMigration,
          maxUsers: 2,
          transaction: session.transaction,
        );
        expect(migratedAccountsStep2, 2);
        expect(migratedUsers, hasLength(4));
        expect(await MigratedUser.db.count(session), 4);

        final migratedAccountsStep3 = await AuthMigrations.migrateUsers(
          session,
          userMigration: userMigration,
          maxUsers: 2,
          transaction: session.transaction,
        );
        expect(migratedAccountsStep3, 1);
        expect(migratedUsers, hasLength(5));
        expect(await MigratedUser.db.count(session), 5);
      },
    );
  });

  withServerpod(
    'Given a legacy `serverpod_auth` social-login-based user account migrated with `migrateUsers`,',
    (final sessionBuilder, final endpoints) {
      const externalUserIdentifier = 'Apple-UserId-123';

      late Session session;
      late legacy_auth.UserInfo userInfo;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();

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

        await AuthMigrations.migrateUsers(
          session,
          userMigration:
              (
                final session, {
                required final newAuthUserId,
                required final oldUserId,
                final transaction,
              }) async {
                assert(migratedUsers[oldUserId] == null);
                migratedUsers[oldUserId] = newAuthUserId;
              },
          transaction: session.transaction,
        );
      });

      tearDown(() {
        migratedUsers.clear();
      });

      test('when calling `isUserMigrated`, then it returns `true`.', () async {
        expect(
          await AuthMigrations.isUserMigrated(session, userInfo.id!),
          isTrue,
        );
      });

      test(
        'when checking the custom migration hook, then it has been called for the user.',
        () async {
          expect(migratedUsers[userInfo.id!], isNotNull);
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
          expect(await new_auth_idp.EmailAccount.db.find(session), isEmpty);
        },
      );

      test(
        'when checking the `LegacyUserIdentifier`, then it has been created with the external user ID.',
        () async {
          final authUserId =
              await AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
                session,
                userIdentifier: externalUserIdentifier,
              );

          expect(authUserId, migratedUsers.values.single);
        },
      );

      test('when fetching the `UserProfile`, then it exists.', () async {
        const userProfiles = UserProfiles();
        expect(
          await userProfiles.findUserProfileByUserId(
            session,
            migratedUsers.values.single,
          ),
          isNotNull,
        );
      });
    },
  );
}
