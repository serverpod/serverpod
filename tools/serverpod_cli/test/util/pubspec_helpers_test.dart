import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath =
      Directory(p.join('test', 'util', 'test_assets', 'pubspec_helpers'));
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
}
