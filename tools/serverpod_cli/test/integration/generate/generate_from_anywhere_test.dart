import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  Future<Directory> createMockServerpodProject({
    required String projectName,
  }) async {
    var serverDir = Directory(path.join(d.sandbox, '${projectName}_server'));
    await serverDir.create(recursive: true);

    var protocolDir = Directory(
      path.join(serverDir.path, 'lib', 'src', 'protocol'),
    );
    await protocolDir.create(recursive: true);

    var configDir = Directory(path.join(serverDir.path, 'config'));
    await configDir.create(recursive: true);

    var dartToolDir = Directory(path.join(serverDir.path, '.dart_tool'));
    await dartToolDir.create(recursive: true);
    var packageConfigFile = File(
      path.join(dartToolDir.path, 'package_config.json'),
    );
    await packageConfigFile.writeAsString('''
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
''');

    var serverPubspecFile = File(path.join(serverDir.path, 'pubspec.yaml'));
    await serverPubspecFile.writeAsString('''
name: ${projectName}_server
dependencies:
  serverpod: ^2.0.0
''');

    var clientDir = Directory(path.join(d.sandbox, '${projectName}_client'));
    await clientDir.create(recursive: true);
    var clientLibDir = Directory(
      path.join(clientDir.path, 'lib', 'src', 'protocol'),
    );
    await clientLibDir.create(recursive: true);
    var clientPubspecFile = File(path.join(clientDir.path, 'pubspec.yaml'));
    await clientPubspecFile.writeAsString('''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
''');

    return serverDir;
  }

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

        var clientDir = Directory(path.join(d.sandbox, 'myapp_client'));

        var originalDir = Directory.current;
        Directory.current = clientDir;

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

        var protocolDir = Directory(
          path.join(d.sandbox, 'myapp_server', 'lib', 'src', 'protocol'),
        );

        var originalDir = Directory.current;
        Directory.current = protocolDir;

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
        var emptyDir = Directory(path.join(d.sandbox, 'empty'));
        await emptyDir.create(recursive: true);

        var originalDir = Directory.current;
        Directory.current = emptyDir;

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
