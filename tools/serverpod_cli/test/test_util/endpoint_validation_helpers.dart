import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as path;

/// Resolves the absolute path to the serverpod monorepo root via the test
/// isolate's package config. The previous `Directory('../..')` approach
/// breaks when dart_test sandboxes [Directory.current] in concurrent runs.
Future<String> _resolveServerpodRoot() async {
  final uri = await Isolate.resolvePackageUri(
    Uri.parse('package:serverpod_cli/analyzer.dart'),
  );
  if (uri == null) {
    throw StateError('Could not resolve package:serverpod_cli');
  }
  // .../tools/serverpod_cli/lib/analyzer.dart -> 4 segments up.
  return path.canonicalize(
    path.join(uri.toFilePath(), '..', '..', '..', '..'),
  );
}

Future createTestEnvironment(Directory testProjectDirectory) async {
  final pathToServerpodRoot = await _resolveServerpodRoot();

  var pubspecFile = File(path.join(testProjectDirectory.path, 'pubspec.yaml'));
  pubspecFile.createSync(recursive: true);

  pubspecFile.writeAsStringSync('''
name: test_server
description: Starting point for a Serverpod server.

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod:
    path: $pathToServerpodRoot/packages/serverpod

dev_dependencies:
  lints: '>=3.0.0 <7.0.0'

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
  serverpod_database:
    path: $pathToServerpodRoot/packages/serverpod_database
''');

  final result = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: testProjectDirectory.absolute.path,
  );

  assert(
    result.exitCode == 0,
    'Failed to run pub get. exit=${result.exitCode}\n'
    'stdout: ${result.stdout}\n'
    'stderr: ${result.stderr}',
  );
}
