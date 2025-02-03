@Timeout(Duration(minutes: 12))
library;

import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/shared/environment.dart' as env;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class MockAnalytics implements Analytics {
  @override
  void cleanUp() {}
  @override
  void track({required String event}) {}
}

class TestFixture {
  final MockAnalytics analytics;
  final CreateCommand createCommand;
  final ServerpodCommandRunner runner;

  TestFixture(
    this.analytics,
    this.createCommand,
    this.runner,
  );
}

TestFixture createTestFixture() {
  var analytics = MockAnalytics();
  var runner = ServerpodCommandRunner.createCommandRunner(
    analytics,
    false,
    Version(2, 3, 1),
    onBeforeRunCommand: (_) => Future(() => {}),
  );
  var createCommand = CreateCommand();
  runner.addCommand(createCommand);
  return TestFixture(analytics, createCommand, runner);
}

extension PathExtensions on FileSystemEntity {
  Directory operator /(String other) => Directory(path.join(this.path, other));
  File operator >(String other) => File(path.join(this.path, other));
  String get name => path.basename(this.path);
  Directory get serverPath => Directory(this.path) / '${name}_server';
}

const projectsPrefix = 'temp_proj_dir_';
final rootPath = path.join(Directory.current.path, '..', '..');

(String, Directory) createTempProjectName() {
  var uuid = const Uuid().v4().replaceAll('-', '');
  var projectName = '$projectsPrefix$uuid';
  var projectPath = Directory(path.join(Directory.current.path, projectName));
  return (projectName, projectPath);
}

void main() {
  initializeLoggerWith(VoidLogger());
  env.serverpodHome = rootPath;

  late TestFixture fixture;
  setUp(() {
    fixture = createTestFixture();
  });

  tearDownAll(() {
    Directory.current
        .listSync()
        .where((d) => d.name.startsWith(projectsPrefix))
        .forEach((d) {
      try {
        d.deleteSync(recursive: true);
      } catch (e) {
        // Ignore tear down errors.
      }
    });
  });

  group('When calling the create command with a project name only.', () {
    var (projectName, projectPath) = createTempProjectName();
    var serverPath = projectPath.serverPath;
    var args = ['create', projectName];

    test('then the command runs and the project exists.', () async {
      await fixture.runner.run(args);

      expect(serverPath.existsSync(), isTrue);
      expect(serverPath.listSync(), isNotEmpty);
    });

    group('then the generator.yaml', () {
      var generatorConfigPath = serverPath / 'config' > 'generator.yaml';

      test('exists.', () {
        expect(generatorConfigPath.existsSync(), isTrue);
      });

      test('have no defaultIdType key.', () {
        var contents = generatorConfigPath.readAsStringSync();
        expect(contents, isNot(contains('defaultIdType: int')));
      });
    });
  });

  group(
      'When calling the create command with defaultIdType and no experimental flag.',
      () {
    var (projectName, projectPath) = createTempProjectName();
    var serverPath = projectPath.serverPath;
    var args = ['create', projectName, '--defaultIdType', 'int'];

    test('then the command does not run.', () async {
      try {
        await fixture.runner.run(args);
      } on ExitException catch (e) {
        expect(e.exitCode, ExitCodeType.commandInvokedCannotExecute.exitCode);
      }

      expect(serverPath.existsSync(), isFalse);
    });
  });

  group(
      'When calling the create command with defaultIdType set to an inexistent type and the experimental flag set.',
      () {
    var (projectName, projectPath) = createTempProjectName();
    var serverPath = projectPath.serverPath;
    var args = [
      'create',
      projectName,
      '--experimental-features=changeIdType',
      '--defaultIdType',
      'ABC',
    ];

    test('then the command does not run.', () async {
      try {
        await fixture.runner.run(args);
      } on ExitException catch (e) {
        expect(e.exitCode, ExitCodeType.commandNotFound.exitCode);
      }

      expect(serverPath.existsSync(), isFalse);
    });
  });

  for (var idType in SupportedIdType.all) {
    var idTypeAlias = idType.aliases.first;

    group(
        'When calling the create command with defaultIdType set to $idTypeAlias and the experimental flag set.',
        () {
      var (projectName, projectPath) = createTempProjectName();
      var serverPath = projectPath.serverPath;
      var args = [
        'create',
        projectName,
        '--experimental-features=changeIdType',
        '--defaultIdType',
        idTypeAlias,
      ];

      test('then the command runs and the project exists.', () async {
        await fixture.runner.run(args);

        expect(serverPath.existsSync(), isTrue);
        expect(serverPath.listSync(), isNotEmpty);
      });

      group('then the generator.yaml', () {
        var generatorConfigPath = serverPath / 'config' > 'generator.yaml';

        test('exists.', () {
          expect(generatorConfigPath.existsSync(), isTrue);
        });

        test('with the defaultIdType key set to $idTypeAlias.', () {
          var contents = generatorConfigPath.readAsStringSync();
          expect(contents, contains('defaultIdType: $idTypeAlias'));
        });
      });
    });
  }
}
