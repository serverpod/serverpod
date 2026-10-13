import 'package:serverpod_cli/src/commands/doctor.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:test/test.dart';

void main() {
  group('Given a DoctorCommand,', () {
    late DoctorCommand command;

    setUp(() {
      command = DoctorCommand();
    });

    test('when parsing configuration without arguments, '
        'then JSON output is off', () {
      final config = command.resolveConfiguration(command.argParser.parse([]));

      expect(config.errors, isEmpty);
      expect(config.value(DoctorOption.json), isFalse);
    });

    test('when parsing configuration with --json, then JSON output is on', () {
      final config = command.resolveConfiguration(
        command.argParser.parse(['--json']),
      );

      expect(config.errors, isEmpty);
      expect(config.value(DoctorOption.json), isTrue);
    });
  });

  group('Given a check result with every field set,', () {
    test('when serializing, then every field is present', () {
      const result = DoctorCheckResult(
        id: 'flutter',
        title: 'Flutter',
        status: DoctorStatus.incompatible,
        version: '3.41.0',
        path: '/opt/flutter',
        message: 'too old',
        remedy: 'upgrade',
      );

      expect(result.toJson(), {
        'id': 'flutter',
        'title': 'Flutter',
        'status': 'incompatible',
        'version': '3.41.0',
        'path': '/opt/flutter',
        'message': 'too old',
        'remedy': 'upgrade',
      });
    });
  });

  group('Given a check result with only the required fields,', () {
    test('when serializing, then the optional keys are left out', () {
      const result = DoctorCheckResult(
        id: 'network',
        title: 'Network',
        status: DoctorStatus.ready,
        message: 'reachable',
      );

      expect(result.toJson().keys, ['id', 'title', 'status', 'message']);
    });
  });
}
