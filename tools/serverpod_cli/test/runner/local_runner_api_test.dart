import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/runner/local_runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';

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
        runMode: 'development',
      );
    });

    tearDown(() async => api.close());

    test(
      'when it is asked what it is doing, '
      'then it reports the starting stage rather than a running stack',
      () {
        expect(api.stage, RunnerStage.starting);
        expect(api.isRunning, isFalse);
        expect(api.flutterApps, isEmpty);
      },
    );

    test(
      'when it runs in development, '
      'then it reports Flutter apps as launchable before the stack is up',
      () {
        expect(api.canLaunchFlutterApps, isTrue);
      },
    );

    test(
      'when it runs outside development, '
      'then it reports Flutter apps as not launchable',
      () {
        final production = LocalRunnerApi(
          logHistory: StartLogHistory(),
          requestShutdown: () {},
          watchModeEnabled: true,
          runMode: 'production',
        );
        addTearDown(production.close);

        expect(production.canLaunchFlutterApps, isFalse);
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
      'when a migration is asked for, '
      'then it answers with a failed result rather than throwing',
      () async {
        expect((await api.createMigration()).isError, isTrue);
        expect((await api.createRepairMigration()).isError, isTrue);
      },
    );

    test(
      'when stopping is announced twice and the second names an exit code, '
      'then the exit code is still published, a client having no other source',
      () async {
        final events = <RunnerEvent>[];
        final sub = api.events.listen(events.add);
        addTearDown(sub.cancel);

        api.setStage(RunnerStage.stopping);
        api.setStage(RunnerStage.stopping, exitCode: 2);
        await pumpEventQueue();

        expect(events.whereType<StageChangedEvent>().last.exitCode, 2);
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
      'when the migration was aborted over warnings, '
      'then the message carries no retry hint',
      () {
        final result = migrationResultFor(const CreateMigrationAborted());

        expect(result.message, isNot(contains('force')));
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

  group('Given a runner whose Flutter app is between spawn and ready,', () {
    late Directory tempDir;
    late FlutterAppManager manager;
    late LocalRunnerApi api;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('lra_launch');
      final serverDir = Directory(p.join(tempDir.path, 'project_server'))
        ..createSync(recursive: true);
      Directory(p.join(tempDir.path, 'app_flutter')).createSync();
      File(
        p.join(tempDir.path, 'app_flutter', 'pubspec.yaml'),
      ).writeAsStringSync(
        'name: app\ndependencies:\n  flutter:\n    sdk: flutter\n',
      );
      final serverPubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'))
        ..writeAsStringSync(
          'name: server\nserverpod:\n  flutter_apps:\n    app:\n      path: ../app_flutter\n',
        );
      manager = FlutterAppManager(
        projectName: 'project',
        autoLaunchArmed: false,
        serverPubspecFile: serverPubspecFile,
        serverPackageDirectoryPathParts: p.split(serverDir.path),
        serverpodToolDir: p.join(tempDir.path, '.serverpod'),
        runMode: 'development',
        onReady: (_, _) {},
        onStart: (_, _) async {},
        onStop: (_) {},
        onLaunchFailed: (_) {},
        onLog: (_, _) {},
        stdoutSinkFor: (_) => stdout,
        stderrSinkFor: (_) => stderr,
      );
      await manager.initialize();
      manager.setProcessForTesting('app', _SpawnedFlutter());

      api = LocalRunnerApi(
        logHistory: StartLogHistory(),
        requestShutdown: () {},
        watchModeEnabled: true,
        runMode: 'development',
      );
      api.bindStack(
        session: _UnusedSession(),
        flutterManager: manager,
        config: GeneratorConfigBuilder().build(),
        vmServiceUri: () => null,
      );
    });

    tearDown(() async {
      await api.close();
      await manager.dispose();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when the toolchain reports progress, '
      'then the app is announced as launching, not running',
      () async {
        final events = <RunnerEvent>[];
        final sub = api.events.listen(events.add);
        addTearDown(sub.cancel);

        api.recordFlutterAppState('app', launchStage: 'compiling');
        await pumpEventQueue();

        final state = events.whereType<FlutterAppStateEvent>().single;
        expect(state.launching, isTrue);
        expect(state.running, isFalse);
        expect(state.launchStage, 'compiling');
      },
    );

    test(
      'when a client attaches mid-build, '
      'then the snapshot lists the app as launching, not running',
      () {
        final snapshot = api.snapshot();

        expect(snapshot.launchingFlutterApps, {'app'});
        expect(snapshot.runningFlutterApps, isEmpty);
      },
    );
  });
}

/// A Flutter process that has been spawned but has not signalled ready.
class _SpawnedFlutter extends Fake implements FlutterProcess {
  @override
  bool get isRunning => true;

  @override
  String? get flutterAppUrl => null;

  @override
  Future<int> stop({Duration timeout = const Duration(seconds: 5)}) async => 0;
}

/// Bound only to satisfy [LocalRunnerApi.bindStack]; nothing here reaches it.
class _UnusedSession extends Fake implements WatchSession {
  @override
  bool get isRunning => false;

  @override
  bool get isFlutterAppRunning => false;

  @override
  Stream<void> get vmServiceUriChanges => const Stream.empty();
}
