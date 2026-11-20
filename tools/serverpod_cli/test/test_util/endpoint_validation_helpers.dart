import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';

/// Resolves the absolute path to the serverpod monorepo root via the test
/// isolate's package config. The previous `Directory('../..')` approach
/// breaks when dart_test sandboxes [Directory.current] in concurrent runs.
Future<String> resolveServerpodRoot() async {
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

/// Absolute path to `tools/serverpod_cli/bin/serverpod_cli.dart`.
Future<String> resolveServerpodCliEntrypoint() async {
  final root = await resolveServerpodRoot();
  return path.join(root, 'tools', 'serverpod_cli', 'bin', 'serverpod_cli.dart');
}

/// Skip reason for tests that analyze primary constructors, which are only
/// available from language version 3.13. Is `null` when the running Dart SDK
/// supports them.
String? get skipUnlessPrimaryConstructorsSupported {
  var sdkVersion = Version.parse(Platform.version.split(' ').first);
  if (sdkVersion >= Version(3, 13, 0)) return null;

  return 'Primary constructors require Dart 3.13.0 or later.';
}

Future createTestEnvironment(
  Directory testProjectDirectory, {
  String sdkConstraint = '>=3.0.0 <4.0.0',
}) async {
  final pathToServerpodRoot = await resolveServerpodRoot();

  var pubspecFile = File(path.join(testProjectDirectory.path, 'pubspec.yaml'));
  pubspecFile.createSync(recursive: true);

  pubspecFile.writeAsStringSync('''
name: test_server
description: Starting point for a Serverpod server.

environment:
  sdk: '$sdkConstraint'

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
  serverpod_embedded_postgres:
    path: $pathToServerpodRoot/packages/serverpod_embedded_postgres
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
