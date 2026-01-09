import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

final testLogger = MockLogger();

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
    initializeLoggerWith(testLogger);
  });

  tearDownAll(() {
    resetLogger();
  });

  tearDown(() {
    testLogger.output.reset();
  });

  test(
    'Given a generator.yaml without database section when loading GeneratorConfig then default schema is "public".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('public'));
    },
  );

  test(
    'Given a generator.yaml with database default_schema set to custom_schema when loading GeneratorConfig then default schema is "custom_schema".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
database:
  default_schema: custom_schema
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('custom_schema'));
    },
  );

  test(
    'Given a generator.yaml with empty database section when loading GeneratorConfig then default schema is "public".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
database: {}
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('public'));
    },
  );

  test(
    'Given a generator.yaml with database section set to null when loading GeneratorConfig then default schema is "public".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
database:
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('public'));
    },
  );

  test(
    'Given a generator.yaml with database default_schema set to empty string when loading GeneratorConfig then default schema is "public".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
database:
  default_schema:
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('public'));
    },
  );

  test(
    'Given a generator.yaml with database default_schema set to whitespace-only when loading GeneratorConfig then default schema is "public".',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
database:
  default_schema: "   "
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.defaultDatabaseSchema, equals('public'));
    },
  );
}

d.DirectoryDescriptor createMockServerpodProject({
  String projectName = 'my_project',
  String? generatorYamlContent,
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

  if (generatorYamlContent != null) {
    serverDirContents.add(
      d.dir('config', [
        d.file('generator.yaml', generatorYamlContent),
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
