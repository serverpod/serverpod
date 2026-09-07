// The subprocess tests compile and spawn the full CLI, which can exceed the
// default 30 second test timeout on slower machines.
@Timeout(Duration(minutes: 5))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:dart_mcp/client.dart';
import 'package:package_config/package_config.dart' as pc;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show hasUnixSocketSupport;
import 'package:test/test.dart';

final _testLogger = _TestLogger();

void main() {
  setUpAll(() {
    initializeLoggerWith(_testLogger);
  });

  tearDownAll(() async {
    await closeLogger();
    await _compiledRunnerDirectory?.delete(recursive: true);
  });

  group('Given a Serverpod project configured with SQLite,', () {
    late Directory serverDirectory;

    setUp(() async {
      final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
      serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
      _testLogger.reset();
    });

    test(
      'when serverpod start runs without a Docker flag, '
      'then Docker services startup is skipped.',
      () async {
        await _createComposeFile(serverDirectory);

        await _runStart(serverDirectory: serverDirectory);

        expect(
          _testLogger.progressMessages,
          isNot(contains(startingDockerServices)),
        );
      },
    );

    test(
      'when serverpod start runs with --docker, '
      'then Docker services startup is requested.',
      () async {
        await _runStart(
          serverDirectory: serverDirectory,
          dockerArgument: '--docker',
        );

        expect(_testLogger.progressMessages, contains(startingDockerServices));
      },
    );
  });

  group(
    'Given a Serverpod project configured with SQLite and Redis enabled,',
    () {
      late Directory serverDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
redis:
  enabled: true
  host: localhost
  port: 6379
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then Docker services startup is skipped.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            isNot(contains(startingDockerServices)),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project configured with PostgreSQL and dataPath,',
    () {
      late Directory serverDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  host: localhost
  port: 5432
  name: test
  user: postgres
  dataPath: .serverpod/pgdata
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then Docker services startup is skipped.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            isNot(contains(startingDockerServices)),
          );
        },
      );

      test(
        'when serverpod start runs with --docker, '
        'then Docker services startup is requested.',
        () async {
          await _runStart(
            serverDirectory: serverDirectory,
            dockerArgument: '--docker',
          );

          expect(
            _testLogger.progressMessages,
            contains(startingDockerServices),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project configured with PostgreSQL on localhost without dataPath,',
    () {
      late Directory serverDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  host: localhost
  port: 5432
  name: test
  user: postgres
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then Docker services startup is requested.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            contains(startingDockerServices),
          );
        },
      );

      test(
        'when serverpod start runs without a Docker flag and the project has no Docker Compose file, '
        'then Docker services startup is skipped.',
        () async {
          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            isNot(contains(startingDockerServices)),
          );
          expect(_testLogger.errors, isNot(contains(dockerComposeFileMissing)));
        },
      );

      test(
        'when serverpod start runs with --no-docker, '
        'then Docker services startup is skipped.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(
            serverDirectory: serverDirectory,
            dockerArgument: '--no-docker',
          );

          expect(
            _testLogger.progressMessages,
            isNot(contains(startingDockerServices)),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project configured with PostgreSQL on 127.0.0.1 without dataPath,',
    () {
      late Directory serverDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  host: 127.0.0.1
  port: 5432
  name: test
  user: postgres
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then Docker services startup is requested.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            contains(startingDockerServices),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project configured with remote PostgreSQL without dataPath,',
    () {
      late Directory serverDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  host: db.example.com
  port: 5432
  name: test
  user: postgres
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then Docker services startup is skipped.',
        () async {
          await _createComposeFile(serverDirectory);

          await _runStart(serverDirectory: serverDirectory);

          expect(
            _testLogger.progressMessages,
            isNot(contains(startingDockerServices)),
          );
        },
      );

      test(
        'when serverpod start runs with --docker, '
        'then Docker services startup is requested.',
        () async {
          await _runStart(
            serverDirectory: serverDirectory,
            dockerArgument: '--docker',
          );

          expect(
            _testLogger.progressMessages,
            contains(startingDockerServices),
          );
        },
      );
    },
  );

  group('Given a Serverpod project without a Docker Compose file,', () {
    late Directory serverDirectory;

    setUp(() async {
      final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
      serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
      _testLogger.reset();
    });

    test(
      'when serverpod start runs with --docker, '
      'then startup fails with instructions for restoring Docker configuration.',
      () async {
        await _runStart(
          serverDirectory: serverDirectory,
          dockerArgument: '--docker',
        );

        expect(_testLogger.errors, [dockerComposeFileMissing]);
        expect(_testLogger.progressResults[startingDockerServices], isFalse);
      },
    );
  });

  group(
    'Given a Serverpod project on a machine without Docker,',
    // Dart ignores PATH supplied through Process.run's environment map when
    // resolving executables on Windows, so the test cannot hide a Docker
    // installation on Windows CI.
    testOn: '!windows',
    () {
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  host: localhost
  port: 5432
  name: test
  user: postgres
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        // An empty directory as the only PATH entry, so `docker` cannot be
        // launched at all.
        fakeBinDirectory = Directory(p.join(projectRoot.path, 'bin'));
        await fakeBinDirectory.create();
        await _createComposeFile(serverDirectory);
      });

      test(
        'when serverpod start runs without a Docker flag, '
        'then startup fails with instructions for installing Docker.',
        () async {
          final result = await _runStartInSubprocess(
            serverDirectory: serverDirectory,
            pathVariable: fakeBinDirectory.path,
            dockerArgument: null,
          );

          expect(result.exitCode, 1);
          expect(
            result.output,
            contains('$startingDockerServices failed.'),
          );
          expect(
            _normalizeWhitespace(result.output),
            contains(dockerNotInstalled),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project whose Docker service is not running,',
    // Dart's Process.run refuses to launch batch files unless runInShell is
    // set, so the fake `docker.bat` shim cannot stand in for the real binary
    // on Windows.
    testOn: '!windows',
    () {
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        fakeBinDirectory = Directory(p.join(projectRoot.path, 'bin'));
        await fakeBinDirectory.create();
        await _createComposeFile(serverDirectory);
        await _writeFakeDocker(
          fakeBinDirectory,
          _FakeDockerBehavior.notRunning,
        );
      });

      test(
        'when serverpod start runs with --docker, '
        'then startup fails with instructions for starting Docker.',
        () async {
          final result = await _runStartInSubprocess(
            serverDirectory: serverDirectory,
            pathVariable: _prependToPath(fakeBinDirectory.path),
          );

          expect(result.exitCode, 1);
          expect(
            result.output,
            contains('$startingDockerServices failed.'),
          );
          expect(
            _normalizeWhitespace(result.output),
            contains(dockerNotRunning),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod project whose Docker Compose services cannot start,',
    // Dart's Process.run refuses to launch batch files unless runInShell is
    // set, so the fake `docker.bat` shim cannot stand in for the real binary
    // on Windows.
    testOn: '!windows',
    () {
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        fakeBinDirectory = Directory(p.join(projectRoot.path, 'bin'));
        await fakeBinDirectory.create();
        await _createComposeFile(serverDirectory);
        await _writeFakeDocker(
          fakeBinDirectory,
          _FakeDockerBehavior.composeUpFailure,
        );
      });

      test(
        'when serverpod start runs with --docker, '
        'then startup fails with the Docker Compose output.',
        () async {
          final result = await _runStartInSubprocess(
            serverDirectory: serverDirectory,
            pathVariable: _prependToPath(fakeBinDirectory.path),
          );

          expect(result.exitCode, 1);
          expect(
            result.output,
            contains('$startingDockerServices failed.'),
          );
          expect(
            _normalizeWhitespace(result.output),
            contains(dockerComposeStartFailed),
          );
          expect(result.output, contains('Fake Docker Compose failure.'));
        },
      );
    },
  );

  group(
    'Given a running Serverpod project with a configured Flutter app started without a TUI,',
    skip: !hasUnixSocketSupport(),
    () {
      late ServerConnection connection;

      setUpAll(() async {
        final projectRoot = await _createRunnableTestProject();
        final serverDirectory = Directory(
          p.join(projectRoot.path, 'test_server'),
        );
        final dillPath = await _compileStartCommandRunner();
        final output = StringBuffer();
        final process = await Process.start(
          Platform.resolvedExecutable,
          [
            dillPath,
            '--no-interactive',
            'start',
            '--directory',
            serverDirectory.path,
            '--no-tui',
            '--no-watch',
            '--no-flutter',
            '--no-docker',
          ],
          workingDirectory: Directory.current.path,
        );
        process.stdout
            .transform(utf8.decoder)
            .listen(output.write, onError: output.write);
        process.stderr
            .transform(utf8.decoder)
            .listen(output.write, onError: output.write);

        addTearDown(() => _terminateStartProcessTree(process));

        final socket = await _connectToStartedMcpSocket(
          serverDirectory: serverDirectory,
          process: process,
          output: output,
        );
        final client = MCPClient(
          Implementation(name: 'test-client', version: '0.1.0'),
        );
        connection = client.connectServer(socketChannel(socket));
        await connection.initialize(
          InitializeRequest(
            protocolVersion: ProtocolVersion.latestSupported,
            capabilities: ClientCapabilities(),
            clientInfo: Implementation(
              name: 'test-client',
              version: '0.1.0',
            ),
          ),
        );
        addTearDown(connection.shutdown);
      });

      test(
        'when tail_server_logs is called, '
        'then the server history contains its log.',
        () async {
          final serverLogs = await _waitForServerLog(connection);

          expect(serverLogs.isError, isNull);
          expect(
            jsonDecode((serverLogs.content.single as TextContent).text),
            contains(
              containsPair('message', 'Server log retained without a TUI.'),
            ),
          );
        },
      );

      test(
        'when tail_flutter_logs is called, '
        'then the Flutter history is empty.',
        () async {
          final flutterLogs = await connection.callTool(
            CallToolRequest(name: 'tail_flutter_logs'),
          );

          expect(flutterLogs.isError, isNull);
          expect(
            jsonDecode((flutterLogs.content.single as TextContent).text),
            isEmpty,
          );
        },
      );
    },
  );
}

Future<void> _runStart({
  required Directory serverDirectory,
  String? dockerArgument,
}) async {
  final runner = ServerpodCommandRunner(
    'serverpod',
    'Serverpod test runner',
    productionMode: false,
    cliVersion: Version(1, 0, 0),
    onBeforeRunCommand: (_) async {},
  )..addCommand(StartCommand());

  final arguments = [
    '--no-interactive',
    'start',
    '--directory',
    serverDirectory.path,
    '--no-watch',
    '--no-flutter',
    ?dockerArgument,
  ];

  try {
    await runner.run(arguments);
    fail('serverpod start should have aborted during startup.');
  } on ExitException catch (exception) {
    // Startup aborts with exit code 1 either at the Docker step or, when
    // Docker is skipped or succeeds, at the intentionally invalid model.
    expect(
      exception.exitCode,
      1,
      reason:
          'Expected startup to abort with exit code 1.\n${_testLogger.errors.join('\n')}',
    );
  }
}

Future<Directory> _createTestProject(
  String databaseConfig, {
  bool useShortSystemTempPath = false,
}) async {
  final projectRoot = useShortSystemTempPath
      ? await Directory.systemTemp.createTemp('smi')
      : await Directory(
          p.join(Directory.current.path, '.dart_tool'),
        ).createTemp('start_command_test_');
  try {
    final serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
    final clientDirectory = Directory(p.join(projectRoot.path, 'test_client'));

    await Directory(
      p.join(serverDirectory.path, 'lib', 'src', 'models'),
    ).create(recursive: true);
    await Directory(p.join(serverDirectory.path, 'config')).create();
    await Directory(p.join(serverDirectory.path, '.dart_tool')).create();
    await clientDirectory.create();

    await File(p.join(serverDirectory.path, 'pubspec.yaml')).writeAsString('''
name: test_server
environment:
  sdk: ^3.10.0
dependencies:
  serverpod: any
''');
    await File(p.join(clientDirectory.path, 'pubspec.yaml')).writeAsString('''
name: test_client
environment:
  sdk: ^3.10.0
dependencies:
  serverpod_client: any
''');
    await File(
      p.join(serverDirectory.path, 'config', 'development.yaml'),
    ).writeAsString(databaseConfig);
    await File(
      p.join(serverDirectory.path, 'config', 'passwords.yaml'),
    ).writeAsString('''
development:
  database: password
  redis: password
''');
    await File(
      p.join(serverDirectory.path, 'lib', 'src', 'models', 'invalid.spy.yaml'),
    ).writeAsString('''
class: Invalid
fields:
  value: InvalidType
''');

    final hostConfig = await pc.findPackageConfig(Directory.current);
    if (hostConfig == null) {
      throw StateError(
        'Could not locate the host package_config.json from '
        '${Directory.current.path}. Run `dart pub get` first.',
      );
    }
    // The generator must locate the synthetic project's declared `serverpod`
    // module, but these tests stop at the intentionally invalid model before
    // compiling server code. Point at the repository package directly instead
    // of adding Serverpod and its runtime dependency graph to the CLI tests.
    final serverpodRoot = Directory(
      p.join(Directory.current.path, '..', '..', 'packages', 'serverpod'),
    );
    if (!await File(p.join(serverpodRoot.path, 'pubspec.yaml')).exists()) {
      throw StateError(
        'Could not locate the repository serverpod package at '
        '${serverpodRoot.path}.',
      );
    }

    final packages = <Map<String, Object?>>[
      for (final package in hostConfig.packages)
        if (package.name != 'serverpod')
          {
            'name': package.name,
            'rootUri': package.root.toString(),
            'packageUri': 'lib/',
            'languageVersion': package.languageVersion?.toString() ?? '3.0',
          },
      {
        'name': 'serverpod',
        'rootUri': serverpodRoot.uri.toString(),
        'packageUri': 'lib/',
        'languageVersion': '3.10',
      },
      {
        'name': 'test_server',
        'rootUri': serverDirectory.uri.toString(),
        'packageUri': 'lib/',
        'languageVersion': '3.10',
      },
    ];
    await File(
      p.join(serverDirectory.path, '.dart_tool', 'package_config.json'),
    ).writeAsString(
      jsonEncode({
        'configVersion': 2,
        'packages': packages,
      }),
    );

    addTearDown(() => _deleteProjectRoot(projectRoot));
    return projectRoot;
  } catch (error, stackTrace) {
    try {
      if (await projectRoot.exists()) {
        await projectRoot.delete(recursive: true);
      }
    } catch (_) {
      // Preserve the fixture-construction failure that made cleanup necessary.
    }
    Error.throwWithStackTrace(error, stackTrace);
  }
}

Future<Directory> _createRunnableTestProject() async {
  final projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''', useShortSystemTempPath: true);
  final serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
  await File(
    p.join(serverDirectory.path, 'lib', 'src', 'models', 'invalid.spy.yaml'),
  ).delete();
  await Directory(p.join(serverDirectory.path, 'bin')).create();
  await Directory(p.join(projectRoot.path, 'test_flutter')).create();
  await File(p.join(serverDirectory.path, 'pubspec.yaml')).writeAsString('''
name: test_server
environment:
  sdk: ^3.10.0
dependencies:
  serverpod: any
serverpod:
  flutter_apps:
    admin:
      path: ../test_flutter
      auto_launch: false
''');
  await File(p.join(serverDirectory.path, 'bin', 'main.dart')).writeAsString('''
import 'dart:async';
import 'dart:developer' as developer;

Future<void> main(List<String> arguments) async {
  Timer.periodic(const Duration(milliseconds: 100), (_) {
    developer.postEvent('ext.serverpod.log', {
      'type': 'log',
      'level': 'info',
      'message': 'Server log retained without a TUI.',
      'timestamp': DateTime.now().toIso8601String(),
    });
  });
  await Completer<void>().future;
}
''');
  return projectRoot;
}

Future<Socket> _connectToStartedMcpSocket({
  required Directory serverDirectory,
  required Process process,
  required StringBuffer output,
}) async {
  int? processExitCode;
  unawaited(process.exitCode.then((code) => processExitCode = code));
  final socketPath = serverpodMcpSocketPath(serverDirectory.path);
  final deadline = DateTime.now().add(const Duration(seconds: 60));
  while (DateTime.now().isBefore(deadline)) {
    if (processExitCode != null) {
      throw StateError(
        'serverpod start exited with $processExitCode before opening its MCP '
        'socket.\n$output',
      );
    }
    try {
      return await Socket.connect(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        0,
      );
    } on SocketException {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }
  throw TimeoutException(
    'serverpod start did not open its MCP socket.\n$output',
    const Duration(seconds: 60),
  );
}

Future<CallToolResult> _waitForServerLog(ServerConnection connection) async {
  final deadline = DateTime.now().add(const Duration(seconds: 10));
  while (DateTime.now().isBefore(deadline)) {
    final result = await connection.callTool(
      CallToolRequest(name: 'tail_server_logs'),
    );
    final logs =
        jsonDecode((result.content.single as TextContent).text) as List;
    if (logs.any(
      (log) =>
          log is Map && log['message'] == 'Server log retained without a TUI.',
    )) {
      return result;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  throw TimeoutException(
    'The server log was not retained.',
    const Duration(seconds: 10),
  );
}

/// Creates an empty `docker-compose.yaml`. Empty on purpose: even if a real
/// Docker daemon is available, Docker Compose rejects an empty file, so tests
/// never actually start containers.
Future<void> _createComposeFile(Directory serverDirectory) async {
  await File(p.join(serverDirectory.path, 'docker-compose.yaml')).create();
}

Directory? _compiledRunnerDirectory;
Future<String>? _compiledRunnerFuture;

/// Compiles the start command runner fixture to a kernel snapshot once and
/// reuses it, so each subprocess test doesn't pay the CLI's JIT compile time.
Future<String> _compileStartCommandRunner() {
  return _compiledRunnerFuture ??= () async {
    final runnerPath = p.join(
      Directory.current.path,
      'test',
      'commands',
      'fixtures',
      'start_command_runner.dart',
    );
    final directory = await Directory(
      p.join(Directory.current.path, '.dart_tool'),
    ).createTemp('start_command_runner_');
    _compiledRunnerDirectory = directory;
    final dillPath = p.join(directory.path, 'start_command_runner.dill');
    final result = await Process.run(
      Platform.resolvedExecutable,
      ['compile', 'kernel', runnerPath, '-o', dillPath],
      workingDirectory: Directory.current.path,
    );
    if (result.exitCode != 0) {
      throw StateError(
        'Failed to compile start_command_runner.dart:\n'
        '${result.stdout}\n${result.stderr}',
      );
    }
    return dillPath;
  }();
}

Future<({int exitCode, String output})> _runStartInSubprocess({
  required Directory serverDirectory,
  required String pathVariable,
  String? dockerArgument = '--docker',
}) async {
  final dillPath = await _compileStartCommandRunner();
  final result = await Process.run(
    Platform.resolvedExecutable,
    [
      dillPath,
      '--no-interactive',
      'start',
      '--directory',
      serverDirectory.path,
      '--no-watch',
      '--no-flutter',
      ?dockerArgument,
    ],
    workingDirectory: Directory.current.path,
    environment: _environmentWithPath(pathVariable),
  );

  return (
    exitCode: result.exitCode,
    output: '${result.stdout}\n${result.stderr}',
  );
}

/// Deletes a test project, retrying while Windows still reports the directory
/// as in use.
///
/// Windows releases a terminated process's handles asynchronously, so a
/// deletion right after the last process exits can still fail even though
/// nothing holds the directory any more.
Future<void> _deleteProjectRoot(Directory projectRoot) async {
  final deadline = DateTime.now().add(const Duration(seconds: 10));
  while (true) {
    if (!await projectRoot.exists()) return;
    try {
      await projectRoot.delete(recursive: true);
      return;
    } on FileSystemException {
      if (DateTime.now().isAfter(deadline)) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
}

/// Shuts down a `serverpod start` [process] together with the pod it spawned.
///
/// On POSIX, SIGINT reaches the CLI's own shutdown path, which stops the pod
/// for us. Windows has no such signal - `Process.kill` terminates the CLI
/// outright, leaving the pod running with its working directory inside the
/// test project, which then cannot be deleted (see the Job Object TODO in
/// `ServerProcess.start`). `taskkill /T` takes down the whole tree instead.
Future<void> _terminateStartProcessTree(Process process) async {
  if (Platform.isWindows) {
    await Process.run('taskkill', ['/T', '/F', '/PID', '${process.pid}']);
  } else {
    process.kill(ProcessSignal.sigint);
  }
  try {
    await process.exitCode.timeout(const Duration(seconds: 10));
  } on TimeoutException {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
  }
}

String _prependToPath(String directory) {
  return [
    directory,
    ?Platform.environment['PATH'],
  ].join(Platform.isWindows ? ';' : ':');
}

/// The full environment with the PATH variable replaced by [path]. Windows
/// spells the variable in varying cases, so any existing spelling is dropped.
Map<String, String> _environmentWithPath(String path) {
  return {
    for (final entry in Platform.environment.entries)
      if (entry.key.toUpperCase() != 'PATH') entry.key: entry.value,
    'PATH': path,
  };
}

Future<void> _writeFakeDocker(
  Directory directory,
  _FakeDockerBehavior behavior,
) async {
  final file = File(
    p.join(directory.path, Platform.isWindows ? 'docker.bat' : 'docker'),
  );
  await file.writeAsString(
    Platform.isWindows
        ? _fakeDockerWindowsScript(behavior)
        : _fakeDockerPosixScript(behavior),
  );
  if (!Platform.isWindows) {
    final chmod = await Process.run('chmod', ['+x', file.path]);
    if (chmod.exitCode != 0) {
      throw StateError(
        'Failed to make fake Docker executable: ${chmod.stderr}',
      );
    }
  }
}

String _fakeDockerPosixScript(_FakeDockerBehavior behavior) {
  return switch (behavior) {
    _FakeDockerBehavior.notRunning =>
      '''#!/bin/sh
exit 1
''',
    _FakeDockerBehavior.composeUpFailure =>
      '''#!/bin/sh
if [ "\$2" = "ps" ]; then
  exit 0
fi
echo "Fake Docker Compose failure." >&2
exit 1
''',
  };
}

String _fakeDockerWindowsScript(_FakeDockerBehavior behavior) {
  return switch (behavior) {
    _FakeDockerBehavior.notRunning =>
      '''@echo off
exit /b 1
''',
    _FakeDockerBehavior.composeUpFailure =>
      '''@echo off
if "%2"=="ps" exit /b 0
echo Fake Docker Compose failure. 1>&2
exit /b 1
''',
  };
}

enum _FakeDockerBehavior { notRunning, composeUpFailure }

String _normalizeWhitespace(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class _TestLogger extends VoidLogger {
  final progressMessages = <String>[];
  final progressResults = <String, bool>{};
  final errors = <String>[];

  void reset() {
    progressMessages.clear();
    progressResults.clear();
    errors.clear();
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = const RawLogType(),
  }) {
    errors.add(message);
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    String? successMessage,
    bool newParagraph = true,
  }) async {
    progressMessages.add(message);
    final result = await runner();
    progressResults[message] = result;
    return result;
  }
}
