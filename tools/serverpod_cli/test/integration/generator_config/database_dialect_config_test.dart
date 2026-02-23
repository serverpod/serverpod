import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

// Shared logger instance that captures warnings and is reset before each test
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
    // Reset captured warnings after each test
    testLogger.output.reset();
  });

  test(
    'Given a generator.yaml without database dialect key when loading GeneratorConfig then database dialect is postgres by default.',
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

      expect(config.databaseDialect, DatabaseDialect.postgres);
    },
  );

  test(
    'Given a generator.yaml with database dialect set to postgres when loading GeneratorConfig then database dialect is postgres.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
databaseDialect: postgres
''',
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
    'Given a generator.yaml with database dialect set to unsupported dialect when loading GeneratorConfig then an exception is thrown.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
        type: server
        databaseDialect: unsupported
        ''',
      );
      await projectDir.create();

      await expectLater(
        () => GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
          interactive: false,
        ),
        throwsA(
          isA<SourceSpanFormatException>().having(
            (e) => e.message,
            'message',
            equals('Invalid database dialect: "unsupported".'),
          ),
        ),
      );
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
