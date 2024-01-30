import 'dart:io';

import 'package:path/path.dart' as path;

Future createTestEnvironment(
    Directory testProjectDirectory, String pathToServerpodRoot) async {
  var pubspecFile = File(path.join(testProjectDirectory.path, 'pubspec.yaml'));
  pubspecFile.createSync(recursive: true);

  /// TODO: the serverpod import is brittle here, this should be refactored if
  /// these tests stay around.
  /// But the goal is to remove the structure of these tests once we have
  /// refactored the analyzer.
  pubspecFile.writeAsStringSync('''
name: test_server
description: Starting point for a Serverpod server.

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod:
    path: $pathToServerpodRoot/packages/serverpod

dev_dependencies:
  lints: ^3.0.0

dependency_overrides:
  serverpod_shared:
    path: $pathToServerpodRoot/packages/serverpod_shared
  serverpod_serialization:
    path: $pathToServerpodRoot/packages/serverpod_serialization
  serverpod_service_client:
    path: $pathToServerpodRoot/packages/serverpod_service_client
  serverpod_lints:
    path: $pathToServerpodRoot/packages/serverpod_lints
  serverpod_client:
    path: $pathToServerpodRoot/packages/serverpod_client
''');

  var result = await Process.run(
    'dart',
    [
      'pub',
      'get',
    ],
    workingDirectory:
        path.join(Directory.current.path, testProjectDirectory.path),
  );

  assert(result.exitCode == 0, 'Failed to run pub get.');
}
