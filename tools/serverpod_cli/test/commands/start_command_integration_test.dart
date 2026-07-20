// The subprocess tests compile and spawn the full CLI, which can exceed the
// default 30 second test timeout on slower machines.
@Timeout(Duration(minutes: 5))
library;

import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
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
    late Directory projectRoot;
    late Directory serverDirectory;

    setUp(() async {
      projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
      serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
      _testLogger.reset();
    });

    tearDown(() => projectRoot.delete(recursive: true));

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
      late Directory projectRoot;
      late Directory serverDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
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

      tearDown(() => projectRoot.delete(recursive: true));

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
      late Directory projectRoot;
      late Directory serverDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
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

      tearDown(() => projectRoot.delete(recursive: true));

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
    'Given a Serverpod project configured with PostgreSQL without dataPath,',
    () {
      late Directory projectRoot;
      late Directory serverDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
database:
  host: localhost
  port: 5432
  name: test
  user: postgres
''');
        serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
        _testLogger.reset();
      });

      tearDown(() => projectRoot.delete(recursive: true));

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

  group('Given a Serverpod project without a Docker Compose file,', () {
    late Directory projectRoot;
    late Directory serverDirectory;

    setUp(() async {
      projectRoot = await _createTestProject('''
database:
  filePath: db.sqlite
''');
      serverDirectory = Directory(p.join(projectRoot.path, 'test_server'));
      _testLogger.reset();
    });

    tearDown(() => projectRoot.delete(recursive: true));

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
      late Directory projectRoot;
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
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

      tearDown(() => projectRoot.delete(recursive: true));

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
      late Directory projectRoot;
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
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

      tearDown(() => projectRoot.delete(recursive: true));

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
      late Directory projectRoot;
      late Directory serverDirectory;
      late Directory fakeBinDirectory;

      setUp(() async {
        projectRoot = await _createTestProject('''
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

      tearDown(() => projectRoot.delete(recursive: true));

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

Future<Directory> _createTestProject(String databaseConfig) async {
  final projectRoot = await Directory(
    p.join(Directory.current.path, '.dart_tool'),
  ).createTemp('start_command_test_');
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

  final serverpodPackageConfig = File(
    p.join(
      Directory.current.path,
      '..',
      '..',
      'packages',
      'serverpod',
      '.dart_tool',
      'package_config.json',
    ),
  );
  final packageConfig =
      jsonDecode(await serverpodPackageConfig.readAsString())
          as Map<String, dynamic>;
  final packages = packageConfig['packages'] as List<dynamic>;
  for (final package in packages.cast<Map<String, dynamic>>()) {
    package['rootUri'] = serverpodPackageConfig.uri
        .resolve(package['rootUri'] as String)
        .toString();
  }
  packages.add({
    'name': 'test_server',
    'rootUri': serverDirectory.uri.toString(),
    'packageUri': 'lib/',
    'languageVersion': '3.10',
  });
  await File(
    p.join(serverDirectory.path, '.dart_tool', 'package_config.json'),
  ).writeAsString(jsonEncode(packageConfig));

  return projectRoot;
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
