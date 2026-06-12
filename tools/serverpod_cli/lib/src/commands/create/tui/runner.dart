import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Creates a Serverpod project with the create TUI.
/// The configurations exposed in the TUI form are determined by [state].
///
/// Performs a dry run before starting the TUI to collect early errors,
/// throwing an [ExitException] if any are found.
Future<void> performCreateWithTui(
  String name,
  bool force, {
  required CreateConfigState state,
  required bool? interactive,
  String? org,
}) async {
  // Dry run to collect early errors and exit if needed.
  final dryRunProjectPath = await performCreate(
    name,
    force,
    dryRun: true,
    interactive: interactive,
    context: state.toTemplateContext(),
    org: org,
  );

  if (dryRunProjectPath == null) {
    throw ExitException.error();
  }

  final holder = CreateAppStateHolder(state);

  final tuiWriter = TuiLogWriter();
  initializeLoggerWith(ServerpodCliLogger(tuiWriter));
  tuiWriter.attach(holder);

  String? projectPath;

  final backend = ServerpodTerminalBackend(
    preExit: () => _preExit(
      template: state.template,
      projectPath: projectPath,
    ),
  );

  await runTuiApp(
    backend: backend,
    ServerpodCreateApp(
      name: name,
      holder: holder,
      onCreate: () async {
        projectPath = await performCreate(
          name,
          force,
          interactive: interactive,
          context: state.toTemplateContext(),
          org: org,
        );

        final success = projectPath != null;

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
  String? projectPath,
}) async {
  CommandLineTools.flushErrors();
  flushPerformCreateErrors();

  if (projectPath != null) {
    log.info(
      'Serverpod project created.',
      newParagraph: true,
      type: TextLogType.success,
    );

    if (template.isServer) logStartInstructions(projectPath);
    if (template.isMini) logMiniStartInstructions(projectPath);
  }

  await log.flush();
}
