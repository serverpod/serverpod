import 'dart:io';

import 'package:serverpod_cli/src/commands/attach/state_binding.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart' show TestLogWriter;
import 'package:test/test.dart';

import '../../test_util/fake_runner_api.dart';

void main() {
  group('Given a UI attached while the runner is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi startingRunner;
    late _CapturingHolder holder;
    late RunnerClient client;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rsb');
      server = RunnerSocketServer(serverDir: tempDir.path);
      await server.start();
      startingRunner = FakeRunnerApi()
        ..stage = RunnerStage.starting
        ..isRunning = false
        ..canLaunchFlutterApps = false;
      server.connect(startingRunner);

      holder = _CapturingHolder(ServerWatchState());
      client = RunnerClient(
        socketPath: server.socketPath,
        history: holder.state.history,
      );
      await client.attach();
      addTearDown(client.close);
    });

    tearDown(() async {
      await server.close();
      if (!startingRunner.eventController.isClosed) {
        await startingRunner.eventController.close();
      }
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when the stack comes up and the runner is swapped, '
      'then the launch panel is offered for the apps it reports',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        expect(holder.state.canLaunchApps, isFalse);

        final startedRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..canLaunchFlutterApps = true
          ..flutterAppIds = ['admin'];
        addTearDown(startedRunner.eventController.close);
        server.connect(startedRunner);
        startedRunner.emit(
          FlutterAppsChangedEvent(startedRunner.flutterApps),
        );

        await _waitFor(() => holder.state.canLaunchApps);
        expect(holder.state.launchableApps.single.id, 'admin');
      },
    );

    test(
      'when the runner announces it is stopping, '
      'then the UI is asked to leave with the exit code it named',
      () async {
        int? exitCode;
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
          onRunnerStopped: (code) => exitCode = code,
        )..bind();
        addTearDown(binding.dispose);

        startingRunner.emit(
          const StageChangedEvent(
            RunnerStage.stopping,
            isRunning: false,
            exitCode: 3,
          ),
        );
        await _waitFor(() => exitCode != null);

        expect(exitCode, 3);
      },
    );

    test(
      'when a migration is created, '
      'then its outcome is reported, so a no-op reads differently from a created migration',
      () async {
        final writer = TestLogWriter();
        initializeLoggerWith(ServerpodCliLogger(writer));
        addTearDown(closeLogger);

        startingRunner.onCreateMigration =
            ({String? tag, bool force = false}) async =>
                const MigrationResult(message: 'Server migration skipped.');

        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        holder.state.serverReady = true;
        holder.createMigration!();

        await _waitFor(
          () => writer.entries.any(
            (e) => e.message.contains('Server migration skipped.'),
          ),
        );
      },
    );

    test(
      'when a snapshot arrives for an app that has stopped, '
      'then its tab is corrected rather than left reading ready',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        startingRunner
          ..flutterAppIds = ['admin']
          ..emit(FlutterAppsChangedEvent(startingRunner.flutterApps))
          ..emit(
            const FlutterAppStateEvent(
              appId: 'admin',
              running: true,
              launching: false,
              url: 'http://localhost:5000',
            ),
          );
        await _waitFor(() => _appTab(holder)?.ready ?? false);

        final restartedRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin'];
        addTearDown(restartedRunner.eventController.close);
        server.connect(restartedRunner);

        await _waitFor(() => _appTab(holder)?.stopped ?? false);
        expect(_appTab(holder)!.url, isNull);
      },
    );

    test(
      'when a client attaches to a stack whose app is already running, '
      'then the snapshot tells it where the app is serving',
      () async {
        final runningRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin']
          ..runningFlutterApps = {'admin'}
          ..flutterAppUrls = {'admin': 'http://localhost:5000'};
        addTearDown(runningRunner.eventController.close);
        server.connect(runningRunner);

        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        await _waitFor(() => _appTab(holder)?.ready ?? false);
        expect(_appTab(holder)!.url, 'http://localhost:5000');
      },
    );

    test(
      'when a snapshot names an app that never ran, '
      'then no tab is opened for it',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        final idleRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin'];
        addTearDown(idleRunner.eventController.close);
        server.connect(idleRunner);

        await _waitFor(() => holder.state.launchableApps.isNotEmpty);
        expect(_appTab(holder), isNull);
      },
    );

    test(
      'when an app is launching, '
      'then its tab reads as launching rather than as stopped',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        startingRunner
          ..flutterAppIds = ['admin']
          ..emit(FlutterAppsChangedEvent(startingRunner.flutterApps))
          ..emit(
            const FlutterAppStateEvent(
              appId: 'admin',
              running: false,
              launching: true,
            ),
          );

        await _waitFor(() => _appTab(holder) != null);
        expect(_appTab(holder)!.runState, AppRunState.launching);

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: false,
            launching: true,
            launchStage: 'Running pub get',
          ),
        );

        await _waitFor(() => _appTab(holder)!.startupStage != null);
        expect(_appTab(holder)!.startupStage, 'Running pub get');

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: true,
            launching: false,
            url: 'http://localhost:5000',
          ),
        );

        await _waitFor(() => _appTab(holder)?.ready ?? false);
        expect(_appTab(holder)!.runState, AppRunState.ready);

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: false,
            launching: false,
          ),
        );

        await _waitFor(() => _appTab(holder)?.stopped ?? false);
        expect(_appTab(holder)!.runState, AppRunState.stopped);
      },
    );
  });
}

/// A holder that keeps the migration binding reachable.
///
/// The production holder only takes callbacks - the UI is what calls them -
/// so a test that exercises one has to hold on to it as it is bound.
class _CapturingHolder extends StartAppStateHolder {
  _CapturingHolder(super.state);

  /// What the binding wired the Migrate key to.
  void Function({bool force})? createMigration;

  @override
  set onCreateMigration(void Function({bool force})? cb) {
    createMigration = cb;
    super.onCreateMigration = cb;
  }
}

/// The Flutter app tab for `admin`, or null before it is opened.
AppLogTab? _appTab(StartAppStateHolder holder) =>
    holder.state.appLogTabFor('admin');

/// Polls [condition] until it holds.
///
/// State crosses a real socket here, so how many event-loop turns it takes is
/// not something a test can assume - `pumpEventQueue` is not a barrier for
/// pending I/O.
Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
