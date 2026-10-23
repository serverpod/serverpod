import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/dart_sdk_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_fix.dart';
import 'package:serverpod_cli/src/doctor/flutter_check.dart';
import 'package:serverpod_cli/src/doctor/git_check.dart';
import 'package:serverpod_cli/src/doctor/network_check.dart';
import 'package:serverpod_cli/src/doctor/serverpod_cli_check.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Bumped when the shape of the `--json` output changes incompatibly.
const doctorSchemaVersion = 1;

/// Runs the doctor checks, against [environment] instead of the process
/// environment when given.
typedef DoctorChecksRunner =
    Future<List<DoctorCheckResult>> Function({
      Map<String, String>? environment,
    });

enum DoctorOption<V> implements OptionDefinition<V> {
  json(
    FlagOption(
      argName: 'json',
      defaultsTo: false,
      negatable: false,
      helpText: 'Print the results as JSON instead of text.',
    ),
  ),
  fix(
    FlagOption(
      argName: 'fix',
      defaultsTo: false,
      negatable: false,
      helpText:
          'Write ~/.serverpod/env.sh with the PATH entries Serverpod needs '
          'and source it from your shell startup file. Asks before changing '
          'anything unless --yes is given.',
    ),
  ),
  yes(
    FlagOption(
      argName: 'yes',
      argAbbrev: 'y',
      defaultsTo: false,
      negatable: false,
      helpText: 'Approve the changes --fix proposes without asking.',
    ),
  );

  const DoctorOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The `serverpod doctor` command, which reports whether the machine has the
/// tools Serverpod needs. Without `--fix` it never changes anything.
class DoctorCommand extends ServerpodCommand<DoctorOption> {
  static const String commandName = 'doctor';

  final DoctorChecksRunner _runChecks;

  @override
  final name = commandName;

  @override
  final description =
      'Check that Flutter, Dart, Git, and the Serverpod CLI are installed, '
      'compatible, and selected by PATH.\n\n'
      'Exits with an error when any check does not pass.';

  /// [runChecks] stands in for the real probes in tests.
  DoctorCommand({final DoctorChecksRunner runChecks = runDoctorChecks})
    : _runChecks = runChecks,
      super(options: DoctorOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<DoctorOption> commandConfig,
  ) async {
    final asJson = commandConfig.value(DoctorOption.json);
    final fix = commandConfig.value(DoctorOption.fix);
    final yes = commandConfig.value(DoctorOption.yes);

    var results = await _runChecks();

    if (fix) {
      results = await _applyFix(results, yes: yes, quiet: asJson);
    }

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

  /// Writes the env file and startup line the checks call for, then re-runs
  /// the checks with the PATH a new shell will have.
  ///
  /// [quiet] keeps stdout clean for `--json`, which then requires [yes].
  Future<List<DoctorCheckResult>> _applyFix(
    final List<DoctorCheckResult> results, {
    required final bool yes,
    required final bool quiet,
  }) async {
    if (Platform.isWindows) {
      log.error('--fix is not supported on Windows yet.');
      throw ExitException.error();
    }
    if (quiet && !yes) {
      log.error('--fix with --json needs --yes, since there is no prompt.');
      throw ExitException.error();
    }

    final home = LocalStorageManager.homeDirectory.path;
    final serverpodDirectory = resourceManager.localStorageDirectory.path;
    final installation = CliInstallation.resolve();
    final entries = pathEntriesToAdd(
      results: results,
      installation: installation,
      managedExecutableExists: File(
        installation.managedExecutable,
      ).existsSync(),
      serverpodDirectory: serverpodDirectory,
    );
    if (entries.isEmpty) {
      if (!quiet) log.info('Nothing for --fix to change.');
      return results;
    }

    final envFile = File(p.join(serverpodDirectory, 'env.sh'));
    final startupFile = startupFileFor(
      shell: Platform.environment['SHELL'],
      home: home,
    );
    final sourceLine = sourceLineFor(envFile, home: home);

    // A rerun with nothing new leaves both files alone.
    final upToDate =
        envFile.existsSync() &&
        envFile.readAsStringSync() == envFileContent(entries) &&
        (startupFile == null ||
            startupFileSources(startupFile, envFile, home: home));
    if (upToDate) {
      if (!quiet) log.info('Nothing for --fix to change.');
      return _runChecks(environment: _environmentWith(entries));
    }

    if (!quiet) {
      log.info(
        [
          'Doctor will write ${envFile.path} to put these first on PATH:',
          for (final entry in entries) '  $entry',
          if (startupFile != null)
            'and add `$sourceLine` to ${startupFile.path}.'
          else
            'Your shell is not zsh or bash, so add `$sourceLine` to its '
                'startup file yourself.',
        ].join('\n'),
        newParagraph: true,
      );
    }

    if (!yes && !await _confirm()) {
      log.info('Nothing changed.');
      return results;
    }

    writeEnvFile(envFile, entries);
    if (startupFile != null) {
      ensureSourced(startupFile, envFile, home: home);
    }
    if (!quiet) {
      log.info('Open a new terminal for the PATH change to take effect.');
    }

    return _runChecks(environment: _environmentWith(entries));
  }

  /// The process environment with [entries] first on PATH, as a new shell
  /// will have after sourcing the env file.
  Map<String, String> _environmentWith(final List<String> entries) {
    final path = Platform.environment['PATH'] ?? '';
    return {
      ...Platform.environment,
      'PATH': [...entries, if (path.isNotEmpty) path].join(':'),
    };
  }

  Future<bool> _confirm() async {
    if (!stdin.hasTerminal) {
      log.error('No terminal to ask on. Re-run with --yes to approve.');
      throw ExitException.error();
    }
    // The logger writes from another isolate; let it finish before the
    // prompt goes straight to stdout.
    await log.flush();
    stdout.write('Apply these changes? [y/N] ');
    final answer = stdin.readLineSync()?.trim().toLowerCase();
    return answer == 'y' || answer == 'yes';
  }
}

/// Runs every check in order. Flutter goes first so the Dart check can tell
/// whether PATH selects the SDK bundled with it.
Future<List<DoctorCheckResult>> runDoctorChecks({
  final Map<String, String>? environment,
}) async {
  final flutter = await FlutterCheck.probe(environment: environment);
  return [
    flutter,
    await DartSdkCheck.probe(
      flutterRoot: flutter.isReady ? flutter.path : null,
      environment: environment,
    ),
    ServerpodCliCheck.probe(environment: environment),
    await GitCheck.probe(environment: environment),
    await NetworkCheck.probe(),
  ];
}

void _printReport(final List<DoctorCheckResult> results) {
  for (final result in results) {
    final lines = [
      '[${result.status.marker}] ${result.title}: ${result.message}',
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
