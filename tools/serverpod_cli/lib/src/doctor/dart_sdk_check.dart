import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart'
    show findExecutableOnPath;
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/probe.dart';
import 'package:serverpod_cli/src/generated/version.dart';

/// What the Dart SDK behind a launcher reports about itself.
typedef DartSdkInfo = ({String executable, Version version});

/// Checks that the `dart` on PATH is compatible, and bundled with the
/// detected Flutter SDK when there is one.
///
/// The `dart` on PATH is often a launcher (fvm, puro, asdf) outside any SDK,
/// so the check asks the SDK it runs where it lives instead of judging the
/// launcher's location.
class DartSdkCheck {
  static const id = 'dart';

  /// Prints the running SDK's real executable, then its version.
  static const _probeScript =
      'import "dart:io";\n'
      'void main() {\n'
      '  print(Platform.resolvedExecutable);\n'
      '  print(Platform.version);\n'
      '}\n';

  /// [flutterRoot] is the SDK root the Flutter check found, if any.
  /// [environment] stands in for the process environment in tests.
  static Future<DoctorCheckResult> probe({
    final String? flutterRoot,
    final Map<String, String>? environment,
  }) async {
    final launcher = findExecutableOnPath('dart', environment: environment);
    if (launcher == null) {
      return evaluate(launcher: null, output: null, flutterRoot: flutterRoot);
    }

    final tempDir = Directory.systemTemp.createTempSync('serverpod_doctor_');
    try {
      final script = File(p.join(tempDir.path, 'probe.dart'))
        ..writeAsStringSync(_probeScript);
      // Flutter's launcher may finish setting up its SDK on first run.
      final result = await runProbe(
        launcher,
        [script.path],
        timeout: const Duration(minutes: 1),
      );
      return evaluate(
        launcher: launcher,
        output: result?.exitCode == 0 ? result!.stdout as String : null,
        flutterRoot: flutterRoot == null ? null : _canonicalize(flutterRoot),
      );
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  }

  static String _canonicalize(final String path) {
    try {
      return Directory(path).resolveSymbolicLinksSync();
    } on FileSystemException {
      return p.canonicalize(path);
    }
  }

  /// Reads the probe script's output, or `null` if it is not there.
  ///
  /// Launchers can print notices first, so only the last two lines count.
  static DartSdkInfo? parse(final String output) {
    final lines = output
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.length < 2) return null;

    final version = tryParseVersion(lines.last.split(' ').first);
    if (version == null) return null;

    return (executable: lines[lines.length - 2], version: version);
  }

  static DoctorCheckResult evaluate({
    required final String? launcher,
    required final String? output,
    required final String? flutterRoot,
    final String constraint = requiredDartSdk,
  }) {
    const title = 'Dart SDK';

    if (launcher == null) {
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

    final info = output == null ? null : parse(output);
    if (info == null) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.unknown,
        path: launcher,
        message: '$launcher did not report its SDK.',
        remedy: 'Run `dart --version` to see what is wrong with it.',
      );
    }

    final required = VersionConstraint.parse(constraint);
    if (!required.allows(info.version)) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.incompatible,
        version: info.version.toString(),
        path: info.executable,
        message:
            'Dart ${info.version} is installed, but Serverpod '
            '$templateVersion requires $constraint.',
        remedy: 'Upgrade Flutter, which brings a compatible Dart SDK with it.',
      );
    }

    if (flutterRoot != null && !p.isWithin(flutterRoot, info.executable)) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.misconfigured,
        version: info.version.toString(),
        path: info.executable,
        message:
            'PATH selects $launcher, which runs ${info.executable} instead '
            'of the Dart SDK bundled with Flutter at $flutterRoot.',
        remedy:
            'Put ${p.join(flutterRoot, 'bin')} before '
            '${p.dirname(launcher)} on your PATH.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      version: info.version.toString(),
      path: info.executable,
      message: 'Dart ${info.version}.',
    );
  }
}
