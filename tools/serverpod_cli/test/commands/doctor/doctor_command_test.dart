import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/doctor.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart' show TestLogWriter;
import 'package:test/test.dart';

import '../../test_util/mock_std.dart';

DoctorCheckResult _check(final String id, final DoctorStatus status) =>
    DoctorCheckResult(
      id: id,
      title: id,
      status: status,
      message: '$id is ${status.name}',
      remedy: status == DoctorStatus.ready ? null : 'fix $id',
    );

ServerpodCommandRunner _runner(final DoctorCommand command) =>
    ServerpodCommandRunner(
      'serverpod',
      'test',
      productionMode: false,
      cliVersion: Version(1, 1, 0),
    )..addCommand(command);

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

  group('Given checks that are all ready,', () {
    late DoctorCommand command;

    setUp(() {
      command = DoctorCommand(
        runChecks: ({environment}) async => [
          _check('flutter', DoctorStatus.ready),
          _check('dart', DoctorStatus.ready),
        ],
      );
    });

    test(
      'when running doctor with --json, then stdout is only the report, it '
      'says ready, and the command completes normally',
      () async {
        final out = MockStdout();

        await IOOverrides.runZoned(
          () => _runner(command).run(['doctor', '--json']),
          stdout: () => out,
        );

        final report = jsonDecode(out.output) as Map;
        expect(report['schemaVersion'], doctorSchemaVersion);
        expect(report['ready'], isTrue);
        expect(
          (report['checks'] as List).map((c) => (c as Map)['id']),
          ['flutter', 'dart'],
        );
      },
    );

    test(
      'when running doctor as text, then every check is listed and the '
      'summary says all is in place',
      () async {
        final writer = TestLogWriter();
        initializeLoggerWith(ServerpodCliLogger(writer));
        addTearDown(closeLogger);

        await _runner(command).run(['doctor']);
        // Entries reach the writer asynchronously.
        await log.flush();

        final output = writer.entries.map((e) => e.message).join('\n');
        expect(output, contains('[✓] flutter: flutter is ready'));
        expect(output, contains('[✓] dart: dart is ready'));
        expect(output, contains('Everything Serverpod needs is in place.'));
      },
    );
  });

  group('Given a check that is not ready,', () {
    late DoctorCommand command;

    setUp(() {
      command = DoctorCommand(
        runChecks: ({environment}) async => [
          _check('flutter', DoctorStatus.ready),
          _check('git', DoctorStatus.missing),
        ],
      );
    });

    test(
      'when running doctor with --json, then the report says not ready and '
      'the command exits with an error',
      () async {
        final out = MockStdout();

        await expectLater(
          IOOverrides.runZoned(
            () => _runner(command).run(['doctor', '--json']),
            stdout: () => out,
          ),
          throwsA(isA<ExitException>()),
        );

        final report = jsonDecode(out.output) as Map;
        expect(report['ready'], isFalse);
      },
    );

    test(
      'when running doctor as text, then the remedy is shown and the summary '
      'counts the issue',
      () async {
        final writer = TestLogWriter();
        initializeLoggerWith(ServerpodCliLogger(writer));
        addTearDown(closeLogger);

        await expectLater(
          _runner(command).run(['doctor']),
          throwsA(isA<ExitException>()),
        );
        await log.flush();

        final output = writer.entries.map((e) => e.message).join('\n');
        expect(output, contains('[✗] git: git is missing'));
        expect(output, contains('fix git'));
        expect(output, contains('1 issue found.'));
      },
    );
  });

  test(
    'Given each doctor status, '
    'when reading its marker, then ready, warning, unknown, and failure '
    'glyphs are distinct',
    () {
      expect(DoctorStatus.ready.marker, '✓');
      expect(DoctorStatus.misconfigured.marker, '!');
      expect(DoctorStatus.unknown.marker, '?');
      expect(DoctorStatus.missing.marker, '✗');
      expect(DoctorStatus.incompatible.marker, '✗');
    },
  );

  test(
    'Given a check result with every field set, '
    'when serializing, then every field is present',
    () {
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
    },
  );

  test(
    'Given a check result with only the required fields, '
    'when serializing, then the optional keys are left out',
    () {
      const result = DoctorCheckResult(
        id: 'network',
        title: 'Network',
        status: DoctorStatus.ready,
        message: 'reachable',
      );

      expect(result.toJson().keys, ['id', 'title', 'status', 'message']);
    },
  );
}
