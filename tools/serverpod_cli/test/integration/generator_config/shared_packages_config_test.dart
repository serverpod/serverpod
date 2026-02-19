import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

const _serverRootDir = 'project/my_project_server';

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  group(
    'Given a generator.yaml without shared_packages',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
''',
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then sharedModelsSourcePathsParts is empty.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.sharedModelsSourcePathsParts, isEmpty);
        },
      );
    },
  );

  group(
    'Given a generator.yaml with shared_packages as an empty list',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages: []
''',
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then sharedModelsSourcePathsParts is empty.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.sharedModelsSourcePathsParts, isEmpty);
        },
      );
    },
  );

  group(
    'Given a generator.yaml with shared_packages pointing to a valid package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages:
  - ./packages/shared
''',
          includeSharedPackage: true,
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then sharedModelsSourcePathsParts contains the package.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.sharedModelsSourcePathsParts, isNotEmpty);
          expect(config.sharedModelsSourcePathsParts, contains('shared'));
          expect(
            config.sharedModelsSourcePathsParts['shared'],
            ['.', 'packages', 'shared'],
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml with shared_packages that is not a list',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages: not_a_list
''',
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
        () async {
          await expectLater(
            GeneratorConfig.load(
              serverRootDir: path.join(d.sandbox, _serverRootDir),
              interactive: false,
            ),
            throwsA(
              isA<SourceSpanFormatException>().having(
                (e) => e.message,
                'message',
                'The "shared_packages" property must be a list of package paths.',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml with shared_packages containing a non-string path',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages:
  - 123
''',
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
        () async {
          await expectLater(
            GeneratorConfig.load(
              serverRootDir: path.join(d.sandbox, _serverRootDir),
              interactive: false,
            ),
            throwsA(
              isA<SourceSpanFormatException>().having(
                (e) => e.message,
                'message',
                'The path for the shared package must be a string path relative '
                    'to the server package. Current path: 123',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml with an absolute shared_packages path',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages:
  - /packages/shared
''',
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
        () async {
          await expectLater(
            GeneratorConfig.load(
              serverRootDir: path.join(d.sandbox, _serverRootDir),
              interactive: false,
            ),
            throwsA(
              isA<SourceSpanFormatException>().having(
                (e) => e.message,
                'message',
                'The path for the shared package must be a string path relative '
                    'to the server package. Current path: /packages/shared',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml with shared_packages path pointing to a missing directory',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
shared_packages:
  - ./packages/shared
''',
          includeSharedPackage: false,
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then ServerpodProjectNotFoundException is thrown.',
        () async {
          await expectLater(
            GeneratorConfig.load(
              serverRootDir: path.join(d.sandbox, _serverRootDir),
              interactive: false,
            ),
            throwsA(
              isA<ServerpodProjectNotFoundException>().having(
                (e) => e.message,
                'message',
                'Failed to load shared package pubspec.yaml. Make sure the path '
                    'is correctly specified in the config/generator.yaml file.',
              ),
            ),
          );
        },
      );
    },
  );
}

d.DirectoryDescriptor _createProject({
  String projectName = 'my_project',
  required String generatorYamlContent,
  bool includeSharedPackage = false,
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
    d.dir('config', [
      d.file('generator.yaml', generatorYamlContent),
    ]),
  ];

  if (includeSharedPackage) {
    serverDirContents.add(
      d.dir('packages', [
        d.dir('shared', [
          d.file('pubspec.yaml', '''
name: shared
dependencies:
  serverpod_serialization: ^3.0.0
'''),
        ]),
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
