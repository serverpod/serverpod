import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

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

// Logger must be initialized once for all tests in this file
final testLogger = MockLogger();

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
    initializeLoggerWith(testLogger);
  });

  setUp(() {
    // Reset captured warnings before each test
    testLogger.output.reset();
  });

  test(
    'Given a generator.yaml without features key when loading GeneratorConfig then database feature is enabled by default.',
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

      expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
    },
  );

  test(
    'Given a generator.yaml with features database set to true when loading GeneratorConfig then database feature is enabled.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
features:
  database: true
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
    },
  );

  test(
    'Given a generator.yaml with features database set to false when loading GeneratorConfig then database feature is disabled.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
features:
  database: false
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.isFeatureEnabled(ServerpodFeature.database), isFalse);
    },
  );

  test(
    'Given a generator.yaml with empty features map when loading GeneratorConfig then database feature is enabled by default.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
features: {}
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
    },
  );

  test(
    'Given a generator.yaml with features set to null when loading GeneratorConfig then database feature is enabled by default.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: '''
type: server
features:
''',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
    },
  );

  test(
    'Given project without config directory when loading GeneratorConfig then database feature is disabled by default.',
    () async {
      var projectDir = createMockServerpodProject(
        projectName: 'my_project',
      );
      await projectDir.create();

      var config = await GeneratorConfig.load(
        serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
        interactive: false,
      );

      expect(config.isFeatureEnabled(ServerpodFeature.database), isFalse);
    },
  );

  group('Given a generator.yaml with invalid feature value', () {
    test(
      'when loading GeneratorConfig then database feature uses default value (true).',
      () async {
        var projectDir = createMockServerpodProject(
          projectName: 'my_project',
          generatorYamlContent: '''
type: server
features:
  database: invalid
''',
        );
        await projectDir.create();

        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
          interactive: false,
        );

        expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
      },
    );

    test(
      'when loading GeneratorConfig then a warning is logged with source span.',
      () async {
        var projectDir = createMockServerpodProject(
          projectName: 'my_project',
          generatorYamlContent: '''
type: server
features:
  database: invalid
''',
        );
        await projectDir.create();

        await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
          interactive: false,
        );

        expect(testLogger.output.warnings, hasLength(1));
        expect(
          testLogger.output.warnings.first,
          contains('Invalid value for feature \'database\''),
        );
        expect(
          testLogger.output.warnings.first,
          contains('\'invalid\''),
        );
        expect(
          testLogger.output.warnings.first,
          contains('Using default value: true'),
        );
        // Check that source span info is included (line number)
        expect(
          testLogger.output.warnings.first,
          contains('line'),
        );
      },
    );

    test(
      'when loading GeneratorConfig with null feature value then a warning is logged.',
      () async {
        var projectDir = createMockServerpodProject(
          projectName: 'my_project',
          generatorYamlContent: '''
type: server
features:
  database:
''',
        );
        await projectDir.create();

        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, 'project', 'my_project_server'),
          interactive: false,
        );

        expect(config.isFeatureEnabled(ServerpodFeature.database), isTrue);
        expect(testLogger.output.warnings, hasLength(1));
        expect(
          testLogger.output.warnings.first,
          contains('Invalid value for feature \'database\''),
        );
        expect(
          testLogger.output.warnings.first,
          contains('Using default value: true'),
        );
      },
    );
  });
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
