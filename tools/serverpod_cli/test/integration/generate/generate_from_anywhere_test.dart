import 'dart:io';

import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  group('GeneratorConfig.load with auto-detection', () {
    test(
      'Given in project root directory, '
      'when GeneratorConfig.load is called without directory parameter, '
      'then it finds the server directory',
      () async {
        await createMockServerpodProject(
          projectName: 'myapp',
        );

        var originalDir = Directory.current;
        Directory.current = Directory(d.sandbox);

        try {
          var config = await GeneratorConfig.load(interactive: false);
          expect(config.serverPackage, equals('myapp_server'));
          expect(config.name, equals('myapp'));
        } finally {
          Directory.current = originalDir;
        }
      },
    );

    test(
      'Given in client directory, '
      'when GeneratorConfig.load is called without directory parameter, '
      'then it finds the sibling server directory',
      () async {
        await createMockServerpodProject(
          projectName: 'myapp',
        );

        var clientDir = d.dir('myapp_client');

        var originalDir = Directory.current;
        Directory.current = clientDir.io;

        try {
          var config = await GeneratorConfig.load(interactive: false);
          expect(config.serverPackage, equals('myapp_server'));
          expect(config.name, equals('myapp'));
        } finally {
          Directory.current = originalDir;
        }
      },
    );

    test(
      'Given in server subdirectory (lib/src/protocol), '
      'when GeneratorConfig.load is called without directory parameter, '
      'then it finds the server directory by searching upward',
      () async {
        await createMockServerpodProject(
          projectName: 'myapp',
        );

        var protocolDir = d.dir('myapp_server', [
          d.dir('lib', [
            d.dir('src', [
              d.dir('protocol'),
            ]),
          ]),
        ]);

        var originalDir = Directory.current;
        Directory.current = protocolDir.io;

        try {
          var config = await GeneratorConfig.load(interactive: false);
          expect(config.serverPackage, equals('myapp_server'));
          expect(config.name, equals('myapp'));
        } finally {
          Directory.current = originalDir;
        }
      },
    );

    test(
      'Given explicit directory path provided, '
      'when GeneratorConfig.load is called with directory parameter, '
      'then it uses the explicit path (backward compatibility)',
      () async {
        var serverDir = await createMockServerpodProject(
          projectName: 'myapp',
        );

        var config = await GeneratorConfig.load(
          serverRootDir: serverDir.path,
          interactive: false,
        );

        expect(config.serverPackage, equals('myapp_server'));
        expect(config.name, equals('myapp'));
      },
    );

    test(
      'Given no server directory nearby, '
      'when GeneratorConfig.load is called without directory parameter, '
      'then it throws ServerpodProjectNotFoundException',
      () async {
        var emptyDir = d.dir('empty');
        await emptyDir.create();

        var originalDir = Directory.current;
        Directory.current = emptyDir.io;

        try {
          await expectLater(
            GeneratorConfig.load(interactive: false),
            throwsA(isA<ServerpodProjectNotFoundException>()),
          );
        } finally {
          Directory.current = originalDir;
        }
      },
    );
  });
}

Future<Directory> createMockServerpodProject({
  required String projectName,
}) async {
  final packageConfigContent =
      '''
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
''';

  final serverPubspecContent =
      '''
name: ${projectName}_server
dependencies:
  serverpod: ^2.0.0
''';

  var serverDir = d.dir('${projectName}_server', [
    d.dir('.dart_tool', [
      d.file('package_config.json', packageConfigContent),
    ]),
    d.dir('config'),
    d.dir('lib', [
      d.dir('src', [
        d.dir('protocol'),
      ]),
    ]),
    d.file('pubspec.yaml', serverPubspecContent),
  ]);
  await serverDir.create();

  final clientPubspecContent =
      '''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
''';

  var clientDir = d.dir('${projectName}_client', [
    d.file('pubspec.yaml', clientPubspecContent),
    d.dir('lib', [
      d.dir('src', [d.dir('protocol')]),
    ]),
  ]);
  await clientDir.create();

  return serverDir.io;
}
