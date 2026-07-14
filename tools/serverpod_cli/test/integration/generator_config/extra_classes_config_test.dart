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

  group('Given a generator.yaml with extraClasses using package: URIs', () {
    setUpAll(() async {
      var projectDir = _createProject(
        generatorYamlContent: '''
type: server
extraClasses:
  - package:shared/user_id.dart:UserId
''',
      );
      await projectDir.create();
    });

    test(
      'when loading GeneratorConfig then extraClasses are correctly resolved.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
        );

        expect(config.extraClasses, hasLength(1));
        var extraClass = config.extraClasses.first;

        expect(extraClass.className, 'UserId');
        expect(extraClass.url, 'package:shared/user_id.dart');

        expect(
          extraClass.sourcePath,
          path.join(
            d.sandbox,
            'project',
            'packages',
            'shared',
            'lib',
            'user_id.dart',
          ),
        );
        expect(
          extraClass.packageRoot,
          path.join(d.sandbox, 'project', 'packages', 'shared'),
        );
      },
    );
  });

  group('Given a generator.yaml with extraClasses that is not a list', () {
    setUpAll(() async {
      var projectDir = _createProject(
        generatorYamlContent: '''
type: server
extraClasses: not_a_list
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
              "Failed to load 'extraClasses' config",
            ),
          ),
        );
      },
    );
  });
}

d.DirectoryDescriptor _createProject({
  String projectName = 'my_project',
  required String generatorYamlContent,
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
    },
    {
      "name": "shared",
      "rootUri": "../../packages/shared",
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

  return d.dir('project', [
    d.dir('${projectName}_server', serverDirContents),
    d.dir('packages', [
      d.dir('shared', [
        d.file('pubspec.yaml', '''
name: shared
'''),
        d.dir('lib', [
          d.file('user_id.dart', 'class UserId {}'),
        ]),
      ]),
    ]),
    d.dir('${projectName}_client', [
      d.file('pubspec.yaml', '''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
'''),
    ]),
  ]);
}
