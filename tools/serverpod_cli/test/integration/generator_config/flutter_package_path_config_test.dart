import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

const _serverRootDir = 'project/my_project_server';

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  String flutterDirOf(GeneratorConfig config) =>
      path.normalize(path.joinAll(config.flutterPackagePathParts));

  group('Given a generator.yaml without flutter_package_path', () {
    setUpAll(() async {
      await _createProject(
        generatorYamlContent: '''
type: server
''',
      ).create();
    });

    test(
      'when loading the config '
      'then the Flutter package resolves to the `<name>_flutter` sibling.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
        );

        expect(
          flutterDirOf(config),
          endsWith(path.join('project', 'my_project_flutter')),
        );
      },
    );
  });

  group('Given a generator.yaml with flutter_package_path set to an existing '
      'package', () {
    setUpAll(() async {
      await _createProject(
        generatorYamlContent: '''
type: server
flutter_package_path: ../apps/my_app
''',
        flutterAppPath: ['apps', 'my_app'],
      ).create();
    });

    test(
      'when loading the config '
      'then the Flutter package resolves to the configured path.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
        );

        expect(
          flutterDirOf(config),
          endsWith(path.join('project', 'apps', 'my_app')),
        );
      },
    );

    test(
      'when loading the config '
      'then the configured Flutter package is detected.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
        );

        expect(config.hasFlutterPackage, isTrue);
      },
    );
  });

  group('Given a generator.yaml with flutter_package_path and an existing '
      'package at a different override path', () {
    setUpAll(() async {
      await _createProject(
        generatorYamlContent: '''
type: server
flutter_package_path: ../apps/user_app
''',
        flutterAppPath: ['apps', 'admin_app'],
      ).create();
    });

    test(
      'when loading the config with an explicit flutterPackagePath '
      'then the explicit path takes precedence over the config key.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
          flutterPackagePath: '../apps/admin_app',
        );

        expect(
          flutterDirOf(config),
          endsWith(path.join('project', 'apps', 'admin_app')),
        );
      },
    );
  });

  group('Given a flutter_package_path pointing to a missing directory', () {
    setUpAll(() async {
      await _createProject(
        generatorYamlContent: '''
type: server
flutter_package_path: ../apps/does_not_exist
''',
      ).create();
    });

    test(
      'when loading the config '
      'then no Flutter package is detected.',
      () async {
        var config = await GeneratorConfig.load(
          serverRootDir: path.join(d.sandbox, _serverRootDir),
          interactive: false,
        );

        expect(config.hasFlutterPackage, isFalse);
      },
    );
  });
}

/// Creates a minimal Serverpod server/client project descriptor under a
/// `project/` directory, optionally materializing a Flutter app package at
/// [flutterAppPath] (relative to `project/`) so that `hasFlutterPackage`
/// resolves to true for that location.
d.DirectoryDescriptor _createProject({
  String projectName = 'my_project',
  required String generatorYamlContent,
  List<String>? flutterAppPath,
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

  var projectChildren = <d.Descriptor>[
    d.dir('${projectName}_server', serverDirContents),
    clientDir,
  ];

  if (flutterAppPath != null) {
    projectChildren.add(
      _nestedDir(flutterAppPath, [
        d.file('pubspec.yaml', '''
name: ${projectName}_app
dependencies:
  flutter:
    sdk: flutter
'''),
      ]),
    );
  }

  return d.dir('project', projectChildren);
}

/// Wraps [leaf] in nested [d.dir] descriptors so that, e.g.,
/// `['apps', 'my_app']` becomes `apps/ -> my_app/` containing [leaf].
d.DirectoryDescriptor _nestedDir(
  List<String> segments,
  List<d.Descriptor> leaf,
) {
  var contents = leaf;
  for (var i = segments.length - 1; i >= 0; i--) {
    contents = [d.dir(segments[i], contents)];
  }
  return contents.single as d.DirectoryDescriptor;
}
