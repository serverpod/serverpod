import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart' as auth_next;
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
        'when calling `EmailAccounts.authenticate`, then it fails due to no password being set.',
        () async {
          await expectLater(
            auth_next.EmailAccounts.authenticate(
              session,
              email: email,
              password: password,
            ),
            throwsA(isA<
                auth_next.EmailAuthenticationInvalidCredentialsException>()),
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
            await auth_next.EmailAccounts.authenticate(
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
