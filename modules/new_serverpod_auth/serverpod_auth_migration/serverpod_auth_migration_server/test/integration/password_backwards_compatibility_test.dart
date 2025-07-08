import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as new_email_account;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
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
          userMigration: (
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
        'when calling `EmailAccounts.login`, then it fails due to no password being set.',
        () async {
          await expectLater(
            new_email_account.EmailAccounts.login(
              session,
              email: email,
              password: password,
            ),
            throwsA(
              isA<new_email_account.EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                new_email_account
                    .EmailAccountLoginFailureReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      test(
        'when calling `EmailAccounts.login` after `AuthBackwardsCompatibility.importLegacyPasswordIfNeeded`, then it succeeds.',
        () async {
          await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: email,
            password: password,
          );

          expect(
            await new_email_account.EmailAccounts.login(
              session,
              email: email,
              password: password,
            ),
            migratedUsers.values.single,
          );
        },
      );
    },
  );
}
