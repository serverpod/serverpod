import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/serverpod_cli_check.dart';
import 'package:test/test.dart';

final _managed = p.join(
  p.separator,
  'data-home',
  'install',
  'bin',
  'serverpod',
);
final _binstub = p.join(p.separator, 'pub-cache', 'bin', 'serverpod');

CliInstallation _installation({
  required final CliInstallationKind kind,
  required final String? onPath,
  required final bool pathResolvesToManaged,
}) => CliInstallation(
  kind: kind,
  runningExecutable: _managed,
  managedExecutable: _managed,
  executableOnPath: onPath,
  pathResolvesToManaged: pathResolvesToManaged,
);

void main() {
  group('Given no serverpod on PATH and none installed,', () {
    test(
      'when evaluating, then the status is missing with an install remedy',
      () {
        final result = ServerpodCliCheck.evaluate(
          _installation(
            kind: CliInstallationKind.source,
            onPath: null,
            pathResolvesToManaged: false,
          ),
        );

        expect(result.status, DoctorStatus.missing);
        expect(result.remedy, contains('dart install serverpod_cli'));
      },
    );
  });

  group('Given a managed install whose bin directory is not on PATH,', () {
    test(
      'when evaluating, then the status is misconfigured with a PATH remedy',
      () {
        final result = ServerpodCliCheck.evaluate(
          _installation(
            kind: CliInstallationKind.managed,
            onPath: null,
            pathResolvesToManaged: false,
          ),
        );

        expect(result.status, DoctorStatus.misconfigured);
        expect(result.path, _managed);
        expect(result.remedy, contains(p.dirname(_managed)));
      },
    );
  });

  group('Given PATH selecting a binstub instead of the managed install,', () {
    test(
      'when evaluating, then the status is misconfigured with a deactivate '
      'remedy',
      () {
        final result = ServerpodCliCheck.evaluate(
          _installation(
            kind: CliInstallationKind.foreign,
            onPath: _binstub,
            pathResolvesToManaged: false,
          ),
        );

        expect(result.status, DoctorStatus.misconfigured);
        expect(result.path, _binstub);
        expect(result.remedy, contains('dart pub global deactivate'));
      },
    );
  });

  group('Given PATH selecting the managed install,', () {
    test('when evaluating, then the status is ready', () {
      final result = ServerpodCliCheck.evaluate(
        _installation(
          kind: CliInstallationKind.managed,
          onPath: _managed,
          pathResolvesToManaged: true,
        ),
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, isNotNull);
      expect(result.path, _managed);
    });
  });
}
