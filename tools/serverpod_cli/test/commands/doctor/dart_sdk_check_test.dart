import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/doctor/dart_sdk_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:test/test.dart';

final _flutterRoot = p.join(p.separator, 'opt', 'flutter');
final _bundledDart = p.join(_flutterRoot, 'bin', 'dart');
final _standaloneDart = p.join(p.separator, 'usr', 'bin', 'dart');

String _versionOutput(final String version) =>
    'Dart SDK version: $version (stable) (Tue Sep 29 01:00:52 2026 -0700) '
    'on "linux_x64"\n';

void main() {
  test(
    'Given no dart on PATH and no Flutter, '
    'when evaluating, then the status is missing with a Flutter remedy',
    () {
      final result = DartSdkCheck.evaluate(
        executable: null,
        output: null,
        flutterRoot: null,
      );

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains('Install Flutter'));
    },
  );

  test(
    'Given no dart on PATH but a Flutter SDK, '
    'when evaluating, then the remedy names the Flutter bin directory',
    () {
      final result = DartSdkCheck.evaluate(
        executable: null,
        output: null,
        flutterRoot: _flutterRoot,
      );

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains(p.join(_flutterRoot, 'bin')));
    },
  );

  test(
    'Given dart that reported no version, '
    'when evaluating, then the status is unknown',
    () {
      final result = DartSdkCheck.evaluate(
        executable: _bundledDart,
        output: 'something went wrong',
        flutterRoot: _flutterRoot,
      );

      expect(result.status, DoctorStatus.unknown);
    },
  );

  test(
    'Given the Dart bundled with Flutter, '
    'when evaluating, then the status is ready',
    () {
      final result = DartSdkCheck.evaluate(
        executable: _bundledDart,
        output: _versionOutput('3.13.5'),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, '3.13.5');
      expect(result.path, _bundledDart);
    },
  );

  test(
    'Given a Dart below the required constraint, '
    'when evaluating, then the status is incompatible',
    () {
      final result = DartSdkCheck.evaluate(
        executable: _bundledDart,
        output: _versionOutput('3.10.0'),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.incompatible);
      expect(result.message, contains('^3.12.2'));
    },
  );

  test(
    'Given a standalone Dart on PATH ahead of the Flutter SDK, '
    'when evaluating, then the status is misconfigured with a PATH remedy',
    () {
      final result = DartSdkCheck.evaluate(
        executable: _standaloneDart,
        output: _versionOutput('3.13.5'),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.misconfigured);
      expect(result.remedy, contains(p.join(_flutterRoot, 'bin')));
      expect(result.remedy, contains(p.dirname(_standaloneDart)));
    },
  );

  test(
    'Given a standalone Dart and no Flutter, '
    'when evaluating, then the status is ready',
    () {
      final result = DartSdkCheck.evaluate(
        executable: _standaloneDart,
        output: _versionOutput('3.13.5'),
        flutterRoot: null,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.ready);
    },
  );
}
