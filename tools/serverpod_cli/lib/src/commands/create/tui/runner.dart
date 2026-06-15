import 'dart:io';

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
  List<ServerpodCreateConfig> configs = ServerpodCreateConfig.values,
  TemplateContext? defaultContext,
  bool requireIde = false,
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
  );

  if (result is! CreateSuccess) {
    throw ExitException.error();
  }

  // All form configurations are not shown in the TUI
  // for upgrade path. If the project already has migrations
  // then the TUI should only allow for IDEs to be selected.
  // Otherwise, assume we're dealing with a mini to server upgrade.
  // In that case, the TUI should show all configurations except
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

  final holder = CreateAppStateHolder(state);

  final tuiWriter = TuiLogWriter();
  initializeLoggerWith(ServerpodCliLogger(tuiWriter));
  tuiWriter.attach(holder);

  String? projectPath;

  final backend = ServerpodTerminalBackend(
    preExit: () => _preExit(
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

    if (template.isServer) logStartInstructions(projectPath);
    if (template.isMini) logMiniStartInstructions(projectPath);
  }

  await log.flush();
}
