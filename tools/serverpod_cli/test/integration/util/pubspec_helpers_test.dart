import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath =
      Directory(p.join('test', 'integration', 'util', 'test_assets', 'pubspec_helpers'));
  group('findPubspecFiles', () {
    test('.findPubspecFiles() recursively find pubspec file in test assets',
        () {
      var files = findPubspecsFiles(testAssetsPath);

      expect(files.length, equals(1));
    });

    test(
        '.findPubspecFiles() recursively tries to find pubspec file placed in ignored folder',
        () {
      var files = findPubspecsFiles(testAssetsPath,
          ignorePaths: ['conditionally_ignored']);

      expect(files.length, equals(0));
    });
  });

  group('shouldBeIgnored', () {
    test('should return true when path is within an ignorePath', () {
      var ignorePaths = [p.join('path', 'subdirectory')];
      var path = p.join('ignore', 'path', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isTrue);
    });

    test('should return true when folder is within an ignorePath but not root',
        () {
      var ignorePaths = ['path'];
      var path = p.join('ignore', 'path', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isTrue);
    });

    test('should return false when path is not within any ignorePath', () {
      var ignorePaths = [p.join('ignore', 'path')];
      var path = p.join('another', 'path', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isFalse);
    });

    test('should return false when ignorePaths is empty', () {
      List<String> ignorePaths = [];
      var path = p.join('any', 'path', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isFalse);
    });

    test('should return false when ignorePaths is part of folder name in path',
        () {
      List<String> ignorePaths = ['part'];
      var path = p.join('any', 'path', 'part_of', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isFalse);
    });
  });
}
