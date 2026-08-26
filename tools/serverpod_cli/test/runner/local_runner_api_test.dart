import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/runner/local_runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:test/test.dart';

void main() {
  group('Given a runner that has not been handed a stack yet,', () {
    late StartLogHistory history;
    late LocalRunnerApi api;
    var shutdowns = 0;

    setUp(() {
      shutdowns = 0;
      history = StartLogHistory();
      api = LocalRunnerApi(
        logHistory: history,
        requestShutdown: () => shutdowns++,
        watchModeEnabled: true,
      );
    });

    tearDown(() async => api.close());

    test(
      'when it is asked what it is doing, '
      'then it reports the starting stage rather than a running stack',
      () {
        expect(api.stage, RunnerStage.starting);
        expect(api.isRunning, isFalse);
        expect(api.canLaunchFlutterApps, isFalse);
        expect(api.flutterApps, isEmpty);
      },
    );

    test(
      'when two surfaces listen to its events, '
      'then both receive them, as several clients may attach at once',
      () async {
        final first = <RunnerEvent>[];
        final second = <RunnerEvent>[];
        final events = api.events;
        final firstSub = events.listen(first.add);
        final secondSub = events.listen(second.add);
        addTearDown(() async {
          await firstSub.cancel();
          await secondSub.cancel();
        });

        api.setStage(RunnerStage.running);
        await pumpEventQueue();

        expect(first, hasLength(1));
        expect(second, hasLength(1));
      },
    );

    test(
      'when the running stage is announced before the stack is bound, '
      'then the event says the server is running, as the stage does',
      () async {
        final events = <RunnerEvent>[];
        final sub = api.events.listen(events.add);
        addTearDown(sub.cancel);

        api.setStage(RunnerStage.running);
        await pumpEventQueue();

        final stage = events.single as StageChangedEvent;
        expect(stage.stage, RunnerStage.running);
        expect(stage.isRunning, isTrue);
      },
    );

    test(
      'when the runner was started in watch mode, '
      'then a client attaching before the stack is up is told so',
      () {
        expect(api.snapshot().watchModeEnabled, isTrue);
      },
    );

    test(
      'when a command needing the stack is issued, '
      'then it reports that the runner is still starting',
      () {
        expect(
          api.hotReload,
          throwsA(isA<RunnerStartingException>()),
        );
        expect(
          api.applyMigrations,
          throwsA(isA<RunnerStartingException>()),
        );
        expect(
          () => api.launchFlutterApp('admin'),
          throwsA(isA<RunnerStartingException>()),
        );
      },
    );

    test(
      'when stopping is asked for, '
      'then it works, because a start going nowhere is what one abandons',
      () async {
        await api.stop();

        expect(shutdowns, 1);
      },
    );

    test(
      'when the log history fills before the stack exists, '
      'then a snapshot carries it',
      () {
        history.addServerLine('Generating code...');

        expect(api.snapshot().serverLines, contains('Generating code...'));
      },
    );
  });

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
