import 'dart:io';

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

/// Lays out what `dart install serverpod_cli@[version]` leaves behind in a
/// temp directory, and returns the bin entry it writes.
String _createManagedInstall(final String version) {
  final root = Directory.systemTemp.createTempSync('serverpod_install');
  addTearDown(() => root.deleteSync(recursive: true));

  final bundleBin = Directory(
    p.join(
      root.path,
      'app-bundles',
      'serverpod_cli',
      'hosted',
      version,
      'bundle',
      'bin',
    ),
  )..createSync(recursive: true);
  final binDir = Directory(p.join(root.path, 'bin'))..createSync();

  if (Platform.isWindows) {
    final target = p.join(bundleBin.path, 'serverpod.exe');
    File(target).writeAsStringSync('');
    final entry = p.join(binDir.path, 'serverpod.bat');
    File(entry).writeAsStringSync(
      '@ECHO OFF\r\n'
      'REM target_file_path_marker\r\n'
      '"$target" %*\r\n'
      'EXIT /B %ERRORLEVEL%\r\n',
    );
    return entry;
  }

  final target = p.join(bundleBin.path, 'serverpod');
  File(target).writeAsStringSync('');
  final entry = p.join(binDir.path, 'serverpod');
  Link(entry).createSync(target);
  return entry;
}

void main() {
  test(
    'Given the bin entry dart install wrote, '
    'when reading the installed version, then it comes from the bundle path',
    () {
      final entry = _createManagedInstall('4.0.4');

      expect(ServerpodCliCheck.installedVersion(entry), '4.0.4');
    },
  );

  test(
    'Given no bin entry, when reading the installed version, then it is null',
    () {
      expect(
        ServerpodCliCheck.installedVersion(p.join(_managed, 'missing')),
        isNull,
      );
    },
  );

  test(
    'Given no serverpod on PATH and none installed, '
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

  test(
    'Given a managed install whose bin directory is not on PATH, '
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

  test(
    'Given PATH selecting a binstub instead of the managed install, '
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

  test(
    'Given PATH selecting the managed install, '
    'when evaluating, then the status is ready with the version it reported',
    () {
      final result = ServerpodCliCheck.evaluate(
        _installation(
          kind: CliInstallationKind.managed,
          onPath: _managed,
          pathResolvesToManaged: true,
        ),
        version: '4.0.4',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, '4.0.4');
      expect(result.path, _managed);
      expect(result.message, contains('Serverpod 4.0.4'));
    },
  );

  test(
    'Given a managed install off PATH while another CLI runs the check, '
    'when evaluating, then the status is misconfigured, not missing',
    () {
      final result = ServerpodCliCheck.evaluate(
        _installation(
          kind: CliInstallationKind.source,
          onPath: null,
          pathResolvesToManaged: false,
        ),
        managedExecutableExists: true,
      );

      expect(result.status, DoctorStatus.misconfigured);
      expect(result.remedy, contains(p.dirname(_managed)));
    },
  );
}
