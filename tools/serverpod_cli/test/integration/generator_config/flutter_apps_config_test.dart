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
    'Given a generator.yaml with two flutter_apps entries',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
flutter_apps:
  - name: Admin
    path: ../my_project_flutter
  - name: Customer
    path: ../my_project_customer_flutter
''',
          includeFlutterApps: true,
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then two FlutterAppConfigs are returned in order.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.flutterApps, hasLength(2));
          expect(config.flutterApps[0].name, 'Admin');
          expect(
            config.flutterApps[0].relativePathParts,
            ['..', 'my_project_flutter'],
          );
          expect(config.flutterApps[1].name, 'Customer');
          expect(
            config.flutterApps[1].relativePathParts,
            ['..', 'my_project_customer_flutter'],
          );
          expect(
            config.flutterApps[0].id,
            isNot(equals(config.flutterApps[1].id)),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml without flutter_apps and an existing default Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
''',
          includeDefaultFlutterApp: true,
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then one synthesized FlutterAppConfig is returned.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.flutterApps, hasLength(1));
          expect(config.flutterApps.first.name, 'my_project');
          expect(
            config.flutterApps.first.relativePathParts,
            ['..', 'my_project_flutter'],
          );
        },
      );

      test(
        'when loading GeneratorConfig then deprecated hasFlutterPackage is true.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          // ignore: deprecated_member_use_from_same_package
          expect(config.hasFlutterPackage, isTrue);
          // ignore: deprecated_member_use_from_same_package
          expect(
            path.joinAll(config.flutterPackagePathParts),
            path.join(
              path.join(d.sandbox, _serverRootDir),
              '..',
              'my_project_flutter',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml without flutter_apps and no sibling Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
''',
          includeDefaultFlutterApp: false,
        );
        await projectDir.create();
      });

      test(
        'when loading GeneratorConfig then flutterApps is empty.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.flutterApps, isEmpty);
          // ignore: deprecated_member_use_from_same_package
          expect(config.hasFlutterPackage, isFalse);
        },
      );
    },
  );

  group(
    'Given a generator.yaml with a flutter_apps entry missing path',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
flutter_apps:
  - name: Admin
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
                'Each "flutter_apps" entry must include a non-empty "path".',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a generator.yaml with flutter_apps that is not a list',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          generatorYamlContent: '''
type: server
flutter_apps: not_a_list
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
                'The "flutter_apps" property must be a list of app entries.',
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
  bool includeDefaultFlutterApp = false,
  bool includeFlutterApps = false,
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

  var siblingDirs = <d.Descriptor>[clientDir];

  if (includeDefaultFlutterApp) {
    siblingDirs.add(
      d.dir('${projectName}_flutter', [
        d.file('pubspec.yaml', '''
name: ${projectName}_flutter
dependencies:
  flutter:
    sdk: flutter
'''),
      ]),
    );
  }

  if (includeFlutterApps) {
    siblingDirs.addAll([
      d.dir('${projectName}_flutter', [
        d.file('pubspec.yaml', '''
name: ${projectName}_flutter
dependencies:
  flutter:
    sdk: flutter
'''),
      ]),
      d.dir('${projectName}_customer_flutter', [
        d.file('pubspec.yaml', '''
name: ${projectName}_customer_flutter
dependencies:
  flutter:
    sdk: flutter
'''),
      ]),
    ]);
  }

  return d.dir('project', [
    d.dir('${projectName}_server', serverDirContents),
    ...siblingDirs,
  ]);
}
