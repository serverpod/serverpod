import 'dart:convert';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart'
    show findExecutableOnPath;
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/probe.dart';
import 'package:serverpod_cli/src/generated/version.dart';

/// What `flutter --version --machine` reports.
typedef FlutterVersionInfo = ({
  Version version,
  String channel,
  String flutterRoot,
});

/// Checks that a compatible Flutter SDK is on PATH.
///
/// The result's [DoctorCheckResult.path] is the SDK root once known, so the
/// Dart check can tell whether PATH selects the Dart bundled with it.
class FlutterCheck {
  static const id = 'flutter';

  /// [environment] stands in for the process environment in tests.
  static Future<DoctorCheckResult> probe({
    final Map<String, String>? environment,
  }) async {
    final executable = findExecutableOnPath(
      'flutter',
      environment: environment,
    );
    if (executable == null) return evaluate(executable: null, output: null);

    // Flutter may populate its cache on first run, which takes a while.
    final result = await runProbe(
      executable,
      ['--version', '--machine'],
      timeout: const Duration(minutes: 2),
    );
    return evaluate(
      executable: executable,
      output: result?.exitCode == 0 ? result!.stdout as String : null,
    );
  }

  /// Parses the JSON that `flutter --version --machine` prints, or `null` if
  /// the fields the check needs are not there.
  static FlutterVersionInfo? parse(final String output) {
    // Flutter prints notices before the JSON on some first runs.
    final start = output.indexOf('{');
    if (start < 0) return null;
    final Object? decoded;
    try {
      decoded = jsonDecode(output.substring(start));
    } on FormatException {
      return null;
    }
    if (decoded is! Map) return null;

    final version = tryParseVersion(decoded['frameworkVersion'] as String?);
    final root = decoded['flutterRoot'];
    if (version == null || root is! String) return null;

    return (
      version: version,
      channel: decoded['channel'] as String? ?? 'unknown',
      flutterRoot: root,
    );
  }

  static DoctorCheckResult evaluate({
    required final String? executable,
    required final String? output,
    final String constraint = requiredFlutterSdk,
  }) {
    const title = 'Flutter';

    if (executable == null) {
      return const DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.missing,
        message: 'No flutter executable found on PATH.',
        remedy:
            'Install Flutter from https://docs.flutter.dev/get-started/install '
            'and add its bin directory to your PATH.',
      );
    }

    final info = output == null ? null : parse(output);
    if (info == null) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.unknown,
        path: executable,
        message: '$executable did not report its version.',
        remedy: 'Run `flutter doctor` to see what is wrong with it.',
      );
    }

    final required = VersionConstraint.parse(constraint);
    if (!required.allows(info.version)) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.incompatible,
        version: info.version.toString(),
        path: info.flutterRoot,
        message:
            'Flutter ${info.version} is installed, but Serverpod '
            '$templateVersion requires $constraint.',
        remedy:
            'Upgrade Flutter with `flutter upgrade`, or through the tool that '
            'manages your Flutter installation.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      version: info.version.toString(),
      path: info.flutterRoot,
      message: 'Flutter ${info.version} on the ${info.channel} channel.',
    );
  }
}
