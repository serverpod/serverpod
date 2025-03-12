import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:test/test.dart';

Matcher isASpanHaving(Object? Function(SourceSpanSeverityException) feature,
    String description, Object? matcher) {
  return isA<SourceSpanSeverityException>()
      .having(feature, description, wrapMatcher(matcher));
}

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

      group('when calling validateServerpodPackagesVersion with older version',
          () {
        late final packageWarnings = validateServerpodPackagesVersion(
          Version(1, 0, 0),
          explicitVersion,
        );

        test(
            'then one warning is returned '
            'and the message is correct', () {
          expect(packageWarnings, [
            isASpanHaving((s) => s.message, 'message',
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion)
          ]);
        });

        test(
            'then one warning is returned '
            'and the span text is correct', () {
          expect(packageWarnings,
              [isASpanHaving((s) => s.span?.text, 'span?.text', '1.1.0')]);
        });

        test(
            'then one warning is returned '
            'and severity is warning', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.severity, 'severity', SourceSpanSeverity.warning),
          ]);
        });
      });

      group('when calling validateServerpodPackagesVersion with newer version',
          () {
        late final packageWarnings = validateServerpodPackagesVersion(
          Version(1, 2, 0),
          explicitVersion,
        );

        test(
            'then one warning is returned '
            'and the message is correct', () {
          expect(packageWarnings, [
            isASpanHaving((s) => s.message, 'message',
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion)
          ]);
        });

        test(
            'then one warning is returned '
            'and the span text is correct', () {
          expect(packageWarnings,
              [isASpanHaving((s) => s.span?.text, 'span?.text', '1.1.0')]);
        });

        test(
            'then one warning is returned '
            'and severity is warning', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.severity, 'severity', SourceSpanSeverity.warning),
          ]);
        });
      });
    });

    group('with approximate serverpod package version', () {
      late final approximateVersion = PubspecPlus.fromFile(
          File(p.join(testAssetsPath, 'approximate_1.1.0', 'pubspec.yaml')));

      group('when calling validateServerpodPackagesVersion matching version',
          () {
        late final cliVersion = Version(1, 1, 0);
        late final packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );

        test(
            'then one warning is returned '
            'and the message is correct', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.approximateVersion(
                    cliVersion))
          ]);
        });

        test(
            'then one warning is returned '
            'and the span is correct', () {
          expect(packageWarnings, [
            isASpanHaving((s) => s.span?.text, 'span?.text', '^1.1.0'),
          ]);
        });

        test(
            'then one warning is returned '
            'and severity is warning', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.severity, 'severity', SourceSpanSeverity.warning),
          ]);
        });
      });

      group('when calling validateServerpodPackagesVersion with older version',
          () {
        late final cliVersion = Version(1, 0, 0);
        late final packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );
        test(
            'then two warnings are returned '
            'and the messages are correct', () {
          expect(packageWarnings, [
            isASpanHaving(
              (s) => s.message,
              'message',
              ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
            ),
            isASpanHaving(
              (s) => s.message,
              'message',
              ServerpodPackagesVersionCheckWarnings.approximateVersion(
                cliVersion,
              ),
            )
          ]);
        });

        test('then the span texts are correct', () {
          expect(
              packageWarnings,
              everyElement(
                  isASpanHaving((s) => s.span?.text, 'span?.text', '^1.1.0')));
        });

        test('then the severity is warning', () {
          expect(
              packageWarnings,
              everyElement(isASpanHaving(
                  (s) => s.severity, 'severity', SourceSpanSeverity.warning)));
        });
      });

      group('when calling validateServerpodPackagesVersion with newer version',
          () {
        var cliVersion = Version(1, 2, 0);
        var packageWarnings = validateServerpodPackagesVersion(
          cliVersion,
          approximateVersion,
        );

        test(
            'then one warning is returned '
            'and the message is correct', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.approximateVersion(
                    cliVersion))
          ]);
        });

        test(
            'then one warning is returned '
            'and the span text is correct', () {
          expect(packageWarnings,
              [isASpanHaving((s) => s.span?.text, 'span?.text', '^1.1.0')]);
        });

        test(
            'then one warning is returned '
            'and severity is warning', () {
          expect(packageWarnings, [
            isASpanHaving(
                (s) => s.severity, 'severity', SourceSpanSeverity.warning)
          ]);
        });
      });
    });
  });
}
