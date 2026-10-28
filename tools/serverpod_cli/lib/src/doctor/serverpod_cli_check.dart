import 'dart:io';

import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';

/// Checks that the `serverpod` PATH selects is the one `dart install`
/// manages, so `serverpod upgrade` keeps it current.
class ServerpodCliCheck {
  static const id = 'serverpod';

  /// The version segment of a `dart install` app-bundle path, such as
  /// `.../app-bundles/serverpod_cli/hosted/4.0.4/bundle/bin/serverpod`.
  static final _bundleVersionPattern = RegExp(
    r'[\\/]hosted[\\/]([^\\/"]+)[\\/]',
  );

  /// [environment] stands in for the process environment in tests.
  static DoctorCheckResult probe({final Map<String, String>? environment}) {
    final installation = CliInstallation.resolve(environment: environment);
    final managedExists = File(installation.managedExecutable).existsSync();
    return evaluate(
      installation,
      version: managedExists
          ? installedVersion(installation.managedExecutable)
          : null,
      managedExecutableExists: managedExists,
    );
  }

  /// The version of the CLI that `dart install` wrote at [managedExecutable],
  /// read from the bundle path its bin entry points at.
  ///
  /// Running the executable instead would bump its run counter and, on a
  /// fresh profile, open the welcome page, so the version is read from disk.
  /// The bin entry is a symbolic link on Unix and a batch wrapper on Windows.
  static String? installedVersion(final String managedExecutable) {
    final String target;
    try {
      target = Platform.isWindows
          ? File(managedExecutable).readAsStringSync()
          : File(managedExecutable).resolveSymbolicLinksSync();
    } on FileSystemException {
      return null;
    }
    return _bundleVersionPattern.firstMatch(target)?.group(1);
  }

  /// [version] is the managed install's version, when it could be read.
  /// [managedExecutableExists] tells a managed install apart from none even
  /// when the CLI running this check is not the managed one.
  static DoctorCheckResult evaluate(
    final CliInstallation installation, {
    final String? version,
    final bool managedExecutableExists = false,
  }) {
    const title = 'Serverpod CLI';
    final onPath = installation.executableOnPath;
    final described = version == null ? 'Serverpod' : 'Serverpod $version';

    if (onPath == null) {
      final installed =
          managedExecutableExists ||
          installation.kind == CliInstallationKind.managed;
      return DoctorCheckResult(
        id: id,
        title: title,
        status: installed ? DoctorStatus.misconfigured : DoctorStatus.missing,
        version: installed ? version : null,
        path: installed ? installation.managedExecutable : null,
        message: installed
            ? '$described is installed, but '
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
      version: version,
      path: onPath,
      message: '$described, managed by `dart install`.',
    );
  }
}
