import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
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

  const postgresRunModeYaml = '''
database:
  host: localhost
  port: 5432
  name: testDb
  user: test
''';

  const noDatabaseRunModeYaml = '''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''';

  Future<GeneratorConfig> loadConfig() => GeneratorConfig.load(
    serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
    interactive: false,
  );

  test(
    'Given project without config directory, '
    'when loading GeneratorConfig, '
    'then database is disabled.',
    () async {
      await createMockServerpodProject(projectName: 'my_project').create();

      var config = await loadConfig();

      expect(config.isDatabaseEnabled, isFalse);
    },
  );

  test(
    'Given a config directory with only generator.yaml,'
    'when loading GeneratorConfig ,'
    'then database is disabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
      ).create();

      var config = await loadConfig();

      expect(config.isDatabaseEnabled, isFalse);
    },
  );

  test(
    'Given a PostgreSQL database in the run-mode config files, '
    'when loading GeneratorConfig, '
    'then database is enabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
        runModeYamlFiles: {
          'development.yaml': postgresRunModeYaml,
          'test.yaml': postgresRunModeYaml,
        },
      ).create();

      var config = await loadConfig();

      expect(config.isDatabaseEnabled, isTrue);
    },
  );

  test(
    'Given a SQLite database in the run-mode config files, '
    'when loading GeneratorConfig, '
    'then database is enabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
        runModeYamlFiles: {
          'development.yaml': '''
database:
  filePath: app.db
''',
        },
      ).create();

      var config = await loadConfig();

      expect(config.isDatabaseEnabled, isTrue);
    },
  );

  test(
    'Given run-mode config files without a database section, '
    'when loading GeneratorConfig, '
    'then database is disabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
        runModeYamlFiles: {
          'development.yaml': noDatabaseRunModeYaml,
          'test.yaml': noDatabaseRunModeYaml,
        },
      ).create();

      var config = await loadConfig();

      expect(config.isDatabaseEnabled, isFalse);
    },
  );

  test(
    'Given run-mode config files where some have a database section and others do not, '
    'when loading GeneratorConfig, '
    'then a StateError is thrown.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
        runModeYamlFiles: {
          'development.yaml': postgresRunModeYaml,
          'test.yaml': noDatabaseRunModeYaml,
        },
      ).create();

      await expectLater(
        loadConfig(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Inconsistent database configurations across run-mode config files: development.yaml: enabled, test.yaml: disabled. '
                'A Serverpod project must use uniform database configuration in all run modes.',
          ),
        ),
      );
    },
  );
}

d.DirectoryDescriptor createMockServerpodProject({
  String projectName = 'my_project',
  String? generatorYamlContent,
  Map<String, String> runModeYamlFiles = const {},
}) {
  var serverDirContents = <d.Descriptor>[
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

  if (generatorYamlContent != null || runModeYamlFiles.isNotEmpty) {
    serverDirContents.add(
      d.dir('config', [
        if (generatorYamlContent != null)
          d.file('generator.yaml', generatorYamlContent),
        for (final entry in runModeYamlFiles.entries)
          d.file(entry.key, entry.value),
      ]),
    );
  }

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
