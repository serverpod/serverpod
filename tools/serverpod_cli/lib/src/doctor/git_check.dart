import 'dart:io';

import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart'
    show findExecutableOnPath;
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/probe.dart';

/// Checks for Git, which the Flutter tool needs to run at all.
class GitCheck {
  static const id = 'git';

  static final _versionPattern = RegExp(r'git version (\S+)');

  /// [environment] stands in for the process environment in tests.
  static Future<DoctorCheckResult> probe({
    final Map<String, String>? environment,
  }) async {
    // Without the developer tools, macOS's git stub opens an install dialog
    // instead of running, so check for them first.
    if (Platform.isMacOS) {
      final selected = await runProbe('xcode-select', ['-p']);
      if (selected == null || selected.exitCode != 0) {
        return evaluate(
          executable: null,
          output: null,
          macOsDeveloperToolsMissing: true,
        );
      }
    }

    final executable = findExecutableOnPath('git', environment: environment);
    if (executable == null) return evaluate(executable: null, output: null);

    final result = await runProbe(executable, ['--version']);
    return evaluate(
      executable: executable,
      output: result?.exitCode == 0 ? result!.stdout as String : null,
    );
  }

  static DoctorCheckResult evaluate({
    required final String? executable,
    required final String? output,
    final bool macOsDeveloperToolsMissing = false,
  }) {
    const title = 'Git';

    if (macOsDeveloperToolsMissing) {
      return const DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.missing,
        message:
            'The Xcode command line tools, which provide git, are not '
            'installed.',
        remedy: 'Run `xcode-select --install`.',
      );
    }

    if (executable == null) {
      return const DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.missing,
        message: 'No git executable found on PATH.',
        remedy:
            'Install Git with your package manager, such as '
            '`sudo apt-get install git`.',
      );
    }

    // Git versions are not semver (`2.55.0.windows.5`), so keep the text.
    final version = output == null
        ? null
        : _versionPattern.firstMatch(output)?.group(1);
    if (version == null) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.unknown,
        path: executable,
        message: '$executable did not report its version.',
        remedy: 'Run `git --version` to see what is wrong with it.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      version: version,
      path: executable,
      message: 'Git $version.',
    );
  }
}
