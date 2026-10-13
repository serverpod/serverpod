import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart'
    show findExecutableOnPath;
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/probe.dart';
import 'package:serverpod_cli/src/generated/version.dart';

/// Checks that the `dart` on PATH is compatible, and bundled with the
/// detected Flutter SDK when there is one.
class DartSdkCheck {
  static const id = 'dart';

  static final _versionPattern = RegExp(r'Dart SDK version: (\S+)');

  /// [flutterRoot] is the SDK root the Flutter check found, if any.
  static Future<DoctorCheckResult> probe({final String? flutterRoot}) async {
    final executable = findExecutableOnPath('dart');
    if (executable == null) {
      return evaluate(
        executable: null,
        output: null,
        flutterRoot: flutterRoot,
      );
    }

    final result = await runProbe(executable, ['--version']);
    return evaluate(
      executable: _resolve(executable),
      output: result?.exitCode == 0
          ? '${result!.stdout}${result.stderr}'
          : null,
      flutterRoot: flutterRoot == null ? null : _resolve(flutterRoot),
    );
  }

  /// Follows symbolic links so a `dart` linked into the Flutter SDK counts
  /// as bundled with it.
  static String _resolve(final String path) {
    try {
      return File(path).resolveSymbolicLinksSync();
    } on FileSystemException {
      return p.canonicalize(path);
    }
  }

  static DoctorCheckResult evaluate({
    required final String? executable,
    required final String? output,
    required final String? flutterRoot,
    final String constraint = requiredDartSdk,
  }) {
    const title = 'Dart SDK';

    if (executable == null) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.missing,
        message: 'No dart executable found on PATH.',
        remedy: flutterRoot == null
            ? 'Install Flutter, which bundles the Dart SDK.'
            : 'Add ${p.join(flutterRoot, 'bin')} to your PATH.',
      );
    }

    final version = tryParseVersion(
      output == null ? null : _versionPattern.firstMatch(output)?.group(1),
    );
    if (version == null) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.unknown,
        path: executable,
        message: '$executable did not report its version.',
        remedy: 'Run `dart --version` to see what is wrong with it.',
      );
    }

    final required = VersionConstraint.parse(constraint);
    if (!required.allows(version)) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.incompatible,
        version: version.toString(),
        path: executable,
        message:
            'Dart $version is installed, but Serverpod $templateVersion '
            'requires $constraint.',
        remedy: 'Upgrade Flutter, which brings a compatible Dart SDK with it.',
      );
    }

    if (flutterRoot != null && !p.isWithin(flutterRoot, executable)) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.misconfigured,
        version: version.toString(),
        path: executable,
        message:
            'PATH selects $executable instead of the Dart SDK bundled with '
            'Flutter at $flutterRoot.',
        remedy:
            'Put ${p.join(flutterRoot, 'bin')} before '
            '${p.dirname(executable)} on your PATH.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      version: version.toString(),
      path: executable,
      message: 'Dart $version.',
    );
  }
}
