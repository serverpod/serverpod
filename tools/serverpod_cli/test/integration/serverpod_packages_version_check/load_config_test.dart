import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:test/test.dart';

void main() {
  final root = Directory.current;
  final testAssetsPath = path.join(
    root.path,
    'test',
    'integration',
    'serverpod_packages_version_check',
    'test_assets',
  );

  test(
      'Given a missing server pubspec.yaml '
      'then a ServerpodProjectNotFoundException is thrown', () async {
    final missingPubspecDir = Directory.systemTemp.createTempSync();
    await expectLater(
      GeneratorConfig.load(missingPubspecDir.path),
      throwsA(isA<ServerpodProjectNotFoundException>()),
    );
    await missingPubspecDir.delete();
  });

  test(
      'Given an invalid server pubspec.yaml '
      'then a ServerpodProjectNotFoundException is thrown', () {
    // TODO(nielsenko):
    // This is current behavior, but I think it should be
    // the SourceSpanException raised by Pubspec.parse to give the user
    // a more detailed error message.
    expectLater(
      GeneratorConfig.load(path.join(testAssetsPath, 'invalid_pubspec')),
      throwsA(isA<ServerpodProjectNotFoundException>()),
    );
  });

  test(
      'Given a valid server pubspec.yaml'
      ' and a missing client pubspec.yaml '
      'then a ServerpodProjectNotFoundException is thrown', () {
    // TODO(nielsenko):
    // This is current behavior, but I perhaps it should depend on config
    // if a client project is generated or not.
    // (see https://github.com/serverpod/serverpod/pull/3273#discussion_r1982987504)
    expectLater(
      GeneratorConfig.load(
          path.join(testAssetsPath, 'valid_pubspec_missing_client')),
      throwsA(isA<ServerpodProjectNotFoundException>()),
    );
  });
}
