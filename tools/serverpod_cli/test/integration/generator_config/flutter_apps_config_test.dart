import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

String _serverRoot() => path.normalize(
  path.join(d.sandbox, 'project', 'my_project_server'),
);

/// Loads the configured Flutter apps from the sandbox server project.
List<FlutterAppConfig> _loadApps() {
  final serverRoot = _serverRoot();
  return loadFlutterApps(
    serverPubspecFile: File(path.join(serverRoot, 'pubspec.yaml')),
    serverPackageDirectoryPathParts: path.split(serverRoot),
    projectName: 'my_project',
  );
}

void main() {
  group('Given a server pubspec with two serverpod/flutter_apps entries', () {
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
      'when loading flutter apps '
      'then two FlutterAppConfigs are returned in order',
      () {
        final apps = _loadApps();

        expect(apps, hasLength(2));
        expect(apps[0].name, 'Admin');
        expect(
          apps[0].relativePathParts,
          ['..', 'my_project_flutter'],
        );
        expect(apps[1].name, 'Customer');
        expect(
          apps[1].relativePathParts,
          ['..', 'my_project_customer_flutter'],
        );
        expect(apps[0].id, isNot(equals(apps[1].id)));
      },
    );
  });

  group('Given a server pubspec with flutter_apps and auto_launch flags', () {
    setUpAll(() async {
      var projectDir = _createProject(
        pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
      auto_launch: true
    Customer:
      path: ../my_project_customer_flutter
''',
        includeFlutterApps: true,
      );
      await projectDir.create();
    });

    test(
      'when loading flutter apps '
      'then auto_launch is read per app and defaults to false',
      () {
        final apps = _loadApps();

        expect(apps[0].name, 'Admin');
        expect(apps[0].autoLaunch, isTrue);
        expect(apps[1].name, 'Customer');
        expect(apps[1].autoLaunch, isFalse);
      },
    );
  });

  group(
    'Given a server pubspec with flutter_apps device and forwarded options',
    () {
      setUpAll(() async {
        var projectDir = _createProject(
          pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
      device: chrome
      target: lib/main_admin.dart
      web-port: 8090
      release: true
      pub: false
      dart-define:
        - API_URL=https://example.com
        - FLAVOR=admin
    Portal:
      path: ../my_project_customer_flutter
''',
          includeFlutterApps: true,
        );
        await projectDir.create();
      });

      test(
        'when loading flutter apps '
        'then device is read and non-reserved properties are forwarded to flutter run',
        () {
          final apps = _loadApps();

          expect(apps[0].name, 'Admin');
          expect(apps[0].device, 'chrome');
          expect(apps[0].extraRunArgs, [
            '--target=lib/main_admin.dart',
            '--web-port=8090',
            '--release',
            '--no-pub',
            '--dart-define=API_URL=https://example.com',
            '--dart-define=FLAVOR=admin',
          ]);

          // Unset device falls back to the launch-time default (null here), and
          // an app with no extra properties forwards nothing.
          expect(apps[1].name, 'Portal');
          expect(apps[1].device, isNull);
          expect(apps[1].extraRunArgs, isEmpty);
        },
      );
    },
  );

  group('Given a server pubspec with flutter_apps dart-define as a map', () {
    setUpAll(() async {
      var projectDir = _createProject(
        pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
      dart-define:
        API_URL: https://example.com
        FLAVOR: admin
''',
        includeFlutterApps: true,
      );
      await projectDir.create();
    });

    test(
      'when loading flutter apps '
      'then map values are forwarded like list items',
      () {
        final apps = _loadApps();

        expect(apps[0].extraRunArgs, [
          '--dart-define=API_URL=https://example.com',
          '--dart-define=FLAVOR=admin',
        ]);
      },
    );
  });

  group('Given a server pubspec with a non-string device', () {
    setUpAll(() async {
      var projectDir = _createProject(
        pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
      device: true
''',
      );
      await projectDir.create();
    });

    test(
      'when loading flutter apps '
      'then SourceSpanFormatException is thrown',
      () {
        expect(
          _loadApps,
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "Admin" flutter app "device" property must be a non-empty '
                  'string.',
            ),
          ),
        );
      },
    );
  });

  group('Given a server pubspec with a non-boolean auto_launch', () {
    setUpAll(() async {
      var projectDir = _createProject(
        pubspecServerpodSection: '''
serverpod:
  flutter_apps:
    Admin:
      path: ../my_project_flutter
      auto_launch: yes-please
''',
      );
      await projectDir.create();
    });

    test(
      'when loading flutter apps '
      'then SourceSpanFormatException is thrown',
      () {
        expect(
          _loadApps,
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "Admin" flutter app "auto_launch" property must be a '
                  'boolean.',
            ),
          ),
        );
      },
    );
  });

  group(
    'Given a server pubspec without flutter_apps and an existing default Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(includeDefaultFlutterApp: true);
        await projectDir.create();
      });

      test(
        'when loading flutter apps '
        'then one synthesized FlutterAppConfig is returned',
        () {
          final apps = _loadApps();

          expect(apps, hasLength(1));
          expect(apps.first.name, 'my_project');
          expect(apps.first.relativePathParts, ['..', 'my_project_flutter']);
          // The synthesized default sibling app auto-launches, as before.
          expect(apps.first.autoLaunch, isTrue);
        },
      );

      test(
        'when loading flutter apps '
        'then synthesized app pathParts resolve correctly',
        () {
          final apps = _loadApps();

          expect(apps.first.hasPackage, isTrue);
          expect(
            path.joinAll(apps.first.pathParts),
            path.join(_serverRoot(), '..', 'my_project_flutter'),
          );
        },
      );
    },
  );

  group(
    'Given a server pubspec without flutter_apps and no sibling Flutter package',
    () {
      setUpAll(() async {
        var projectDir = _createProject(includeDefaultFlutterApp: false);
        await projectDir.create();
      });

      test(
        'when loading flutter apps '
        'then the list is empty',
        () {
          expect(_loadApps(), isEmpty);
        },
      );
    },
  );

  group('Given a server pubspec with a flutter_apps entry missing path', () {
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
      'when loading flutter apps '
      'then SourceSpanFormatException is thrown',
      () {
        expect(
          _loadApps,
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
  });

  group('Given a server pubspec with flutter_apps that is not a map', () {
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
      'when loading flutter apps '
      'then SourceSpanFormatException is thrown',
      () {
        expect(
          _loadApps,
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
  });
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
  ];

  var siblingDirs = <d.Descriptor>[];

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
