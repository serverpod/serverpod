import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_core_server/auth_user.dart' as new_auth_user;
import 'package:serverpod_auth_core_server/profile.dart' as new_auth_profile;
import 'package:serverpod_auth_idp_server/core.dart' as new_auth_core;
import 'package:serverpod_auth_idp_server/providers/email.dart' as new_auth_idp;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerFactory = new_auth_core.AuthSessionsTokenManagerFactory(
    new_auth_core.AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  const newEmailIDPConfig = new_auth_idp.EmailIDPConfig(
    secretHashPepper: 'test',
  );
  late final new_auth_idp.EmailIDP newEmailIDP;

  setUpAll(() async {
    new_auth_core.AuthServices.set(
      identityProviders: [
        new_auth_idp.EmailIdentityProviderFactory(newEmailIDPConfig),
      ],
      primaryTokenManager: tokenManagerFactory,
    );
    newEmailIDP = new_auth_core.AuthServices.instance.emailIDP;
    AuthMigrations.config = AuthMigrationConfig(emailIDP: newEmailIDP);
  });

  tearDownAll(() async {
    new_auth_core.AuthServices.set(
      identityProviders: [],
      primaryTokenManager: tokenManagerFactory,
    );
  });

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account migrated with just `migrateUsers`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final user = await _createLegacyUser(
          session,
          email: email,
          password: password,
        );

        await AuthMigrations.migrateUsers(
          session,
          userMigration: null,
          legacyUserId: user.id!,
        );
      });

      test(
        'when running `importLegacyPasswordIfNeeded` with the correct password, then it completes without error.',
        () async {
          await expectLater(
            AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when running `importLegacyPasswordIfNeeded` with an incorrect password, then it completes without error.',
        () async {
          await expectLater(
            AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
              session,
              email: email,
              password: 'some other password',
            ),
            completes,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a migrated legacy `serverpod_auth` email-based user account which was fully imported `migrateUsers` and `importLegacyPasswordIfNeeded` with the correct password,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final user = await _createLegacyUser(
          session,
          email: email,
          password: password,
        );

        await AuthMigrations.migrateUsers(
          session,
          userMigration: null,
          legacyUserId: user.id!,
        );

        await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
          session,
          email: email,
          password: password,
        );
      });

      test(
        'when running `importLegacyPasswordIfNeeded` again with the correct password, then it completes without error.',
        () async {
          await expectLater(
            AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when running `importLegacyPasswordIfNeeded` again with an incorrect password, then it completes without error.',
        () async {
          await expectLater(
            AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
              session,
              email: email,
              password: 'some other password',
            ),
            completes,
          );
        },
      );

      test('when checking the password, then it is not empty', () async {
        expect(
          (await new_auth_idp.EmailAccount.db.find(
            session,
          )).single.passwordHash.lengthInBytes,
          greaterThan(0),
        );
      });
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

        await _createLegacyUser(session, email: email, password: password);
      });

      test(
        'when running `migrateUsers`, then it forwards the error and does not create an `AuthUser`.',
        () async {
          await expectLater(
            AuthMigrations.migrateUsers(
              session,
              userMigration:
                  (
                    final session, {
                    required final newAuthUserId,
                    required final oldUserId,
                    final transaction,
                  }) {
                    throw UnimplementedError();
                  },
            ),
            throwsUnimplementedError,
          );

          expect(await new_auth_user.AuthUser.db.find(session), isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using `migrateUsers` and `importLegacyPasswordIfNeeded`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;
      late UuidValue authUserId;
      late ({int oldUserId, UuidValue newAuthUserId})? migratedUser;

      setUp(() async {
        session = sessionBuilder.build();

        userInfo = await _createLegacyUser(
          session,
          email: email,
          password: password,
        );

        await AuthMigrations.migrateUsers(
          session,
          userMigration:
              (
                final session, {
                required final newAuthUserId,
                required final oldUserId,
                final transaction,
              }) async {
                migratedUser = (
                  oldUserId: oldUserId,
                  newAuthUserId: newAuthUserId,
                );
              },
          legacyUserId: userInfo.id!,
        );

        await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
          session,
          email: email,
          password: password,
        );

        authUserId = (await newEmailIDP.admin.findAccount(
          session,
          email: email,
        ))!.authUserId;
      });

      test(
        'when the migration is done, then no session has been created in the legacy system.',
        () async {
          expect(await legacy_auth.AuthKey.db.find(session), isEmpty);
        },
      );

      test(
        'when the migration is done, then the migration hook has been invoked.',
        () async {
          expect(migratedUser?.oldUserId, userInfo.id!);

          expect(migratedUser?.newAuthUserId, authUserId);
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
        'when attempting to authenticate against the new system with the credentials, then that succeeds.',
        () async {
          expect(
            await newEmailIDP.utils.authentication.authenticate(
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
        'when reading the profile, then it matches the original user info.',
        () async {
          const userProfiles = new_auth_profile.UserProfiles();
          final profile = await userProfiles.findUserProfileByUserId(
            session,
            authUserId,
          );

          expect(profile.email, userInfo.email);
          expect(profile.userName, userInfo.userName);
          expect(profile.fullName, userInfo.fullName);
          expect(profile.email, email.toLowerCase());
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using just `migrateUsers` and `importProfile: false`,',
    (final sessionBuilder, final endpoints) {
      const email = 'foo@serverpod.dev';
      const password = 'Somepassword123!';

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        await _createLegacyUser(session, email: email, password: password);

        AuthMigrations.config = AuthMigrationConfig(
          importProfile: false,
          emailIDP: newEmailIDP,
        );

        await AuthMigrations.migrateUsers(session, userMigration: null);

        AuthMigrations.config = AuthMigrationConfig(
          emailIDP: newEmailIDP,
        );

        authUserId = (await newEmailIDP.admin.findAccount(
          session,
          email: email,
        ))!.authUserId;
      });

      test(
        'when reading the profile, then it throws because none has been created.',
        () async {
          const userProfiles = new_auth_profile.UserProfiles();
          await expectLater(
            () => userProfiles.findUserProfileByUserId(
              session,
              authUserId,
            ),
            throwsA(isA<new_auth_profile.UserProfileNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account that has been migrated using just `migrateUsers`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;
      late legacy_auth.UserInfo userInfo;
      late UuidValue authUserId;

      late ({int oldUserId, UuidValue newAuthUserId})? migratedUser;

      setUp(() async {
        session = sessionBuilder.build();

        userInfo = await _createLegacyUser(
          session,
          email: email,
          password: password,
        );

        await AuthMigrations.migrateUsers(
          session,
          userMigration:
              (
                final session, {
                required final newAuthUserId,
                required final oldUserId,
                final transaction,
              }) async {
                migratedUser = (
                  oldUserId: oldUserId,
                  newAuthUserId: newAuthUserId,
                );
              },
        );

        authUserId = (await newEmailIDP.admin.findAccount(
          session,
          email: email,
        ))!.authUserId;
      });

      test(
        'when the migration is done, then no session has been created in the legacy system.',
        () async {
          expect(await legacy_auth.AuthKey.db.find(session), isEmpty);
        },
      );

      test(
        'when the migration is done, then the migration hook has been invoked.',
        () async {
          expect(migratedUser?.oldUserId, userInfo.id!);

          expect(migratedUser?.newAuthUserId, authUserId);
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
        'when attempting to run `importLegacyPasswordIfNeeded` for that account, then it completes without error.',
        () async {
          await expectLater(
            AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
              session,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'when running `importLegacyPasswordIfNeeded` with the correct password, then no session is created in the legacy system.',
        () async {
          await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: email,
            password: password,
          );

          expect(await legacy_auth.AuthKey.db.find(session), isEmpty);
        },
      );

      test(
        'when running `importLegacyPasswordIfNeeded` with the correct password, then this password can be used for the login.',
        () async {
          await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: email,
            password: password,
          );

          expect(
            await newEmailIDP.utils.authentication.authenticate(
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
        'when running `importLegacyPasswordIfNeeded` with a wrong password, then this password can not be used for the login.',
        () async {
          const wrongPassword = 'asdf456789!';

          await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: email,
            password: wrongPassword,
          );

          await expectLater(
            () => newEmailIDP.utils.authentication.authenticate(
              session,
              email: email,
              password: wrongPassword,
              transaction: session.transaction,
            ),
            throwsA(
              isA<
                new_auth_idp.EmailAuthenticationInvalidCredentialsException
              >(),
            ),
          );
        },
      );

      test(
        'when attempting to authenticate against the new system with the credentials, then that fails (because the password has not been set).',
        () async {
          await expectLater(
            () => newEmailIDP.utils.authentication.authenticate(
              session,
              email: email,
              // This is the user's password in the legacy system, but since it has not been set during the import,
              // it does not work on the login in the new system (without importing it first).
              password: password,
              transaction: session.transaction,
            ),
            throwsA(
              isA<
                new_auth_idp.EmailAuthenticationInvalidCredentialsException
              >(),
            ),
          );
        },
      );

      test(
        'when reading the profile, then it matches the original user info.',
        () async {
          const userProfiles = new_auth_profile.UserProfiles();
          final profile = await userProfiles.findUserProfileByUserId(
            session,
            authUserId,
          );

          expect(profile.email, userInfo.email);
          expect(profile.userName, userInfo.userName);
          expect(profile.fullName, userInfo.fullName);
          expect(profile.email, email.toLowerCase());
        },
      );
    },
  );
}

Future<legacy_auth.UserInfo> _createLegacyUser(
  final Session session, {
  required final String email,
  required final String password,
  final String userName = 'user name',
}) async {
  return (await legacy_auth.Emails.createUser(
    session,
    userName,
    // at this point `Emails` already expect lower-case addresses
    email.toLowerCase(),
    password,
  ))!;
}
