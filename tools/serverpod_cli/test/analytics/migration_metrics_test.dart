import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/migration_metrics.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:test/test.dart';

void main() {
  group('Given migration outcomes, ', () {
    test(
      'when only a server migration is created, '
      'then the client flag is false.',
      () {
        final flags = MigrationCreatedFlags.fromOutcome(
          const CreateMigrationCreated(
            versionName: '20260101120000000',
            migrationDirectory:
                '/tmp/myapp_server/migrations/20260101120000000',
          ),
        );

        expect(flags.serverMigrationCreated, isTrue);
        expect(flags.clientMigrationCreated, isFalse);
      },
    );

    test(
      'when a client migration path is used, '
      'then the client flag is true.',
      () {
        final flags = MigrationCreatedFlags.fromOutcome(
          CreateMigrationCreated(
            versionName: '20260101120000000',
            migrationDirectory: p.join(
              'myapp_client',
              'lib',
              'migrations',
              '20260101120000000',
            ),
          ),
        );

        expect(flags.serverMigrationCreated, isFalse);
        expect(flags.clientMigrationCreated, isTrue);
      },
    );
  });
}
