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
    'Given a server pubspec with two serverpod/flutter_apps entries',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
    Customer:
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
    'Given a server pubspec without flutter_apps and an existing default Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
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
        'when loading GeneratorConfig then synthesized app pathParts resolve correctly.',
        () async {
          var config = await GeneratorConfig.load(
            serverRootDir: path.join(d.sandbox, _serverRootDir),
            interactive: false,
          );

          expect(config.flutterApps.first.hasPackage, isTrue);
          expect(
            path.joinAll(config.flutterApps.first.pathParts),
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
    'Given a server pubspec without flutter_apps and no sibling Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
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
        },
      );
    },
  );

  group(
    'Given a server pubspec with a flutter_apps entry missing path',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      device: chrome
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
                'The "Admin" flutter app must include a non-empty "path".',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a server pubspec with flutter_apps that is not a map',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          pubspecServerpodSection: '''
serverpod:
  flutter_apps: not_a_map
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
                'The "serverpod: flutter_apps" property must be a map of app '
                    'alias to app properties.',
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
  String pubspecServerpodSection = '',
  bool includeDefaultFlutterApp = false,
  bool includeFlutterApps = false,
}) {
  var serverDirContents = <d.Descriptor>[
    d.file('pubspec.yaml', '''
name: ${projectName}_server
dependencies:
  serverpod: ^2.0.0
$pubspecServerpodSection'''),
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
      d.file('generator.yaml', 'type: server\n'),
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
