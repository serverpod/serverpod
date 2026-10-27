import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/copy_directory.dart';
import 'package:test/test.dart';

import '../test_util/file_system_entity_helpers.dart';

void main() {
  late Directory tempDir;
  late Directory source;
  late Directory destination;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('copy_directory_');
    source = Directory(p.join(tempDir.path, 'source'))..createSync();
    destination = Directory(p.join(tempDir.path, 'destination'));
  });

  tearDown(() async {
    await tempDir.deleteWithRetry(recursive: true);
  });

  test(
    'Given a directory with nested binary files and an empty directory, '
    'when copied without exclusions, '
    'then the complete tree and file contents are preserved.',
    () {
      final bytes = [0, 255, 128, 10, 13];
      File(p.join(source.path, 'nested', 'asset.bin'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);
      Directory(p.join(source.path, 'empty')).createSync();
      File(p.join(source.path, '.hidden')).writeAsStringSync('hidden');

      copyDirectory(source, destination);

      expect(
        File(p.join(destination.path, 'nested', 'asset.bin')).readAsBytesSync(),
        bytes,
      );
      expect(Directory(p.join(destination.path, 'empty')).existsSync(), isTrue);
      expect(
        File(p.join(destination.path, '.hidden')).readAsStringSync(),
        'hidden',
      );
    },
  );

  test(
    'Given cache directories and override files at multiple depths, '
    'when copied with excluded names, '
    'then only the remaining files are copied.',
    () {
      File(p.join(source.path, '.dart_tool', 'cache'))
        ..createSync(recursive: true)
        ..writeAsStringSync('cache');
      File(p.join(source.path, 'nested', '.dart_tool', 'cache'))
        ..createSync(recursive: true)
        ..writeAsStringSync('cache');
      File(
        p.join(source.path, 'pubspec_overrides.yaml'),
      ).writeAsStringSync('host paths');
      File(
        p.join(source.path, 'nested', 'pubspec_overrides.yaml'),
      ).writeAsStringSync('host paths');
      File(
        p.join(source.path, 'nested', 'pubspec.yaml'),
      ).writeAsStringSync('name: nested');

      copyDirectory(
        source,
        destination,
        ignoreFileNames: {'.dart_tool', 'pubspec_overrides.yaml'},
      );

      expect(
        destination
            .listSync(recursive: true)
            .map(
              (entry) => p.relative(entry.path, from: destination.path),
            ),
        unorderedEquals(['nested', p.join('nested', 'pubspec.yaml')]),
      );
      expect(
        File(
          p.join(destination.path, 'nested', 'pubspec.yaml'),
        ).readAsStringSync(),
        'name: nested',
      );
    },
  );
}
