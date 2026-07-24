import 'dart:io';

import 'package:path/path.dart' as path;

Future createTestSharedPackageEnvironment(
  Directory testSharedPackageDirectory,
) async {
  var pubspecFile = File(
    path.join(testSharedPackageDirectory.path, 'pubspec.yaml'),
  );
  pubspecFile.createSync(recursive: true);

  pubspecFile.writeAsStringSync('''
name: shared
description: A shared package for testing custom classes.

environment:
  sdk: '>=3.0.0 <4.0.0'

dev_dependencies:
  lints: '>=3.0.0 <7.0.0'
''');

  final result = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: testSharedPackageDirectory.absolute.path,
  );

  assert(
    result.exitCode == 0,
    'Failed to run pub get. exit=${result.exitCode}\n'
    'stdout: ${result.stdout}\n'
    'stderr: ${result.stderr}',
  );
}
