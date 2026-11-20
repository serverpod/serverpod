import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/git_check.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a Mac without the developer tools, '
    'when evaluating, then the status is missing with an xcode-select remedy',
    () {
      final result = GitCheck.evaluate(
        executable: null,
        output: null,
        macOsDeveloperToolsMissing: true,
      );

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains('xcode-select --install'));
    },
  );

  test(
    'Given no git on PATH, when evaluating, then the status is missing',
    () {
      final result = GitCheck.evaluate(executable: null, output: null);

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains('package manager'));
    },
  );

  test(
    'Given git that reported no version, '
    'when evaluating, then the status is unknown',
    () {
      final result = GitCheck.evaluate(
        executable: '/usr/bin/git',
        output: null,
      );

      expect(result.status, DoctorStatus.unknown);
    },
  );

  test(
    'Given a working git, '
    'when evaluating, then the status is ready with the version',
    () {
      final result = GitCheck.evaluate(
        executable: '/usr/bin/git',
        output: 'git version 2.39.3 (Apple Git-146)\n',
      );

      expect(result.status, DoctorStatus.ready);
      expect(result.version, '2.39.3');
      expect(result.path, '/usr/bin/git');
    },
  );
}
