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
import '../../test_util/short_temp_dir.dart';
import '../../test_util/wait_for.dart';

void main() {
  group('Given a UI attached while the runner is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer server;
    late FakeRunnerApi startingRunner;
    late StartAppStateHolder holder;
    late RunnerClient client;

    setUp(() async {
      tempDir = await createShortTempDir('rsb');
      server = RunnerSocketServer(serverDir: tempDir.path);
      await server.start();
      startingRunner = FakeRunnerApi()
        ..stage = RunnerStage.starting
        ..isRunning = false;
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
  });
}
