import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

// Shared logger instance that captures warnings and is reset before each test
final testLogger = MockLogger();

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
    initializeLoggerWith(testLogger);
  });

  tearDownAll(() async {
    await closeLogger();
  });

  tearDown(() {
    // Reset captured warnings after each test
    testLogger.output.reset();
  });

  test(
    'Given no run-mode database config when loading GeneratorConfig then database dialect is postgres.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.databaseDialect, DatabaseDialect.postgres);
    },
  );

  test(
    'Given SQLite database in a run-mode YAML when loading GeneratorConfig then dialect is sqlite.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        runModeYamlFiles: {
          'development.yaml': '''
database:
  filePath: app.db
''',
        },
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.databaseDialect, DatabaseDialect.sqlite);
    },
  );

  test(
    'Given PostgreSQL database in a run-mode YAML when loading GeneratorConfig then dialect is postgres.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        runModeYamlFiles: {
          'development.yaml': '''
database:
  host: localhost
  port: 5432
  name: testDb
  user: test
''',
        },
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.databaseDialect, DatabaseDialect.postgres);
    },
  );

  test(
    'Given conflicting database dialects across run-mode YAMLs when loading GeneratorConfig then StateError is thrown.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        runModeYamlFiles: {
          'development.yaml': '''
database:
  host: localhost
  port: 5432
  name: testDb
  user: test
''',
          'test.yaml': '''
database:
  filePath: test.db
''',
        },
      );
      await projectDir.create();

      await expectLater(
        () => GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
          interactive: false,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Inconsistent database dialects across run-mode config files: '
                'development.yaml (postgres), test.yaml (sqlite). A Serverpod '
                'project must use a single database dialect in all run modes.',
          ),
        ),
      );
    },
  );
}

d.DirectoryDescriptor createMockServerpodProject({
  String projectName = 'my_project',
  Map<String, String> runModeYamlFiles = const {},
}) {
  var serverDirContents = <d.Descriptor>[
    d.dir('config', [
      for (final entry in runModeYamlFiles.entries)
        d.file(entry.key, entry.value),
    ]),
    d.file('pubspec.yaml', '''
name: ${projectName}_server
dependencies:
  serverpod: ^2.0.0
'''),
    d.dir('lib', [
      d.dir('src', [
        d.dir('protocol', []),
      ]),
    ]),
    d.dir('.dart_tool', [
      d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "${projectName}_server",
      "rootUri": "../",
      "packageUri": "lib/"
    },
    {
      "name": "serverpod",
      "rootUri": "../.pub-cache/hosted/pub.dev/serverpod-2.0.0",
      "packageUri": "lib/"
    }
  ]
}
'''),
    ]),
  ];

  var clientDir = d.dir('${projectName}_client', [
    d.file('pubspec.yaml', '''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
'''),
    d.dir('lib', [
      d.dir('src', [
        d.dir('protocol', []),
      ]),
    ]),
  ]);

  // Return a parent directory containing both server and client as siblings
  return d.dir('project', [
    d.dir('${projectName}_server', serverDirContents),
    clientDir,
  ]);
}

class MockLogOutput {
  List<String> warnings = [];

  void warning(String message) {
    warnings.add(message);
  }

  void reset() {
    warnings.clear();
  }
}

class MockLogger extends VoidLogger {
  final MockLogOutput output = MockLogOutput();

  MockLogger();

  @override
  void warning(String message, {bool newParagraph = false, LogType? type}) {
    output.warning(message);
  }
}
