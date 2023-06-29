import 'dart:io';

import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = Directory('test/util/test_assets/pubspec_helpers');
  group('findPubspecFiles', () {
    test('PubspecFile_findingPubspecFiles_FoundOnePubspecFile', () {
      var files = findPubspecsFiles(testAssetsPath);

      expect(files.length, equals(1));
    });

    test('PubspecFileInIgnoredPath_FindingPubspecFiles_NoPubspecFileFound', () {
      var files = findPubspecsFiles(testAssetsPath,
          ignorePaths: ['conditionally_ignored']);

      expect(files.length, equals(0));
    });
  });
}
