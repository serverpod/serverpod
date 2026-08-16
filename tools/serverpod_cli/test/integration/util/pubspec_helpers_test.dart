import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = Directory(
    p.join('test', 'integration', 'util', 'test_assets', 'pubspec_helpers'),
  );
  group('findPubspecFiles', () {
    test(
      '.findPubspecFiles() recursively find pubspec file in test assets',
      () {
        var files = findPubspecsFiles(testAssetsPath);

        expect(files.length, equals(2));
      },
    );

    test(
      '.findPubspecFiles() recursively tries to find pubspec file placed in ignored folder',
      () {
        var files = findPubspecsFiles(
          testAssetsPath,
          ignorePaths: ['conditionally_ignored', 'pubspec_parse'],
        );

        expect(files.length, equals(0));
      },
    );
  });

  group('shouldBeIgnored', () {
    test('should return true when path is within an ignorePath', () {
      var ignorePaths = [p.join('path', 'subdirectory')];
      var path = p.join('ignore', 'path', 'subdirectory', 'file.txt');

      var result = shouldBeIgnored(path, ignorePaths);

      expect(result, isTrue);
    });

    test(
      'should return true when folder is within an ignorePath but not root',
      () {
        var ignorePaths = ['path'];
        var path = p.join('ignore', 'path', 'subdirectory', 'file.txt');

        var result = shouldBeIgnored(path, ignorePaths);

        expect(result, isTrue);
      },
    );

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

    test(
      'should return false when ignorePaths is part of folder name in path',
      () {
        List<String> ignorePaths = ['part'];
        var path = p.join('any', 'path', 'part_of', 'subdirectory', 'file.txt');

        var result = shouldBeIgnored(path, ignorePaths);

        expect(result, isFalse);
      },
    );
  });

  group('parsePubspec', () {
    test('success when parsing valid pubspec file', () {
      var file = File(
        p.join(testAssetsPath.path, 'pubspec_parse', 'pubspec.yaml'),
      );
      expect(() => parsePubspec(file), returnsNormally);
    });

    test('throw exception when parsing invalid pubspec file', () {
      var file = File(
        p.join(testAssetsPath.path, 'pubspec_parse', 'pubspec_invalid.yaml'),
      );
      expect(() => parsePubspec(file), throwsException);
    });
  });

  group('addDependencyToPubspec', () {
    group('Given a pubspec file with dependencies', () {
      test(
        'when adding a new dependency with version constraint '
        'then it is added to the dependencies section',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
  new_package: ^2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'new_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^2.0.0'),
                ),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when adding a new dependency with path '
        'then it is added to the dependencies section',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
  new_package:
    path: ../path/to/package
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'new_package',
                source: DependencySource.path('../path/to/package'),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when modifying an existing dependency from version constraint to path '
        'then it is updated',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package:
    path: ../path/to/package
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'existing_package',
                source: DependencySource.path('../path/to/package'),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when modifying an existing dependency with an updated version constraint '
        'then it is updated',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: ^2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'existing_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^2.0.0'),
                ),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when modifying an existing dependency from path to version constraint '
        'then it is updated',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package:
    path: ../path/to/package
''';

          const expected = '''
name: test
dependencies:
  existing_package: ^2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'existing_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^2.0.0'),
                ),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when modifying an existing dependency with an updated path'
        'then it is updated',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package:
    path: ../path/to/package
''';

          const expected = '''
name: test
dependencies:
  existing_package:
    path: ../path/to/new/package
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'existing_package',
                source: DependencySource.path('../path/to/new/package'),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );
    });

    test(
      'Given a pubspec file with no dependencies '
      'when adding a dependency with version constraint '
      'then it is added to the dependencies section',
      () {
        const pubspecContents = '''
name: test
version: 1.0.0
''';

        const expected = '''
dependencies:
  new_package: ^2.0.0
name: test
version: 1.0.0
''';

        final result = addDependencyToPubspec(
          pubspecContents,
          additions: [
            (
              name: 'new_package',
              source: DependencySource.version(
                VersionConstraint.parse('^2.0.0'),
              ),
              type: DependencyType.normal,
            ),
          ],
        );

        expect(result, equals(expected));
      },
    );

    group('Given a pubspec file with dependencies overrides', () {
      test(
        'when adding a dependency override for an existing package '
        'then it is added to the dependencies section',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  override_package: 2.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  existing_package: ^3.0.0
  override_package: 2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'existing_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^3.0.0'),
                ),
                type: DependencyType.override,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when adding a new dependency override, then it is added to the dependencies section',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  override_package: 2.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  new_package: ^3.0.0
  override_package: 2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'new_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^3.0.0'),
                ),
                type: DependencyType.override,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );

      test(
        'when modifying an existing dependency override, then it is updated',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  override_package: 2.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
dependency_overrides:
  override_package: ^3.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'override_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^3.0.0'),
                ),
                type: DependencyType.override,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );
    });

    group('Given a pubspec file with no dependencies overrides', () {
      test(
        'Given a pubspec file with no dependencies overrides '
        'when adding a dependency override '
        'then it is added to the dependencies section',
        () {
          const pubspecContents = '''
name: test
dependencies:
  existing_package: 1.0.0
''';

          const expected = '''
name: test
dependencies:
  existing_package: 1.0.0
  new_package: ^2.0.0
''';

          final result = addDependencyToPubspec(
            pubspecContents,
            additions: [
              (
                name: 'new_package',
                source: DependencySource.version(
                  VersionConstraint.parse('^2.0.0'),
                ),
                type: DependencyType.normal,
              ),
            ],
          );

          expect(result, equals(expected));
        },
      );
    });
  });
}
