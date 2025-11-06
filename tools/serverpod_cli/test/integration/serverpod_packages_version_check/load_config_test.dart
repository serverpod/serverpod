import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  setUp(() async => tempDir = await Directory.systemTemp.createTemp());
  tearDown(() async => await tempDir.delete(recursive: true));

  Future<File> getServerPubspecFile() async {
    final file = File(path.join(tempDir.path, 'server', 'pubspec.yaml'));
    await file.create(recursive: true);
    return file;
  }

  test('Given a missing server pubspec.yaml '
      'when calling GeneratorConfig.load '
      'then a ServerpodProjectNotFoundException is thrown', () async {
    await expectLater(
      GeneratorConfig.load((await getServerPubspecFile()).parent.path),
      throwsA(
        isA<ServerpodProjectNotFoundException>().having(
          (e) => e.message,
          'message',
          'Failed to load pubspec.yaml. Are you running serverpod from your '
              'projects server root directory?',
        ),
      ),
    );
  });

  test('Given an invalid server pubspec.yaml '
      'when calling GeneratorConfig.load '
      'then a ServerpodProjectNotFoundException is thrown', () async {
    var serverPubspecFile = await getServerPubspecFile();
    await serverPubspecFile.writeAsString('invalid yaml');
    // TODO: https://github.com/serverpod/serverpod/issues/3298
    // particular bad error message in this case
    await expectLater(
      GeneratorConfig.load(serverPubspecFile.parent.path),
      throwsA(
        isA<ServerpodProjectNotFoundException>().having(
          (e) => e.message,
          'message',
          'Failed to load pubspec.yaml. Are you running serverpod from your '
              'projects server root directory?',
        ),
      ),
    );
  });

  test('Given a valid server pubspec.yaml but a missing client pubspec.yaml '
      'when calling GeneratorConfig.load '
      'then a ServerpodProjectNotFoundException is thrown', () async {
    // TODO: https://github.com/serverpod/serverpod/issues/3298
    // should this even be an error?
    var serverPubspecFile = await getServerPubspecFile();
    serverPubspecFile.writeAsStringSync('''
name: x
dependencies:
  serverpod: ^1.0.0
''');
    await expectLater(
      GeneratorConfig.load(serverPubspecFile.parent.path),
      throwsA(
        isA<ServerpodProjectNotFoundException>().having(
          (e) => e.message,
          'message',
          'Failed to load client pubspec.yaml. If you are using a none default path '
              'it has to be specified in the config/generator.yaml file!',
        ),
      ),
    );
  });
}
