import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/runner/local_runner_api.dart';
import 'package:test/test.dart';

void main() {
  group('Given a create-migration outcome,', () {
    test(
      'when a migration was created, '
      'then the result names the version and reports it as created',
      () {
        final result = migrationResultFor(
          const CreateMigrationCreated(
            versionName: '20260825120000',
            migrationDirectory: '/tmp/migrations/20260825120000',
          ),
        );

        expect(result.isError, isFalse);
        expect(result.created, isTrue);
        expect(result.abortedForWarnings, isFalse);
        expect(result.message, contains('20260825120000'));
        expect(result.message, contains('/tmp/migrations/20260825120000'));
      },
    );

    test(
      'when no changes were detected, '
      'then the result is a non-error that created nothing',
      () {
        final result = migrationResultFor(const CreateMigrationNoChanges());

        expect(result.isError, isFalse);
        expect(result.created, isFalse);
        expect(result.abortedForWarnings, isFalse);
        expect(result.message, contains('No changes detected'));
      },
    );

    test(
      'when the migration was aborted over warnings, '
      'then the result is an error flagged as retryable with force',
      () {
        final result = migrationResultFor(const CreateMigrationAborted());

        expect(result.isError, isTrue);
        expect(result.abortedForWarnings, isTrue);
        expect(result.created, isFalse);
      },
    );

    test(
      'when the migration failed for another reason, '
      'then the result is an error that force would not fix',
      () {
        final result = migrationResultFor(
          const CreateMigrationFailed('Database feature is not enabled.'),
        );

        expect(result.isError, isTrue);
        expect(result.abortedForWarnings, isFalse);
        expect(result.message, 'Database feature is not enabled.');
      },
    );

    test(
      'when the message would carry a retry hint, '
      'then it does not, so each surface can word its own',
      () {
        final result = migrationResultFor(const CreateMigrationAborted());

        expect(result.message, isNot(contains('force')));
        expect(result.message, isNot(contains('⇧')));
      },
    );
  });

  group('Given a combined server and client create-migration outcome,', () {
    test(
      'when both were created, '
      'then the result reports both and is not an error',
      () {
        final result = migrationResultFor(
          const CreateMigrationServerClientCreated(
            serverResult: CreateMigrationCreated(
              versionName: 'server-v1',
              migrationDirectory: '/tmp/server',
            ),
            clientResult: CreateMigrationCreated(
              versionName: 'client-v1',
              migrationDirectory: '/tmp/client',
            ),
          ),
        );

        expect(result.isError, isFalse);
        expect(result.created, isTrue);
        expect(result.message, contains('server-v1'));
        expect(result.message, contains('client-v1'));
      },
    );

    test(
      'when only the client half aborted over warnings, '
      'then the combined result is a retryable error',
      () {
        final result = migrationResultFor(
          const CreateMigrationServerClientCreated(
            serverResult: CreateMigrationCreated(
              versionName: 'server-v1',
              migrationDirectory: '/tmp/server',
            ),
            clientResult: CreateMigrationAborted(),
          ),
        );

        expect(result.isError, isTrue);
        expect(result.abortedForWarnings, isTrue);
      },
    );

    test(
      'when the server half aborted over warnings, '
      'then nothing is reported as created, since there is nothing to apply',
      () {
        final result = migrationResultFor(
          const CreateMigrationServerClientCreated(
            serverResult: CreateMigrationAborted(),
            clientResult: CreateMigrationCreated(
              versionName: 'client-v1',
              migrationDirectory: '/tmp/client',
            ),
          ),
        );

        expect(result.isError, isTrue);
        expect(result.abortedForWarnings, isTrue);
        expect(result.created, isFalse);
      },
    );

    test(
      'when the server half was created and the client had no changes, '
      'then the result still reports something to apply',
      () {
        final result = migrationResultFor(
          const CreateMigrationServerClientCreated(
            serverResult: CreateMigrationCreated(
              versionName: 'server-v1',
              migrationDirectory: '/tmp/server',
            ),
            clientResult: CreateMigrationNoChanges(),
          ),
        );

        expect(result.isError, isFalse);
        expect(result.created, isTrue);
      },
    );

    test(
      'when only the client half failed for another reason, '
      'then the combined result is an error that force would not fix',
      () {
        final result = migrationResultFor(
          const CreateMigrationServerClientCreated(
            serverResult: CreateMigrationNoChanges(),
            clientResult: CreateMigrationFailed('Client generation failed.'),
          ),
        );

        expect(result.isError, isTrue);
        expect(result.abortedForWarnings, isFalse);
        expect(result.message, contains('Client generation failed.'));
      },
    );
  });
}
