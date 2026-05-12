import 'dart:async';

import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/run_app.dart';
import 'package:serverpod_cli/src/commands/tui/terminal_backend.dart';
import 'package:serverpod_cli/src/commands/tui/tui_log_writer.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum CreateOption<V> implements OptionDefinition<V> {
  force(
    FlagOption(
      argName: 'force',
      argAbbrev: 'f',
      defaultsTo: false,
      negatable: false,
      helpText:
          'Create the project even if there are issues that prevent it from '
          'running out of the box.',
    ),
  ),
  mini(
    FlagOption(
      argName: 'mini',
      defaultsTo: false,
      negatable: false,
      helpText: 'Shortcut for --template mini.',
      group: _templateGroup,
    ),
  ),
  template(
    EnumOption(
      enumParser: EnumParser(ServerpodTemplateType.values),
      argName: 'template',
      argAbbrev: 't',
      defaultsTo: ServerpodTemplateType.server,
      helpText: 'Template to use when creating a new project',
      allowedValues: ServerpodTemplateType.values,
      allowedHelp: {
        'mini': 'Mini project with minimal features and no database',
        'server': 'Server project with standard features including database',
        'module': 'Serverpod Module project',
      },
      group: _templateGroup,
    ),
  ),
  name(
    StringOption(
      argName: 'name',
      argAbbrev: 'n',
      argPos: 0,
      helpText:
          'The name of the project to create.\n'
          'Can also be specified as the first argument.',
      mandatory: true,
    ),
  )
  ;

  static const _templateGroup = MutuallyExclusive(
    'Project Template',
    mode: MutuallyExclusiveMode.allowDefaults,
  );

  const CreateOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class CreateCommand extends ServerpodCommand<CreateOption> {
  final restrictedNames = [
    ...ServerpodTemplateType.values.map((t) => t.name),
    'create',
    'migration',
    'repair',
    'repair-migration',
  ];

  @override
  final name = 'create';

  @override
  final description =
      'Creates a new Serverpod project, specify project name (must be '
      'lowercase with no special characters).';

  CreateCommand() : super(options: CreateOption.values);

  @override
  Future<void> runWithConfig(Configuration<CreateOption> commandConfig) async {
    var template = commandConfig.value(CreateOption.mini)
        ? ServerpodTemplateType.mini
        : commandConfig.value(CreateOption.template);
    var force = commandConfig.value(CreateOption.force);
    var name = commandConfig.value(CreateOption.name);

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    if (restrictedNames.contains(name) && !force) {
      log.error(
        'Are you sure you want to create a project named "$name"?\n'
        'Use the --${CreateOption.force.option.argName} flag to force creation.',
      );
      throw ExitException.error();
    }

    // Make sure all necessary downloads are installed
    if (!resourceManager.isTemplatesInstalled) {
      try {
        await resourceManager.installTemplates();
      } catch (e) {
        log.error('Failed to download templates.');
        throw ExitException.error();
      }

      if (!resourceManager.isTemplatesInstalled) {
        log.error(
          'Could not download the required resources for Serverpod. '
          'Make sure that you are connected to the internet and that '
          'you are using the latest version of Serverpod.',
        );
        throw ExitException.error();
      }
    }

    final context = TemplateContext(
      auth: true,
      redis: true,
      postgres: true,
      web: true,
      skills: true,
    );

    final useTui = (interactive ?? true) && !ci.isCI;

    if (useTui && !template.isMini) {
      // Dry run to collect early errors and exit if needed.
      final dryRunProjectPath = await performCreate(
        name,
        template,
        force,
        dryRun: true,
        interactive: interactive,
        context: context,
      );

      if (dryRunProjectPath == null) {
        throw ExitException.error();
      }

      await _performCreateWithTui(
        name,
        template,
        force,
        interactive: true,
      );
      return;
    }

    final projectPath = await performCreate(
      name,
      template,
      force,
      interactive: interactive,
      context: context,
    );

    if (projectPath == null) {
      throw ExitException.error();
    }
  }

  /// Shuts down TUI and closes the TuiLogWriter.
  /// Initializes the default logger for post-tui logs.
  Future<void> _shutdownTuiApp([int exitCode = 0]) async {
    await closeLogger();
    initializeLogger();
    shutdownServerpodApp(exitCode);
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

  /// Creates Serverpod project with TUI.
  Future<void> _performCreateWithTui(
    String name,
    ServerpodTemplateType template,
    bool force, {
    required bool? interactive,
  }) async {
    final flutterBuildCompleter = Completer<int>();
    final state = CreateConfigState(template);
    final holder = CreateAppStateHolder(state);

    final tuiWriter = TuiLogWriter();
    initializeLoggerWith(ServerpodCliLogger(tuiWriter));
    tuiWriter.attach(holder);

    String? projectPath;

    final backend = ServerpodTerminalBackend(
      preExit: () => _preExit(
        template: state.template ?? template,
        projectPath: projectPath,
      ),
    );

    await runServerpodApp(
      backend: backend,
      ServerpodCreateApp(
        name: name,
        holder: holder,
        onCreate: () async {
          final context = state.toTemplateContext();
          projectPath = await performCreate(
            name,
            state.template ?? template,
            force,
            flutterBuildCompleter: flutterBuildCompleter,
            interactive: interactive,
            context: context,
          );

          final success = projectPath != null;

          await _shutdownTuiApp(success ? 0 : 1);
        },
        onQuit: () => _shutdownTuiApp(1),
        onSkipFlutterBuild: () {
          if (!flutterBuildCompleter.isCompleted) {
            flutterBuildCompleter.complete(0);
          }
        },
      ),
    );
  }
}
