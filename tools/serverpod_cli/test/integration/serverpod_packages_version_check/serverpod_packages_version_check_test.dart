import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = p.join(
    'test',
    'integration',
    'serverpod_packages_version_check',
    'test_assets',
  );
  group('Given a pubspec.yaml', () {
    group('with explicit serverpod package version', () {
      late final explicitVersion = PubspecPlus.fromFile(
          File(p.join(testAssetsPath, 'explicit_1.1.0', 'pubspec.yaml')));

      test(
          'when calling validateServerpodPackagesVersion with same version '
          'then no warnings are returned', () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 1, 0),
          explicitVersion,
        );

        expect(packageWarnings, isEmpty);
      });

      test(
          'when calling validateServerpodPackagesVersion with older version '
          'then one warning is returned'
          ' and the message is correct'
          ' and the span is correct'
          ' and severity is warning', () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 0, 0),
          explicitVersion,
        );

        expect(packageWarnings, [
          isA<SourceSpanSeverityException>()
              .having((s) => s.message, 'message',
                  ServerpodPackagesVersionCheckWarnings.incompatibleVersion)
              .having((s) => s.span?.text, 'span?.text', '1.1.0')
              .having(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning),
        ]);
      });

      test(
          'when calling validateServerpodPackagesVersion with newer version '
          'then one warning is returned'
          ' and the message is correct'
          ' and the span is correct'
          ' and severity is warning', () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 2, 0),
          explicitVersion,
        );

        expect(packageWarnings, [
          isA<SourceSpanSeverityException>()
              .having((s) => s.message, 'message',
                  ServerpodPackagesVersionCheckWarnings.incompatibleVersion)
              .having((s) => s.span?.text, 'span?.text', '1.1.0')
              .having(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning),
        ]);
      });
    });

    group('with approximate serverpod package version', () {
      late final approximateVersion = PubspecPlus.fromFile(
          File(p.join(testAssetsPath, 'approximate_1.1.0', 'pubspec.yaml')));

      test(
          'when calling validateServerpodPackagesVersion matching version '
          'then one warning is returned'
          ' and the message is correct'
          ' and the span is correct'
          ' and severity is warning', () {
        var cliVersion = Version(1, 1, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );

        expect(packageWarnings, [
          isA<SourceSpanSeverityException>()
              .having(
                  (s) => s.message,
                  'message',
                  ServerpodPackagesVersionCheckWarnings.approximateVersion(
                      cliVersion))
              .having((s) => s.span?.text, 'span?.text', '^1.1.0')
              .having(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning),
        ]);
      });

      test(
          'when calling validateServerpodPackagesVersion with older version'
          'then two warnings are returned'
          ' and the messages are correct'
          ' and the spans are correct'
          ' and the severity is warning', () {
        var cliVersion = Version(1, 0, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );

        expect(packageWarnings, [
          isA<SourceSpanSeverityException>()
              .having((s) => s.message, 'message',
                  ServerpodPackagesVersionCheckWarnings.incompatibleVersion)
              .having((s) => s.span?.text, 'span?.text', '^1.1.0')
              .having(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning),
          isA<SourceSpanSeverityException>()
              .having(
                  (s) => s.message,
                  'message',
                  ServerpodPackagesVersionCheckWarnings.approximateVersion(
                      cliVersion))
              .having((s) => s.span?.text, 'span?.text', '^1.1.0')
              .having(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning),
        ]);
      });

      test(
          'when calling validateServerpodPackagesVersion with newer version'
          'then one warning is returned'
          ' and the message is correct'
          ' and the span is correct'
          ' and severity is warning', () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );

        expect(
            packageWarnings,
            equals([
              isA<SourceSpanSeverityException>()
                  .having(
                      (s) => s.message,
                      'message',
                      ServerpodPackagesVersionCheckWarnings.approximateVersion(
                          cliVersion))
                  .having((s) => s.span?.text, 'span?.text', '^1.1.0')
                  .having(
                      (s) => s.severity, 'severity', SourceSpanSeverity.warning)
            ]));
      });
    });
  });
}
