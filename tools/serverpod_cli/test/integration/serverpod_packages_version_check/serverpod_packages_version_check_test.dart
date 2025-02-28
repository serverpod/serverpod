import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/pubspec_plus.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = p.join(
    'test',
    'integration',
    'serverpod_packages_version_check',
    'test_assets',
  );
  group('performServerpodPackagesAndCliVersionCheck', () {
    group('With explicit serverpod package version', () {
      var explicitVersion = PubspecPlus.fromFile(
          File(p.join(testAssetsPath, 'explicit_1.1.0', 'pubspec.yaml')));
      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 1, 0),
          explicitVersion,
        );

        expect(packageWarnings, isEmpty);
      });

      test('performServerpodPackagesAndCliVersionCheck() with older version',
          () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 0, 0),
          explicitVersion,
        );

        expect(packageWarnings.length, equals(1));
        expect(packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
      });

      test('performServerpodPackagesAndCliVersionCheck() with newer version',
          () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 2, 0),
          explicitVersion,
        );

        expect(packageWarnings.length, equals(1));
        expect(packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
      });
    });

    group('With approximate serverpod package version', () {
      var approximateVersionPath = PubspecPlus.fromFile(
          File(p.join(testAssetsPath, 'approximate_1.1.0', 'pubspec.yaml')));

      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersionPath,
        );

        expect(packageWarnings.length, equals(1));
        expect(
            packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });

      test('performServerpodPackagesAndCliVersionCheck() with older version',
          () {
        var cliVersion = Version(1, 0, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersionPath,
        );

        expect(packageWarnings.map((w) => w.message), [
          ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
          ServerpodPackagesVersionCheckWarnings.approximateVersion(cliVersion)
        ]);
      });

      test('performServerpodPackagesAndCliVersionCheck() with newer version',
          () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersionPath,
        );

        expect(packageWarnings.length, equals(1));
        expect(
            packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });
    });

    group('With multiple pubspec files', () {
      var testAssets = Directory(testAssetsPath)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => p.basename(f.path) == 'pubspec.yaml')
          .map(PubspecPlus.fromFile);

      void expectWarningTypes({
        required Version cliVersion,
        required Iterable<SourceSpanException> packageWarnings,
        required int expectedIncompatibleWarnings,
        required int expectedApproximateVersionWarnings,
      }) {
        var actualIncompatibleWarnings = packageWarnings.where(
          (warning) {
            return warning.message ==
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion;
          },
        ).length;

        var actualApproximateVersionWarnings = packageWarnings.where((warning) {
          return warning.message ==
              ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion,
              );
        }).length;

        expect(
          actualIncompatibleWarnings,
          equals(expectedIncompatibleWarnings),
        );
        expect(
          actualApproximateVersionWarnings,
          equals(expectedApproximateVersionWarnings),
        );
      }

      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = [
          for (var p in testAssets)
            ...validateServerpodPackagesVersion(cliVersion, p)
        ];

        expect(packageWarnings.length, equals(1));
        expect(
            packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });

      test('performServerpodPackagesAndCliVersionCheck() with older version',
          () {
        var cliVersion = Version(1, 0, 0);
        var packageWarnings = [
          for (var p in testAssets)
            ...validateServerpodPackagesVersion(cliVersion, p)
        ];

        expect(packageWarnings.length, equals(3));
        expectWarningTypes(
          cliVersion: cliVersion,
          packageWarnings: packageWarnings,
          expectedIncompatibleWarnings: 2,
          expectedApproximateVersionWarnings: 1,
        );
      });

      test('performServerpodPackagesAndCliVersionCheck() with newer version',
          () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = [
          for (var p in testAssets)
            ...validateServerpodPackagesVersion(cliVersion, p)
        ];

        expect(packageWarnings.length, equals(2));
        expectWarningTypes(
          cliVersion: cliVersion,
          packageWarnings: packageWarnings,
          expectedIncompatibleWarnings: 1,
          expectedApproximateVersionWarnings: 1,
        );
      });
    });
  });
}
