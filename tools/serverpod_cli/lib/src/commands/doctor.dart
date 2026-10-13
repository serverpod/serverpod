import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/doctor/dart_sdk_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/flutter_check.dart';
import 'package:serverpod_cli/src/doctor/git_check.dart';
import 'package:serverpod_cli/src/doctor/network_check.dart';
import 'package:serverpod_cli/src/doctor/serverpod_cli_check.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Bumped when the shape of the `--json` output changes incompatibly.
const doctorSchemaVersion = 1;

enum DoctorOption<V> implements OptionDefinition<V> {
  json(
    FlagOption(
      argName: 'json',
      defaultsTo: false,
      negatable: false,
      helpText: 'Print the results as JSON instead of text.',
    ),
  );

  const DoctorOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The `serverpod doctor` command, which reports whether the machine has the
/// tools Serverpod needs. It never installs or changes anything.
class DoctorCommand extends ServerpodCommand<DoctorOption> {
  static const String commandName = 'doctor';

  @override
  final name = commandName;

  @override
  final description =
      'Check that Flutter, Dart, Git, and the Serverpod CLI are installed, '
      'compatible, and selected by PATH.\n\n'
      'Exits with an error when any check does not pass.';

  DoctorCommand() : super(options: DoctorOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<DoctorOption> commandConfig,
  ) async {
    final asJson = commandConfig.value(DoctorOption.json);

    final results = await runDoctorChecks();

    if (asJson) {
      stdout.writeln(
        jsonEncode({
          'schemaVersion': doctorSchemaVersion,
          'ready': results.every((r) => r.isReady),
          'checks': results.map((r) => r.toJson()).toList(),
        }),
      );
    } else {
      _printReport(results);
    }

    if (!results.every((r) => r.isReady)) throw ExitException.error();
  }
}

/// Runs every check in order. Flutter goes first so the Dart check can tell
/// whether PATH selects the SDK bundled with it.
Future<List<DoctorCheckResult>> runDoctorChecks() async {
  final flutter = await FlutterCheck.probe();
  return [
    flutter,
    await DartSdkCheck.probe(
      flutterRoot: flutter.isReady ? flutter.path : null,
    ),
    ServerpodCliCheck.probe(),
    await GitCheck.probe(),
    await NetworkCheck.probe(),
  ];
}

void _printReport(final List<DoctorCheckResult> results) {
  for (final result in results) {
    final lines = [
      '[${_marker(result.status)}] ${result.title}: ${result.message}',
      if (result.remedy != null) '    ${result.remedy}',
    ];
    log.info('${lines.join('\n')}\n', type: const RawLogType());
  }

  final issues = results.where((r) => !r.isReady).length;
  log.info(
    issues == 0
        ? 'Everything Serverpod needs is in place.'
        : '$issues ${issues == 1 ? 'issue' : 'issues'} found.',
    newParagraph: true,
  );
}

String _marker(final DoctorStatus status) => switch (status) {
  DoctorStatus.ready => '✓',
  DoctorStatus.misconfigured => '!',
  DoctorStatus.unknown => '?',
  DoctorStatus.missing || DoctorStatus.incompatible => '✗',
};
