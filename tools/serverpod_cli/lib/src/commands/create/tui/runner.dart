import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// [CreateConfigState] creation result type.
class CreateConfigStateResult {
  CreateConfigStateResult({
    required this.state,
    required this.isUpgrade,
    required this.createDefaultMigrationForUpgrade,
  });

  final CreateConfigState state;
  final bool isUpgrade;
  final bool createDefaultMigrationForUpgrade;
}

/// Performs dry run to collect errors and exit early if needed.
/// Returns [CreateConfigState] to be used by the TUI app
/// when no errors are found by the dry run.
/// The returned [CreateConfigState] will contain narrowed
/// configs if project upgrade is detected.
Future<CreateConfigStateResult> getCreateConfigState({
  required String name,
  required bool force,
  required ServerpodTemplateType template,
  required bool? interactive,
  required List<ServerpodCreateConfig> configs,
  TemplateContext? defaultContext,
  bool requireIde = false,
  Directory? workingDirectory,
}) async {
  var isUpgrade = false;
  var createDefaultMigrationForUpgrade = false;

  var state = CreateConfigState(
    template,
    configs: configs,
    defaults: defaultContext,
    requireIde: requireIde,
  );

  // Dry run to collect early errors and exit if needed.
  final result = await performCreate(
    name,
    force,
    dryRun: true,
    interactive: interactive,
    context: state.toTemplateContext(),
    workingDirectory: workingDirectory,
  );

  if (result is! CreateSuccess) {
    throw ExitException.error();
  }

  // All form configurations are not shown in the TUI
  // for upgrade path. If the project already has migrations
  // then the TUI should only allow for IDEs to be selected.
  // Otherwise, the TUI should show all configurations except
  // for project type which will always be Server and cannot be changed.
  if (name == '.') {
    isUpgrade = true;

    final migrationsDir = Directory(
      p.join(result.serverDirectoryPath, 'migrations'),
    );

    if (await migrationsDir.exists()) {
      state = CreateConfigState(
        template,
        configs: [ServerpodCreateConfig.ide],
        requireIde: true,
      );
    } else {
      createDefaultMigrationForUpgrade = true;
      final effectiveConfigs = List<ServerpodCreateConfig>.from(configs);
      effectiveConfigs.removeWhere(
        (config) => config == ServerpodCreateConfig.template,
      );
      state = CreateConfigState(
        template,
        configs: effectiveConfigs,
        defaults: defaultContext,
        requireIde: requireIde,
      );
    }
  }

  return CreateConfigStateResult(
    state: state,
    isUpgrade: isUpgrade,
    createDefaultMigrationForUpgrade: createDefaultMigrationForUpgrade,
  );
}

/// Whether [performCreateWithTui] can be used for this invocation, given the
/// `--interactive` flag as [interactive] (null when the flag was not passed).
///
/// Starting the TUI captures stdin's echo and line modes so it can restore them
/// on exit, and paints frames to stdout. When stdin cannot report those modes
/// the capture throws before anything is rendered, and because the TUI logger
/// is already installed by then the failure never reaches the user.
///
/// `stdin.hasTerminal` does not answer this: Dart reports every character
/// device as a terminal, so `< /dev/null` passes that check and then throws
/// anyway. Reading the mode is the only reliable probe.
bool shouldUseCreateTui(bool? interactive) {
  if (interactive == false) return false;
  if (!ci.isCI && _stdinSupportsTerminalModes && stdout.hasTerminal) {
    return true;
  }

  if (interactive == true) {
    log.warning(
      'Interactive mode was requested but this environment cannot run the '
      'interactive setup screen. Continuing with the defaults.',
    );
  }

  return false;
}

/// Whether stdin can report the terminal modes the TUI has to capture.
///
/// Any failure to read them means the TUI cannot start, so this deliberately
/// treats every error as "unsupported".
bool get _stdinSupportsTerminalModes {
  try {
    stdin.echoMode;
    return true;
  } catch (_) {
    return false;
  }
}

/// Creates a Serverpod project with the create TUI.
/// The configurations exposed in the TUI form are determined by [configs].
/// The configurations are narrowed for a project upgrade
/// to include only what's necessary for an upgrade.
///
/// Performs a dry run before starting the TUI to collect early errors,
/// throwing an [ExitException] if any are found.
Future<void> performCreateWithTui(
  String name,
  bool force, {
  required ServerpodTemplateType template,
  required bool? interactive,
  String analyticsMethod = 'create',
  List<ServerpodCreateConfig> configs = ServerpodCreateConfig.values,
  TemplateContext? defaultContext,
  bool requireIde = false,
}) async {
  final result = await getCreateConfigState(
    name: name,
    force: force,
    template: template,
    configs: configs,
    interactive: interactive,
    defaultContext: defaultContext,
    requireIde: requireIde,
  );

  final state = result.state;
  final isUpgrade = result.isUpgrade;
  final createDefaultMigrationForUpgrade =
      result.createDefaultMigrationForUpgrade;

  final holder = CreateAppStateHolder(state);

  final tuiWriter = TuiLogWriter();
  initializeLoggerWith(ServerpodCliLogger(tuiWriter));
  tuiWriter.attach(holder);

  String? projectPath;

  final backend = ServerpodTerminalBackend(
    preExit: (_) => _preExit(
      template: state.template,
      projectPath: projectPath,
      isUpgrade: isUpgrade,
    ),
  );

  await runTuiApp(
    backend: backend,
    ServerpodCreateApp(
      isUpgrade: isUpgrade,
      holder: holder,
      onCreate: () async {
        final result = await performCreate(
          name,
          force,
          interactive: interactive,
          createDefaultMigrationForUpgrade: createDefaultMigrationForUpgrade,
          context: state.toTemplateContext(),
          analyticsMethod: analyticsMethod,
        );

        final success = result is CreateSuccess;

        if (success) {
          projectPath = result.projectDirectoryPath;
        }

        await _shutdownTui(success ? 0 : 1);
      },
      onQuit: () => _shutdownTui(1),
    ),
  );
}

/// Shuts down TUI and closes the TuiLogWriter.
/// Initializes the default logger for post-tui logs.
Future<void> _shutdownTui([int exitCode = 0]) async {
  await closeLogger();
  initializeLogger();
  shutdownTuiApp(exitCode);
}

/// Flushes success logs if [projectPath] is not null.
/// Error logs are flushed if any.
/// This is done when shutting down TUI but before exiting
/// the Dart process.
Future<void> _preExit({
  required ServerpodTemplateType template,
  required bool isUpgrade,
  String? projectPath,
}) async {
  CommandLineTools.flushErrors();
  flushPerformCreateErrors();

  if (projectPath != null) {
    final suffix = isUpgrade ? 'upgraded' : 'created';
    log.info(
      'Serverpod project $suffix.',
      newParagraph: true,
      type: TextLogType.success,
    );

    if (template.hasServer) logStartInstructions(projectPath);
  }

  await log.flush();
}
