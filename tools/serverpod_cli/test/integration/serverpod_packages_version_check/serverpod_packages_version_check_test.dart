import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:test/test.dart';

Matcher isASpanWith(
  Object? Function(SourceSpanSeverityException) feature,
  String description,
  Object? matcher,
) {
  return isA<SourceSpanSeverityException>().having(
    feature,
    description,
    wrapMatcher(matcher),
  );
}

void main() {
  group('Given a pubspec.yaml', () {
    group('with explicit serverpod package version', () {
      late final explicitVersion = PubspecPlus.parse('''
name: x
dependencies:
  serverpod_cloud_lints: 0.9.0 # ignored as this dependency is not relevant for codegen
  serverpod_client: 1.1.0
''');

      test('when calling validateServerpodPackagesVersion with same version '
          'then no warnings are returned', () {
        var packageWarnings = validateServerpodPackagesVersion(
          Version(1, 1, 0),
          explicitVersion,
        );

        expect(packageWarnings, isEmpty);
      });

      group(
        'when calling validateServerpodPackagesVersion with older version',
        () {
          late final packageWarnings = validateServerpodPackagesVersion(
            Version(1, 0, 0),
            explicitVersion,
          );

          test('then one warning is returned with correct message', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
              ),
            ]);
          });

          test('then one warning is returned with correct span text', () {
            expect(packageWarnings, [
              isASpanWith((s) => s.span?.text, 'span?.text', '1.1.0'),
            ]);
          });

          test('then one warning is returned with warning as severity', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.severity,
                'severity',
                SourceSpanSeverity.warning,
              ),
            ]);
          });
        },
      );

      group(
        'when calling validateServerpodPackagesVersion with newer version',
        () {
          late final packageWarnings = validateServerpodPackagesVersion(
            Version(1, 2, 0),
            explicitVersion,
          );

          test('then one warning is returned with correct message', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
              ),
            ]);
          });

          test('then one warning is returned with correct span text', () {
            expect(packageWarnings, [
              isASpanWith((s) => s.span?.text, 'span?.text', '1.1.0'),
            ]);
          });

          test('then one warning is returned with severity warning', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.severity,
                'severity',
                SourceSpanSeverity.warning,
              ),
            ]);
          });
        },
      );
    });

    group('with approximate serverpod package version', () {
      late final approximateVersion = PubspecPlus.parse('''
name: x
dependencies:
  serverpod_cloud_lints: 0.9.0 # ignored as this dependency is not relevant for codegen
  serverpod_client: ^1.1.0
''');

      group(
        'when calling validateServerpodPackagesVersion matching version',
        () {
          late final cliVersion = Version(1, 1, 0);
          late final packageWarnings = validateServerpodPackagesVersion(
            cliVersion,
            approximateVersion,
          );

          test('then one warning is returned with the correct message', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.approximateVersion(
                  cliVersion,
                ),
              ),
            ]);
          });

          test('then one warning is returned with correct span text', () {
            expect(packageWarnings, [
              isASpanWith((s) => s.span?.text, 'span?.text', '^1.1.0'),
            ]);
          });

          test('then one warning is returned with severity warning', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.severity,
                'severity',
                SourceSpanSeverity.warning,
              ),
            ]);
          });
        },
      );

      group(
        'when calling validateServerpodPackagesVersion with older version',
        () {
          late final cliVersion = Version(1, 0, 0);
          late final packageWarnings = validateServerpodPackagesVersion(
            cliVersion,
            approximateVersion,
          );
          test('then two warnings are returned with correct messages', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
              ),
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.approximateVersion(
                  cliVersion,
                ),
              ),
            ]);
          });

          test('then the span texts are correct', () {
            expect(
              packageWarnings,
              everyElement(
                isASpanWith((s) => s.span?.text, 'span?.text', '^1.1.0'),
              ),
            );
          });

          test('then the severity is warning', () {
            expect(
              packageWarnings,
              everyElement(
                isASpanWith(
                  (s) => s.severity,
                  'severity',
                  SourceSpanSeverity.warning,
                ),
              ),
            );
          });
        },
      );

      group(
        'when calling validateServerpodPackagesVersion with newer version',
        () {
          var cliVersion = Version(1, 2, 0);
          var packageWarnings = validateServerpodPackagesVersion(
            cliVersion,
            approximateVersion,
          );

          test('then one warning is returned with correct message', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.message,
                'message',
                ServerpodPackagesVersionCheckWarnings.approximateVersion(
                  cliVersion,
                ),
              ),
            ]);
          });

          test('then one warning is returned with correct span text', () {
            expect(packageWarnings, [
              isASpanWith((s) => s.span?.text, 'span?.text', '^1.1.0'),
            ]);
          });

          test('then one warning is returned with severity warning', () {
            expect(packageWarnings, [
              isASpanWith(
                (s) => s.severity,
                'severity',
                SourceSpanSeverity.warning,
              ),
            ]);
          });
        },
      );
    });
  });
}
