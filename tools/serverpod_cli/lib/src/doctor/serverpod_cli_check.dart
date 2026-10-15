import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/generated/version.dart';

/// Checks that the `serverpod` PATH selects is the one `dart install`
/// manages, so `serverpod upgrade` keeps it current.
class ServerpodCliCheck {
  static const id = 'serverpod';

  /// [environment] stands in for the process environment in tests.
  static DoctorCheckResult probe({final Map<String, String>? environment}) =>
      evaluate(CliInstallation.resolve(environment: environment));

  static DoctorCheckResult evaluate(final CliInstallation installation) {
    const title = 'Serverpod CLI';
    final onPath = installation.executableOnPath;

    if (onPath == null) {
      final installed = installation.kind == CliInstallationKind.managed;
      return DoctorCheckResult(
        id: id,
        title: title,
        status: installed ? DoctorStatus.misconfigured : DoctorStatus.missing,
        version: installed ? templateVersion : null,
        path: installed ? installation.managedExecutable : null,
        message: installed
            ? 'Serverpod $templateVersion is installed, but '
                  '${installation.managedBinDirectory} is not on PATH.'
            : 'No serverpod executable found on PATH.',
        remedy: installed
            ? 'Add ${installation.managedBinDirectory} to your PATH.'
            : 'Run `dart install serverpod_cli`.',
      );
    }

    if (!installation.pathResolvesToManaged) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.misconfigured,
        path: onPath,
        message:
            'PATH selects $onPath, which `dart install` does not manage, so '
            '`serverpod upgrade` cannot update it.',
        remedy:
            'If it came from `dart pub global activate`, run '
            '`dart pub global deactivate serverpod_cli`, then '
            '`dart install serverpod_cli`. Otherwise put '
            '${installation.managedBinDirectory} first on your PATH.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      version: templateVersion,
      path: onPath,
      message: 'Serverpod $templateVersion, managed by `dart install`.',
    );
  }
}
