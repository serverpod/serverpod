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
import '../../test_util/short_temp_dir.dart';
import '../../test_util/wait_for.dart';

void main() {
  group('Given a UI attached while the runner is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi startingRunner;
    late _CapturingHolder holder;
    late RunnerClient client;

    setUp(() async {
      tempDir = await createShortTempDir('rsb');
      server = RunnerSocketServer(serverDir: tempDir.path);
      await server.start();
      startingRunner = FakeRunnerApi()
        ..stage = RunnerStage.starting
        ..isRunning = false;
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
      'when an app starts launching while the launch panel is showing, '
      'then its log tab takes focus',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);
        startingRunner
          ..flutterAppIds = ['admin']
          ..emit(FlutterAppsChangedEvent(startingRunner.flutterApps));
        await waitFor(() => holder.state.canLaunchApps);
        holder.state.showLaunchPanel = true;

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: false,
            launching: true,
          ),
        );

        await waitFor(() {
          final focused = holder.state.tabs.focusedTab;
          return focused is AppLogTab && focused.appId == 'admin';
        });
      },
    );

    test(
      'when the runner reports its apps before its stack is up, '
      'then the launch panel is offered for them',
      () async {
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        expect(holder.state.canLaunchApps, isFalse);

        startingRunner
          ..flutterAppIds = ['admin']
          ..emit(FlutterAppsChangedEvent(startingRunner.flutterApps));

        await waitFor(() => holder.state.canLaunchApps);
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
            exitCode: 3,
          ),
        );
        await waitFor(() => exitCode != null);

        expect(exitCode, 3);
      },
    );

    test(
      'when the UI asks to stop the stack, '
      'then it leaves with the code the runner announces, not at once',
      () async {
        var leftOnItsOwn = false;
        int? exitCode;
        startingRunner.onStop = () async {
          startingRunner.emit(
            const StageChangedEvent(RunnerStage.stopping, exitCode: 3),
          );
        };
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () => leftOnItsOwn = true,
          onRunnerStopped: (code) => exitCode = code,
        )..bind();
        addTearDown(binding.dispose);

        holder.stopStack!();
        await waitFor(() => exitCode != null);

        expect(exitCode, 3);
        expect(leftOnItsOwn, isFalse);
      },
    );

    test(
      'when the UI asks to stop the stack and the runner refuses, '
      'then it leaves on its own, since no announcement will end the session',
      () async {
        var leftOnItsOwn = false;
        startingRunner.onStop = () async => throw StateError('busy');
        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () => leftOnItsOwn = true,
          onRunnerStopped: (_) => fail('The runner announced nothing.'),
        )..bind();
        addTearDown(binding.dispose);

        holder.stopStack!();
        await waitFor(() => leftOnItsOwn);
      },
    );

    test(
      'when the runner was already stopping when the UI attached, '
      'then the UI is asked to leave with the code the stopping runner named',
      () async {
        // The snapshot is the only place a stage set before this client
        // subscribed can come from: the event stream does not replay.
        final stoppingRunner = FakeRunnerApi()
          ..stage = RunnerStage.stopping
          ..isRunning = false
          ..exitCode = 3;
        server.connect(stoppingRunner);
        final lateClient = RunnerClient(
          socketPath: server.socketPath,
          history: holder.state.history,
        );
        await lateClient.attach();
        addTearDown(lateClient.close);

        int? exitCode;
        final binding = RunnerStateBinding(
          client: lateClient,
          holder: holder,
          onStopRequested: () {},
          onRunnerStopped: (code) => exitCode = code,
        )..bind();
        addTearDown(binding.dispose);

        await waitFor(() => exitCode != null);
        expect(exitCode, 3);
      },
    );

    test(
      'when an app is still launching and the UI asks to stop it, '
      'then the stop reaches the runner, the key being offered while launching',
      () async {
        final stopped = <String>[];
        startingRunner.onStopFlutterApp = (id) async => stopped.add(id);
        startingRunner
          ..flutterAppIds = ['admin']
          ..emit(const StageChangedEvent(RunnerStage.running))
          ..emit(FlutterAppsChangedEvent(startingRunner.flutterApps))
          ..emit(
            const FlutterAppStateEvent(
              appId: 'admin',
              running: false,
              launching: true,
            ),
          );
        await waitFor(() => client.isFlutterAppLaunching('admin'));

        final binding = RunnerStateBinding(
          client: client,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        holder.stopApp!(0);

        await waitFor(() => stopped.isNotEmpty);
        expect(stopped, ['admin']);
      },
    );

    test(
      'when a migration is created, '
      'then its outcome is reported',
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

        await waitFor(
          () => writer.entries.any(
            (e) => e.message.contains('Server migration skipped.'),
          ),
        );
      },
    );

    test(
      'when the client reconnects to a runner whose app has stopped, '
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
        await waitFor(() => _appTab(holder)?.ready ?? false);

        await server.close();
        final restarted = RunnerSocketServer(serverDir: tempDir.path);
        await restarted.start();
        addTearDown(restarted.close);
        final restartedRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin'];
        addTearDown(restartedRunner.eventController.close);
        restarted.connect(restartedRunner);

        await waitFor(() => _appTab(holder)?.stopped ?? false);
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
        final lateClient = RunnerClient(
          socketPath: server.socketPath,
          history: holder.state.history,
        );
        await lateClient.attach();
        addTearDown(lateClient.close);

        final binding = RunnerStateBinding(
          client: lateClient,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        await waitFor(() => _appTab(holder)?.ready ?? false);
        expect(_appTab(holder)!.url, 'http://localhost:5000');
      },
    );

    test(
      'when a client attaches to a stack whose app is already running, '
      'then its tab opens on what the app has printed',
      () async {
        final runningRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin']
          ..runningFlutterApps = {'admin'}
          ..flutterLogs = {
            'admin': ['Launching lib/main.dart on Chrome...'],
          };
        addTearDown(runningRunner.eventController.close);
        server.connect(runningRunner);
        final late = _CapturingHolder(ServerWatchState());
        final lateClient = RunnerClient(
          socketPath: server.socketPath,
          history: late.state.history,
        );
        await lateClient.attach();
        addTearDown(lateClient.close);

        final binding = RunnerStateBinding(
          client: lateClient,
          holder: late,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        await waitFor(() => _appTab(late)?.ready ?? false);
        expect(_appTab(late)!.logHistory, [
          'Launching lib/main.dart on Chrome...',
        ]);
      },
    );

    test(
      'when a snapshot names an app that never ran, '
      'then no tab is opened for it',
      () async {
        final idleRunner = FakeRunnerApi()
          ..stage = RunnerStage.running
          ..flutterAppIds = ['admin'];
        addTearDown(idleRunner.eventController.close);
        server.connect(idleRunner);
        final lateClient = RunnerClient(
          socketPath: server.socketPath,
          history: holder.state.history,
        );
        await lateClient.attach();
        addTearDown(lateClient.close);

        final binding = RunnerStateBinding(
          client: lateClient,
          holder: holder,
          onStopRequested: () {},
        )..bind();
        addTearDown(binding.dispose);

        await waitFor(() => holder.state.launchableApps.isNotEmpty);
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

        await waitFor(() => _appTab(holder) != null);
        expect(_appTab(holder)!.runState, AppRunState.launching);

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: false,
            launching: true,
            launchStage: 'Running pub get',
          ),
        );

        await waitFor(() => _appTab(holder)!.startupStage != null);
        expect(_appTab(holder)!.startupStage, 'Running pub get');

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: true,
            launching: false,
            url: 'http://localhost:5000',
          ),
        );

        await waitFor(() => _appTab(holder)?.ready ?? false);
        expect(_appTab(holder)!.runState, AppRunState.ready);

        startingRunner.emit(
          const FlutterAppStateEvent(
            appId: 'admin',
            running: false,
            launching: false,
          ),
        );

        await waitFor(() => _appTab(holder)?.stopped ?? false);
        expect(_appTab(holder)!.runState, AppRunState.stopped);
      },
    );
  });
}

/// A holder that keeps the migration binding reachable.
///
/// The production holder only takes callbacks, and the UI is what calls them.
/// A test that exercises one has to hold on to it as it is bound.
class _CapturingHolder extends StartAppStateHolder {
  _CapturingHolder(super.state);

  /// What the binding wired the Migrate key to.
  void Function({bool force})? createMigration;

  /// What the binding wired the Stop App key to.
  void Function(int index)? stopApp;

  /// What the binding wired the Stop Stack key to.
  void Function()? stopStack;

  @override
  set onStopStack(void Function()? cb) {
    stopStack = cb;
    super.onStopStack = cb;
  }

  @override
  set onStopApp(void Function(int index)? cb) {
    stopApp = cb;
    super.onStopApp = cb;
  }

  @override
  set onCreateMigration(void Function({bool force})? cb) {
    createMigration = cb;
    super.onCreateMigration = cb;
  }
}

/// The Flutter app tab for `admin`, or null before it is opened.
AppLogTab? _appTab(StartAppStateHolder holder) =>
    holder.state.appLogTabFor('admin');
