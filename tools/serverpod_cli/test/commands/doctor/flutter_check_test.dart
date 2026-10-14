import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/flutter_check.dart';
import 'package:test/test.dart';

String _machineOutput({
  final String version = '3.47.7',
  final String channel = 'stable',
  final String root = '/opt/flutter',
}) =>
    '{"frameworkVersion": "$version", "channel": "$channel", '
    '"repositoryUrl": "https://github.com/flutter/flutter.git", '
    '"dartSdkVersion": "3.13.5", "flutterVersion": "$version", '
    '"flutterRoot": "$root"}\n';

void main() {
  test(
    'Given no flutter on PATH, '
    'when evaluating, then the status is missing with an install remedy',
    () {
      final result = FlutterCheck.evaluate(executable: null, output: null);

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains('docs.flutter.dev'));
    },
  );

  test(
    'Given flutter on PATH that reported no version, '
    'when evaluating, then the status is unknown',
    () {
      final result = FlutterCheck.evaluate(
        executable: '/usr/bin/flutter',
        output: null,
      );

      expect(result.status, DoctorStatus.unknown);
      expect(result.path, '/usr/bin/flutter');
    },
  );

  test(
    'Given flutter that printed something other than JSON, '
    'when evaluating, then the status is unknown',
    () {
      final result = FlutterCheck.evaluate(
        executable: '/usr/bin/flutter',
        output: 'Welcome to Flutter!',
      );

      expect(result.status, DoctorStatus.unknown);
    },
  );

  test(
    'Given a compatible Flutter, '
    'when evaluating, then the status is ready with the SDK root as path',
    () {
      final result = FlutterCheck.evaluate(
        executable: '/opt/flutter/bin/flutter',
        output: _machineOutput(),
        constraint: '^3.44.4',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, '3.47.7');
      expect(result.path, '/opt/flutter');
      expect(result.message, contains('stable'));
    },
  );

  test(
    'Given a Flutter below the required constraint, '
    'when evaluating, then the status is incompatible with an upgrade remedy',
    () {
      final result = FlutterCheck.evaluate(
        executable: '/opt/flutter/bin/flutter',
        output: _machineOutput(version: '3.41.0'),
        constraint: '^3.44.4',
      );

      expect(result.status, DoctorStatus.incompatible);
      expect(result.version, '3.41.0');
      expect(result.message, contains('^3.44.4'));
      expect(result.remedy, contains('flutter upgrade'));
    },
  );

  test(
    'Given Flutter output with a notice before the JSON, '
    'when parsing, then the JSON is still read',
    () {
      final info = FlutterCheck.parse(
        'Checking Dart SDK version...\n'
        '${_machineOutput(root: '/home/dev/flutter')}',
      );

      expect(info, isNotNull);
      expect(info!.version.toString(), '3.47.7');
      expect(info.flutterRoot, '/home/dev/flutter');
    },
  );

  test(
    'Given Flutter output missing the SDK root, '
    'when parsing, then nothing is returned',
    () {
      final info = FlutterCheck.parse('{"frameworkVersion": "3.47.7"}');

      expect(info, isNull);
    },
  );
}
