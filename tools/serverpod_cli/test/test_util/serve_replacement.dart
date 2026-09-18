import 'dart:io';

import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:test/test.dart';

import 'fake_runner_api.dart';

/// Serves [runner] at the attach socket of the closed server in [tempDir], as
/// a restarted runner would, until teardown.
Future<void> serveReplacement(Directory tempDir, FakeRunnerApi runner) async {
  final restarted = RunnerSocketServer(serverDir: tempDir.path);
  await restarted.start();
  addTearDown(restarted.close);
  addTearDown(runner.eventController.close);
  restarted.connect(runner);
}
