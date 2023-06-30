import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath =
      p.join('test', 'serverpod_packages_version_check', 'test_assets');
  group('performServerpodPackagesVersionCheck', () {
    test(
        '.performServerpodPackagesVersionCheck() when there are no pubspec files',
        () {
      var packageWarnings = performServerpodPackagesAndCliVersionCheck(
        Version(1, 1, 0),
        Directory(p.join(testAssetsPath, 'empty_folder')),
      );

      expect(packageWarnings.isEmpty, equals(true));
    });

    group('With explicit serverpod package version', () {
      var explicitVersionPath =
          Directory(p.join(testAssetsPath, 'explicit_1.1.0'));
      test('.performServerpodPackagesVersionCheck() with same version', () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 1, 0),
          explicitVersionPath,
        );

        expect(packageWarnings.isEmpty, equals(true));
      });

      test('.performServerpodPackagesVersionCheck() with older version', () {
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          Version(1, 0, 0),
          explicitVersionPath,
        );

        expect(packageWarnings.length, equals(1));
        expect(packageWarnings.first.message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
      });

      test('.performServerpodPackagesVersionCheck() with newer version', () {
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
      test('.performServerpodPackagesVersionCheck() with same version', () {
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

      test('.performServerpodPackagesVersionCheck() with older version', () {
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

      test('.performServerpodPackagesVersionCheck() with newer version', () {
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
      test('.performServerpodPackagesVersionCheck() with same version', () {
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

      test('.performServerpodPackagesVersionCheck() with older version', () {
        var cliVersion = Version(1, 0, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          testAssets,
        );

        expect(packageWarnings.length, equals(3));
        expect(packageWarnings[0].message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
        expect(packageWarnings[1].message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
        expect(
            packageWarnings[2].message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });

      test('.performServerpodPackagesVersionCheck() with newer version', () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = performServerpodPackagesAndCliVersionCheck(
          cliVersion,
          testAssets,
        );

        expect(packageWarnings.length, equals(2));
        expect(packageWarnings[0].message,
            ServerpodPackagesVersionCheckWarnings.incompatibleVersion);
        expect(
            packageWarnings[1].message,
            ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion));
      });
    });
  });
}
