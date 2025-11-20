import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart' as new_auth_core;
import 'package:serverpod_auth_idp_server/providers/email.dart'
    as new_email_idp;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerFactory =
      new_auth_core.ServerSideSessionsTokenManagerFactory(
        new_auth_core.ServerSideSessionsConfig(
          sessionKeyHashPepper: 'test-pepper',
        ),
      );

  const newEmailIdpConfig = new_email_idp.EmailIdpConfig(
    secretHashPepper: 'test',
  );
  late final new_email_idp.EmailIdp newEmailIdp;

  setUpAll(() async {
    new_auth_core.AuthServices.set(
      identityProviders: [
        new_email_idp.EmailIdentityProviderFactory(newEmailIdpConfig),
      ],
      tokenManagers: [tokenManagerFactory],
    );
    newEmailIdp = new_auth_core.AuthServices.instance.emailIdp;
    AuthMigrations.config = AuthMigrationConfig(emailIdp: newEmailIdp);
  });

  tearDownAll(() async {
    new_auth_core.AuthServices.set(
      identityProviders: [],
      tokenManagers: [tokenManagerFactory],
    );
  });
  withServerpod(
    'Given a legacy `serverpod_auth` email-based user account migrated with `migrateUsers`,',
    (final sessionBuilder, final endpoints) {
      const email = 'User@serverpod.DEV';
      const password = 'Somepassword123!';

      late Session session;

      final migratedUsers = <int, UuidValue>{};

      setUp(() async {
        session = sessionBuilder.build();

        await legacy_auth.Emails.createUser(
          session,
          'user name',
          // at this point `Emails` already expect lower-case addresses
          email.toLowerCase(),
          password,
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
                assert(migratedUsers[oldUserId] == null);
                migratedUsers[oldUserId] = newAuthUserId;
              },
          transaction: session.transaction,
        );
      });

      tearDown(() {
        migratedUsers.clear();
      });

      test(
        'when calling `EmailAccounts.authenticate`, then it fails due to no password being set.',
        () async {
          await expectLater(
            newEmailIdp.utils.authentication.authenticate(
              session,
              email: email,
              password: password,
              transaction: null,
            ),
            throwsA(
              isA<
                new_email_idp.EmailAuthenticationInvalidCredentialsException
              >(),
            ),
          );
        },
      );

      test(
        'when calling `EmailAccounts.authenticate` after `AuthBackwardsCompatibility.importLegacyPasswordIfNeeded`, then it succeeds.',
        () async {
          await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: email,
            password: password,
          );

          expect(
            await newEmailIdp.utils.authentication.authenticate(
              session,
              email: email,
              password: password,
              transaction: null,
            ),
            migratedUsers.values.single,
          );
        },
      );
    },
  );
}
