import 'dart:io';

import 'package:serverpod_cli/src/commands/attach/state_binding.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:test/test.dart';

import '../../test_util/fake_runner_api.dart';

void main() {
  group('Given a UI attached while the runner is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi startingRunner;
    late StartAppStateHolder holder;
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

      holder = StartAppStateHolder(ServerWatchState());
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
  });
}

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
