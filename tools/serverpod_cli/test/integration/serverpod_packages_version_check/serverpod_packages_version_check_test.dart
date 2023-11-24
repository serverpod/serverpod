import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
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
    group('With empty folder', () {
      var emptyFolder = Directory(p.join(testAssetsPath, 'empty_folder'));
      setUp(() {
        if (!emptyFolder.existsSync()) {
          emptyFolder.createSync();
        }
      });

      tearDown(() {
        if (emptyFolder.existsSync()) {
          emptyFolder.deleteSync();
        }
      });

      test('performServerpodPackagesAndCliVersionCheck()', () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 1, 0),
          emptyFolder,
        );

        expect(packageWarnings.isEmpty, equals(true));
      });
    });

    group('With explicit serverpod package version', () {
      var explicitVersionPath =
          Directory(p.join(testAssetsPath, 'explicit_1.1.0'));
      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 1, 0),
          explicitVersionPath,
        );

        expect(packageWarnings.isEmpty, equals(true));
      });

      test('performServerpodPackagesAndCliVersionCheck() with older version',
          () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 0, 0),
          explicitVersionPath,
        );

        expect(packageWarnings.length, equals(1));
        expect(packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
      });

      test('performServerpodPackagesAndCliVersionCheck() with newer version',
          () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 2, 0),
          explicitVersionPath,
        );

        expect(packageWarnings.length, equals(1));
        expect(packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
      });
    });

    group('With approximate serverpod package version', () {
      var approximateVersionPath =
          Directory(p.join(testAssetsPath, 'approximate_1.1.0'));
      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
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
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          approximateVersionPath,
        );

        expect(packageWarnings.length, equals(2));
        expect(packageWarnings[0].message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
        expect(
            packageWarnings[1].message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });

      test('performServerpodPackagesAndCliVersionCheck() with newer version',
          () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
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
      var testAssets = Directory(testAssetsPath);

      void expectWarningTypes({
        required Version cliVersion,
        required List<SourceSpanException> packageWarnings,
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
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 1, 0),
          testAssets,
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
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          testAssets,
        );

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
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          testAssets,
        );

        expect(packageWarnings.length, equals(2));
        expectWarningTypes(
          cliVersion: cliVersion,
          packageWarnings: packageWarnings,
          expectedIncompatibleWarnings: 1,
          expectedApproximateVersionWarnings: 1,
        );
      });
    });

    group('With corrupted pubspec', () {
      var corruptedPubspecPath =
          Directory(p.join(testAssetsPath, 'corrupted_pubspec'));
      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          corruptedPubspecPath,
        );

        expect(packageWarnings.isEmpty, isTrue);
      });
    });

    group('With approximate serverpod package version in vendor folder', () {
      var vendorPubspecPath = Directory(p.join(testAssetsPath, 'vendor'));

      test('performServerpodPackagesAndCliVersionCheck() with same version',
          () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          vendorPubspecPath,
        );

        expect(packageWarnings.isEmpty, isTrue);
      });
    });
  });
}
