import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart' show ExitException;
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart' show TestLogWriter;
import 'package:test/test.dart';

void main() {
  group('Given a runner that has published but is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer socket;
    late RunnerManifest starting;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rsu');
      socket = RunnerSocketServer(serverDir: tempDir.path);
      await socket.start();
      starting = RunnerManifest(
        pid: 4242,
        stage: RunnerStage.starting,
        sockets: RunnerSockets(tui: socket.socketPath, mcp: ''),
        config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
      );
      await starting.writeTo(tempDir.path);
      initializeLoggerWith(ServerpodCliLogger(TestLogWriter()));
      addTearDown(closeLogger);
    });

    tearDown(() async {
      await socket.close();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when the stage moves on, '
      'then a caller that does not attach gets the manifest that says so',
      () async {
        final up = awaitStackUp(tempDir.path, starting);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await starting
            .copyWith(stage: RunnerStage.running)
            .writeTo(
              tempDir.path,
            );

        expect((await up).stage, RunnerStage.running);
      },
    );

    test(
      'when the runner aborts and leaves its manifest behind, '
      'then the caller leaves with the code the runner named',
      () async {
        final up = awaitStackUp(tempDir.path, starting);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await starting
            .copyWith(stage: RunnerStage.stopping, exitCode: 3)
            .writeTo(tempDir.path);
        await socket.close();

        await expectLater(
          up,
          throwsA(
            isA<ExitException>().having((e) => e.exitCode, 'exitCode', 3),
          ),
        );
      },
    );

    test(
      'when the runner is degraded, '
      'then reporting it ready fails, since the stack is not up',
      () {
        expect(
          () => reportRunnerReady(
            starting.copyWith(stage: RunnerStage.degraded),
          ),
          throwsA(isA<ExitException>()),
        );
      },
    );
  });

  group('Given a StartCommand,', () {
    late StartCommand command;

    setUp(() {
      command = StartCommand();
    });

    test(
      'when resolving configuration with passthrough args after --, '
      'then it succeeds without errors.',
      () {
        final argResults = command.argParser.parse(
          ['--', '--apply-migrations'],
        );

        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      },
    );

    test(
      'when resolving configuration with passthrough args after --, '
      'then passthrough args are in argResults.rest.',
      () {
        final argResults = command.argParser.parse(
          ['--', '--apply-migrations', '--mode', 'production'],
        );

        expect(argResults.rest, ['--apply-migrations', '--mode', 'production']);
      },
    );

    test(
      'when resolving configuration without --docker, '
      'then the docker flag is unset.',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse([]),
        );

        expect(config.optionalValue(StartOption.docker), isNull);
      },
    );

    test(
      'when resolving configuration without --attach, '
      'then attaching is on, so `serverpod start` still shows the stack',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse([]),
        );

        expect(config.value(StartOption.attach), isTrue);
      },
    );

    test(
      'when resolving configuration with --no-attach, '
      'then attaching is off, which is the path an agent takes',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--no-attach']),
        );

        expect(config.value(StartOption.attach), isFalse);
      },
    );

    test(
      'when resolving configuration with --docker, '
      'then the docker flag is true',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--docker']),
        );

        expect(config.optionalValue(StartOption.docker), isTrue);
      },
    );

    test(
      'when resolving configuration with --no-docker, '
      'then the docker flag is false.',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--no-docker']),
        );

        expect(config.optionalValue(StartOption.docker), isFalse);
      },
    );
  });
}
