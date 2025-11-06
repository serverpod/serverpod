import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  setUp(() async => tempDir = await Directory.systemTemp.createTemp());
  tearDown(() async => await tempDir.delete(recursive: true));

  test(
    'Given a non-existent directory when GeneratorConfig.load is called with a directory path then ServerpodProjectNotFoundException is thrown.',
    () async {
      final nonExistentPath = path.join(tempDir.path, 'nonexistent');

      await expectLater(
        GeneratorConfig.load(nonExistentPath),
        throwsA(
          isA<ServerpodProjectNotFoundException>().having(
            (e) => e.message,
            'message',
            'Failed to load pubspec.yaml. Are you running serverpod from your '
                'projects server root directory?',
          ),
        ),
      );
    },
  );

  test(
    'Given a directory without serverpod dependency when GeneratorConfig.load is called with a directory path then ServerpodProjectNotFoundException is thrown.',
    () async {
      final serverDir = Directory(path.join(tempDir.path, 'server'));
      await serverDir.create(recursive: true);

      // Create server pubspec.yaml without serverpod dependency
      final serverPubspecFile = File(path.join(serverDir.path, 'pubspec.yaml'));
      await serverPubspecFile.writeAsString('''
name: test_server
dependencies:
  http: ^1.0.0
''');

      // Create client pubspec.yaml
      final clientDir = Directory(path.join(tempDir.path, 'test_client'));
      await clientDir.create(recursive: true);
      final clientPubspecFile = File(path.join(clientDir.path, 'pubspec.yaml'));
      await clientPubspecFile.writeAsString('''
name: test_client
dependencies:
  http: ^1.0.0
''');

      await expectLater(
        GeneratorConfig.load(serverDir.path),
        throwsA(
          isA<ServerpodProjectNotFoundException>().having(
            (e) => e.message,
            'message',
            'Could not find the Serverpod dependency in the directory ${serverDir.path}. Are you running serverpod from your '
                'projects root directory?',
          ),
        ),
      );
    },
  );
}
