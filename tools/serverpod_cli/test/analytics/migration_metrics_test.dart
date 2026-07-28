import 'package:serverpod_cli/src/analytics/migration_metrics.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:test/test.dart';

const _created = CreateMigrationCreated(
  versionName: '20260101120000000',
  migrationDirectory: '/tmp/myapp_server/migrations/20260101120000000',
);

void main() {
  test(
    'Given an unwrapped migration outcome, '
    'when its creation flags are derived, '
    'then only the server flag is true.',
    () {
      // `createMigrationAction` only returns a bare outcome when the project
      // has no client-side tables, so it is always the server side.
      final flags = MigrationCreatedFlags.fromOutcome(_created);

      expect(flags.serverMigrationCreated, isTrue);
      expect(flags.clientMigrationCreated, isFalse);
    },
  );

  test(
    'Given an outcome with server and client migrations, '
    'when its creation flags are derived, '
    'then both flags are true.',
    () {
      final flags = MigrationCreatedFlags.fromOutcome(
        const CreateMigrationServerClientCreated(
          serverResult: _created,
          clientResult: _created,
        ),
      );

      expect(flags.serverMigrationCreated, isTrue);
      expect(flags.clientMigrationCreated, isTrue);
    },
  );

  test(
    'Given an outcome where the client side had no changes, '
    'when its creation flags are derived, '
    'then only the server flag is true.',
    () {
      final flags = MigrationCreatedFlags.fromOutcome(
        const CreateMigrationServerClientCreated(
          serverResult: _created,
          clientResult: CreateMigrationNoChanges(),
        ),
      );

      expect(flags.serverMigrationCreated, isTrue);
      expect(flags.clientMigrationCreated, isFalse);
    },
  );

  test(
    'Given outcomes where nothing was written, '
    'when their creation flags are derived, '
    'then no flag is true.',
    () {
      for (final outcome in const <CreateMigrationOutcome>[
        CreateMigrationNoChanges(),
        CreateMigrationAborted(),
        CreateMigrationFailed('boom'),
      ]) {
        final flags = MigrationCreatedFlags.fromOutcome(outcome);

        expect(flags.serverMigrationCreated, isFalse, reason: '$outcome');
        expect(flags.clientMigrationCreated, isFalse, reason: '$outcome');
      }
    },
  );
}
