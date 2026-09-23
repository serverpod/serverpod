import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
    initializeLoggerWith(VoidLogger());
  });

  tearDownAll(() async {
    await closeLogger();
  });

  const futureCallEnabledRunModeYaml = '''
futureCall:
  enabled: true
''';

  const futureCallDisabledRunModeYaml = '''
futureCall:
  enabled: false
''';

  const noFutureCallRunModeYaml = '''
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
    'then future calls are enabled.',
    () async {
      await createMockServerpodProject(projectName: 'my_project').create();

      var config = await loadConfig();

      expect(config.isFutureCallEnabled, isTrue);
    },
  );

  test(
    'Given run-mode config files without a futureCall section, '
    'when loading GeneratorConfig, '
    'then future calls are enabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: 'type: server\n',
        runModeYamlFiles: {
          'development.yaml': noFutureCallRunModeYaml,
          'test.yaml': noFutureCallRunModeYaml,
        },
      ).create();

      var config = await loadConfig();

      expect(config.isFutureCallEnabled, isTrue);
    },
  );

  test(
    'Given future calls disabled in all run-mode config files, '
    'when loading GeneratorConfig, '
    'then future calls are disabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: 'type: server\n',
        runModeYamlFiles: {
          'development.yaml': futureCallDisabledRunModeYaml,
          'test.yaml': futureCallDisabledRunModeYaml,
        },
      ).create();

      var config = await loadConfig();

      expect(config.isFutureCallEnabled, isFalse);
    },
  );

  test(
    'Given future calls enabled in all run-mode config files, '
    'when loading GeneratorConfig, '
    'then future calls are enabled.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: 'type: server\n',
        runModeYamlFiles: {
          'development.yaml': futureCallEnabledRunModeYaml,
          'test.yaml': futureCallEnabledRunModeYaml,
        },
      ).create();

      var config = await loadConfig();

      expect(config.isFutureCallEnabled, isTrue);
    },
  );

  test(
    'Given future calls disabled in only some run-mode config files, '
    'when loading GeneratorConfig, '
    'then a StateError is thrown.',
    () async {
      await createMockServerpodProject(
        projectName: 'my_project',
        generatorYamlContent: 'type: server\n',
        runModeYamlFiles: {
          'development.yaml': noFutureCallRunModeYaml,
          'test.yaml': futureCallDisabledRunModeYaml,
        },
      ).create();

      await expectLater(
        loadConfig(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Inconsistent future call configurations across run-mode config files: development.yaml: enabled, test.yaml: disabled. '
                'A Serverpod project must use uniform future call configuration in all run modes.',
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
