import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart' show ExitException;
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart'
    show RunnerUnreachableException;
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart' show TestLogWriter;
import 'package:serverpod_shared/serverpod_shared.dart' show ServerpodAddresses;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/hold_lock.dart';
import '../test_util/short_temp_dir.dart';

const _asked = RunnerConfig(watch: true, flutter: true, serverArgs: []);

/// A server package beside its client, the shape `GeneratorConfig` expects.
d.DirectoryDescriptor _mockProject() => d.dir('project', [
  d.dir('my_project_server', [
    d.file('pubspec.yaml', '''
name: my_project_server
dependencies:
  serverpod: ^2.0.0
'''),
    d.dir('lib', [
      d.dir('src', [d.dir('protocol', [])]),
    ]),
    d.dir('.dart_tool', [
      d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {"name": "my_project_server", "rootUri": "../", "packageUri": "lib/"},
    {"name": "serverpod", "rootUri": "../../serverpod", "packageUri": "lib/"}
  ]
}
'''),
    ]),
  ]),
  d.dir('my_project_client', [
    d.file('pubspec.yaml', '''
name: my_project_client
dependencies:
  serverpod_client: ^2.0.0
'''),
    d.dir('lib', [
      d.dir('src', [d.dir('protocol', [])]),
    ]),
  ]),
]);

void main() {
  group('Given a runner that has published but is still starting,', () {
    late Directory tempDir;
    late RunnerSocketServer socket;
    late RunnerManifest starting;

    setUp(() async {
      tempDir = await createShortTempDir('rsu');
      socket = RunnerSocketServer(serverDir: tempDir.path);
      await socket.start();
      starting = RunnerManifest(
        pid: 4242,
        stage: RunnerStage.starting,
        projectId: RunnerRegistry.idFor(tempDir.path),
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
      'when the spawned runner is awaited under its own pid, '
      'then it is reported as published',
      () async {
        final outcome = await awaitRunnerManifest(
          tempDir.path,
          pid: 4242,
          timeout: const Duration(seconds: 2),
        );

        expect(outcome, isA<RunnerPublished>());
      },
    );

    test(
      'when another pid published while the spawned runner is awaited, '
      'then it is reported as taken rather than adopted as the spawned one',
      () async {
        final outcome = await awaitRunnerManifest(
          tempDir.path,
          pid: 1,
          timeout: const Duration(seconds: 2),
        );

        expect(outcome, isA<RunnerTaken>());
      },
    );

    test(
      'when a probe fails while the runner still holds its lock, '
      'then the caller keeps waiting, and leaves once the lock is released',
      () async {
        // A POSIX process can retake its own lock, so another process holds it.
        final holder = await holdLockFromAnotherProcess(tempDir.path);
        await socket.close();
        final up = awaitStackUp(tempDir.path, starting);
        var settled = false;
        unawaited(
          up.then((_) => settled = true, onError: (_) => settled = true),
        );

        await Future<void>.delayed(const Duration(milliseconds: 700));
        expect(settled, isFalse);

        holder.kill();
        await expectLater(
          up,
          throwsA(
            isA<ExitException>().having((e) => e.exitCode, 'exitCode', 1),
          ),
        );
      },
    );

    test(
      'when the stage moves on, '
      'then a caller that does not attach gets the manifest that says so',
      () async {
        final up = awaitStackUp(tempDir.path, starting);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await starting
            .copyWith(
              stage: RunnerStage.running,
              servers: const ServerpodAddresses(api: 'http://localhost:8080'),
            )
            .writeTo(tempDir.path);

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

    test(
      'when the runner is running but has not published its addresses, '
      'then a caller that does not attach waits for them',
      () async {
        final up = awaitStackUp(tempDir.path, starting);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await starting
            .copyWith(stage: RunnerStage.running)
            .writeTo(tempDir.path);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await starting
            .copyWith(
              stage: RunnerStage.running,
              servers: const ServerpodAddresses(api: 'http://localhost:8080'),
            )
            .writeTo(tempDir.path);

        expect((await up).servers?.api, 'http://localhost:8080');
      },
    );

    test(
      'when the runner names no address within the deadline, '
      'then the caller gets the manifest as it stands',
      () async {
        await starting
            .copyWith(stage: RunnerStage.running)
            .writeTo(tempDir.path);

        final up = await awaitStackUp(
          tempDir.path,
          starting,
          addressTimeout: const Duration(milliseconds: 600),
        );

        expect(up.stage, RunnerStage.running);
        expect(up.servers, isNull);
      },
    );

    test(
      'when the runner is up with its addresses published, '
      'then reporting it ready prints them',
      () async {
        final writer = TestLogWriter();
        initializeLoggerWith(ServerpodCliLogger(writer));

        reportRunnerReady(
          starting.copyWith(
            stage: RunnerStage.running,
            servers: const ServerpodAddresses(
              api: 'http://localhost:8080',
              web: 'http://localhost:8082',
            ),
          ),
        );
        await log.flush();

        expect(
          writer.entries.map((e) => e.message),
          containsAllInOrder([
            contains('http://localhost:8080'),
            contains('http://localhost:8082'),
          ]),
        );
      },
    );
  });

  group('Given a spawned runner that died before it published,', () {
    late Directory tempDir;
    late int deadPid;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rsd');
      final gone = await Process.start(Platform.resolvedExecutable, [
        '--version',
      ]);
      await gone.exitCode;
      deadPid = gone.pid;
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when it is awaited, '
      'then the wait ends as soon as its pid is gone, not at the deadline',
      () async {
        final watch = Stopwatch()..start();

        final outcome = await awaitRunnerManifest(
          tempDir.path,
          pid: deadPid,
          timeout: const Duration(seconds: 10),
        );

        expect(outcome, isA<RunnerAborted>());
        expect(watch.elapsed, lessThan(const Duration(seconds: 5)));
      },
    );
  });

  group('Given the global options a start command ran with,', () {
    Configuration<GlobalOption> global(List<String> args) =>
        Configuration.resolveNoExcept(options: GlobalOption.values, args: args);

    test(
      'when none were given, '
      'then the spawned runner gets none',
      () {
        expect(runnerServeGlobalArgs(global([])), isEmpty);
      },
    );

    test(
      'when experimental features and verbose were given, '
      'then the spawned runner gets them',
      () {
        expect(
          runnerServeGlobalArgs(
            global(['--verbose', '--experimental-features', 'databaseSync']),
          ),
          ['--verbose', '--experimental-features', 'databaseSync'],
        );
      },
    );

    test(
      'when analytics were turned off, '
      'then the runner is told so, since it records its own command',
      () {
        expect(runnerServeGlobalArgs(global(['--no-analytics'])), [
          '--no-analytics',
        ]);
      },
    );
  });

  group('Given a runner log appended to across runs,', () {
    late Directory tempDir;
    late File logFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rlt');
      logFile = File(serverpodRunnerLogPath(tempDir.path));
      await logFile.create(recursive: true);
      initializeLoggerWith(ServerpodCliLogger(TestLogWriter()));
      addTearDown(closeLogger);
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when the tail is printed from where the file stood at the spawn, '
      'then only the lines of this run are in it',
      () async {
        await logFile.writeAsString('previous run\n');
        final from = logFile.lengthSync();
        await logFile.writeAsString(
          'this run\nfailed\n',
          mode: FileMode.append,
        );

        expect(await printRunnerLogTail(tempDir.path, from: from), [
          'this run',
          'failed',
        ]);
      },
    );

    test(
      'when the file was rotated since the spawn, '
      'then the whole file is the tail',
      () async {
        await logFile.writeAsString('after rotation\n');

        expect(await printRunnerLogTail(tempDir.path, from: 4096), [
          'after rotation',
        ]);
      },
    );
  });

  group('Given a runner that has published that it is stopping,', () {
    late Directory root;
    late String serverDir;
    late RunnerSocketServer socket;
    late GeneratorConfig config;

    setUp(() async {
      // The test sandbox can be too deep for a Unix socket address.
      root = await createShortTempDir('rst');
      await _mockProject().create(root.path);
      serverDir = p.join(root.path, 'project', 'my_project_server');
      socket = RunnerSocketServer(serverDir: serverDir);
      await socket.start();

      await RunnerManifest(
        pid: 4242,
        cliVersion: templateVersion,
        stage: RunnerStage.stopping,
        exitCode: 3,
        projectId: RunnerRegistry.idFor(serverDir),
        config: _asked,
      ).writeTo(serverDir);

      CommandLineExperimentalFeatures.initialize([]);
      config = await GeneratorConfig.load(
        serverRootDir: serverDir,
        interactive: false,
      );
      initializeLoggerWith(ServerpodCliLogger(TestLogWriter()));
      addTearDown(closeLogger);
    });

    tearDown(() async {
      await socket.close();
      try {
        root.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when a caller asks for a runner to attach to, '
      'then it is refused rather than handed the one on its way out',
      () async {
        await expectLater(
          ensureRunner(
            config: config,
            serverDir: serverDir,
            asked: _asked,
            useTui: true,
          ),
          throwsA(isA<ExitException>()),
        );
      },
    );

    test(
      'when its socket is already closed but it still holds the lock, '
      'then a caller is refused rather than spawning one that dies on the lock',
      () async {
        await socket.close();
        await holdLockFromAnotherProcess(serverDir);
        await RunnerManifest(
          pid: 4242,
          cliVersion: templateVersion,
          stage: RunnerStage.stopping,
          projectId: RunnerRegistry.idFor(serverDir),
          config: _asked,
        ).writeTo(serverDir);

        await expectLater(
          ensureRunner(
            config: config,
            serverDir: serverDir,
            asked: _asked,
            useTui: true,
          ),
          throwsA(isA<ExitException>()),
        );
        expect(await RunnerManifest.readFrom(serverDir), isNotNull);
      },
    );
  });

  group('Given a pod started by hand and no runner,', () {
    late Directory root;
    late String serverDir;
    late HttpServer vmService;
    late GeneratorConfig config;

    setUp(() async {
      root = await createShortTempDir('rsh');
      await _mockProject().create(root.path);
      serverDir = p.join(root.path, 'project', 'my_project_server');

      // A websocket that accepts the upgrade passes for a live VM service.
      vmService = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      vmService.listen((request) async {
        final socket = await WebSocketTransformer.upgrade(request);
        socket.listen((_) {});
      });
      await File(userVmServiceInfoPath(serverDir)).create(recursive: true);
      await File(userVmServiceInfoPath(serverDir)).writeAsString(
        jsonEncode({'uri': 'http://127.0.0.1:${vmService.port}/'}),
      );

      CommandLineExperimentalFeatures.initialize([]);
      config = await GeneratorConfig.load(
        serverRootDir: serverDir,
        interactive: false,
      );
      initializeLoggerWith(ServerpodCliLogger(TestLogWriter()));
      addTearDown(closeLogger);
    });

    tearDown(() async {
      await vmService.close(force: true);
      try {
        root.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when a caller asks for a runner, '
      'then it leaves cleanly without spawning one, saying so on this terminal',
      () async {
        await expectLater(
          ensureRunner(
            config: config,
            serverDir: serverDir,
            asked: _asked,
            useTui: true,
          ),
          throwsA(
            isA<ExitException>().having((e) => e.exitCode, 'exitCode', 0),
          ),
        );
        expect(await RunnerManifest.readFrom(serverDir), isNull);
      },
    );
  });

  group('Given the vm service info file a pod leaves behind,', () {
    test(
      'when it records a URI, '
      'then that is the existing server to attach to',
      () {
        expect(
          vmServiceUriFrom('{"uri": "http://127.0.0.1:1234/"}'),
          'http://127.0.0.1:1234/',
        );
      },
    );

    test(
      'when it holds JSON that is not an object, '
      'then it reads as no existing server rather than throwing',
      () {
        expect(vmServiceUriFrom('[]'), isNull);
      },
    );

    test(
      'when its uri is not a string, '
      'then it reads as no existing server',
      () {
        expect(vmServiceUriFrom('{"uri": 7}'), isNull);
      },
    );

    test(
      'when it holds no JSON at all, '
      'then it reads as no existing server',
      () {
        expect(vmServiceUriFrom('not json'), isNull);
      },
    );
  });

  group('Given a runner that stopped after it was resolved,', () {
    late Directory tempDir;
    late RunnerManifest resolved;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('rur');
      resolved = RunnerManifest(
        pid: 4242,
        stage: RunnerStage.starting,
        projectId: RunnerRegistry.idFor(tempDir.path),
        config: _asked,
      );
      initializeLoggerWith(ServerpodCliLogger(TestLogWriter()));
      addTearDown(closeLogger);
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when the attach fails and its manifest carries the exit code, '
      'then the client leaves with that code, not saying no runner listens',
      () async {
        await resolved
            .copyWith(stage: RunnerStage.stopping, exitCode: 0)
            .writeTo(tempDir.path);

        await expectLater(
          explainUnreachableRunner(
            tempDir.path,
            resolved,
            const RunnerUnreachableException('tui.sock'),
          ),
          throwsA(
            isA<ExitException>().having((e) => e.exitCode, 'exitCode', 0),
          ),
        );
      },
    );

    test(
      'when the attach fails and another runner has published since, '
      'then the failure is reported as it is',
      () async {
        await resolved
            .copyWith(stage: RunnerStage.stopping, exitCode: 0)
            .writeTo(tempDir.path);
        final other = RunnerManifest(
          pid: 4243,
          stage: RunnerStage.starting,
          projectId: resolved.projectId,
          config: _asked,
        );

        await expectLater(
          explainUnreachableRunner(
            tempDir.path,
            other,
            const RunnerUnreachableException('tui.sock'),
          ),
          throwsA(
            isA<ExitException>().having(
              (e) => e.exitCode,
              'exitCode',
              ExitException.codeError,
            ),
          ),
        );
      },
    );
  });

  group('Given a stack that may serve web,', () {
    test(
      'when the pod has published its addresses, '
      'then the addresses decide',
      () {
        expect(
          stackServesWeb(
            const ServerpodAddresses(
              api: 'http://localhost:8080',
              web: 'http://localhost:8082',
            ),
            null,
          ),
          isTrue,
        );
        expect(
          stackServesWeb(
            const ServerpodAddresses(api: 'http://localhost:8080'),
            null,
          ),
          isFalse,
        );
      },
    );

    test(
      'when the pod has published nothing and the config cannot be read, '
      'then the refresh stays on',
      () {
        expect(stackServesWeb(null, null), isTrue);
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
