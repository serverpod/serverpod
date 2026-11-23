import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Given the serverpod package, '
      'when reading the exported serverpodVersion, '
      'then it matches the version in the package pubspec.', () {
    var pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as Map;

    expect(serverpodVersion, pubspec['version']);
  });
}
