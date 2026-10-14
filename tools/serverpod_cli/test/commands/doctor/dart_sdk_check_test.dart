import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/doctor/dart_sdk_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:test/test.dart';

final _flutterRoot = p.join(p.separator, 'opt', 'flutter');
final _bundledLauncher = p.join(_flutterRoot, 'bin', 'dart');
final _bundledSdkDart = p.join(
  _flutterRoot,
  'bin',
  'cache',
  'dart-sdk',
  'bin',
  'dart',
);
final _managerLauncher = p.join(p.separator, 'home', 'dev', 'fvm', 'dart');
final _standaloneDart = p.join(
  p.separator,
  'usr',
  'lib',
  'dart',
  'bin',
  'dart',
);

/// What the probe script prints for the SDK at [executable].
String _probeOutput(
  final String executable, {
  final String version = '3.13.5',
}) =>
    '$executable\n'
    '$version (stable) (Tue Sep 29 01:00:52 2026 -0700) on "linux_x64"\n';

void main() {
  test(
    'Given no dart on PATH and no Flutter, '
    'when evaluating, then the status is missing with a Flutter remedy',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: null,
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
        launcher: null,
        output: null,
        flutterRoot: _flutterRoot,
      );

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains(p.join(_flutterRoot, 'bin')));
    },
  );

  test(
    'Given a dart launcher whose probe printed nothing usable, '
    'when evaluating, then the status is unknown',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _bundledLauncher,
        output: 'something went wrong',
        flutterRoot: _flutterRoot,
      );

      expect(result.status, DoctorStatus.unknown);
      expect(result.path, _bundledLauncher);
    },
  );

  test(
    'Given the dart launcher bundled with Flutter, '
    'when evaluating, then the status is ready with the SDK executable as '
    'path',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _bundledLauncher,
        output: _probeOutput(_bundledSdkDart),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, '3.13.5');
      expect(result.path, _bundledSdkDart);
    },
  );

  test(
    'Given a Dart below the required constraint, '
    'when evaluating, then the status is incompatible',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _bundledLauncher,
        output: _probeOutput(_bundledSdkDart, version: '3.10.0'),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.incompatible);
      expect(result.message, contains('^3.12.2'));
    },
  );

  test(
    'Given a version-manager launcher outside Flutter that runs the Dart '
    'bundled with it, when evaluating, then the status is ready',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _managerLauncher,
        output: _probeOutput(_bundledSdkDart),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.path, _bundledSdkDart);
    },
  );

  test(
    'Given a launcher outside Flutter that runs another SDK, '
    'when evaluating, then the status is misconfigured with a PATH remedy',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _managerLauncher,
        output: _probeOutput(_standaloneDart),
        flutterRoot: _flutterRoot,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.misconfigured);
      expect(result.path, _standaloneDart);
      expect(result.message, contains(_standaloneDart));
      expect(result.remedy, contains(p.join(_flutterRoot, 'bin')));
      expect(result.remedy, contains(p.dirname(_managerLauncher)));
    },
  );

  test(
    'Given a standalone Dart and no Flutter, '
    'when evaluating, then the status is ready',
    () {
      final result = DartSdkCheck.evaluate(
        launcher: _standaloneDart,
        output: _probeOutput(_standaloneDart),
        flutterRoot: null,
        constraint: '^3.12.2',
      );

      expect(result.status, DoctorStatus.ready);
    },
  );

  test(
    'Given probe output with launcher notices before it, '
    'when parsing, then only the last two lines are read',
    () {
      final info = DartSdkCheck.parse(
        'Welcome to Flutter!\n'
        'Building flutter tool...\n'
        '${_probeOutput(_bundledSdkDart)}',
      );

      expect(info, isNotNull);
      expect(info!.executable, _bundledSdkDart);
      expect(info.version.toString(), '3.13.5');
    },
  );
}
