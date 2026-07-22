import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/runner.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
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
      defaultsTo: ServerpodTemplateType.fullstack,
      helpText: 'Template to use when creating a new project',
      allowedValues: ServerpodTemplateType.values,
      allowedHelp: {
        'mini': 'Mini project with minimal features and no database',
        'fullstack':
            'Fullstack project including a server and a companion Flutter app',
        'server': 'Server project with standard features including database',
        'module': 'Serverpod Module project',
      },
      group: _templateGroup,
    ),
  ),
  database(
    FlagOption(
      argName: 'database',
      helpText: 'Include a database in the project.',
    ),
  ),
  redis(
    FlagOption(
      argName: 'redis',
      helpText: 'Include Redis caching in the project.',
    ),
  ),
  auth(
    FlagOption(
      argName: 'auth',
      helpText: 'Include authentication in the project. Requires a database.',
    ),
  ),
  webapp(
    FlagOption(
      argName: 'webapp',
      helpText: 'Configure the server to host a Flutter web app.',
    ),
  ),
  website(
    FlagOption(
      argName: 'website',
      helpText: 'Configure the server to host a website.',
    ),
  ),
  ide(
    MultiOption<CreateIdeOption>(
      multiParser: MultiParser(EnumParser(CreateIdeOption.values)),
      argName: 'ide',
      defaultsTo: _defaultIdeOptions,
      helpText:
          'Configure agent skills and MCP servers for one or more IDEs. '
          'Use "none" to disable all IDE configuration.',
      allowedValues: CreateIdeOption.values,
      allowedHelp: {
        'none': 'Do not configure agent skills or MCP servers',
        'antigravity': 'Configure agent skills and MCP for Antigravity',
        'codex': 'Configure agent skills and MCP for Codex',
        'claude': 'Configure agent skills and MCP for Claude',
        'cursor': 'Configure agent skills and MCP for Cursor',
        'opencode': 'Configure agent skills and MCP for OpenCode',
        'vscode': 'Configure agent skills and MCP for VS Code',
      },
      customValidator: _validateIdeOptions,
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

  static const _defaultIdeOptions = [
    CreateIdeOption.claude,
    CreateIdeOption.cursor,
    CreateIdeOption.vscode,
  ];

  const CreateOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

enum CreateIdeOption {
  none,
  antigravity,
  codex,
  claude,
  cursor,
  opencode,
  vscode,
}

void _validateIdeOptions(List<CreateIdeOption> options) {
  if (options.contains(CreateIdeOption.none) && options.length > 1) {
    throw const FormatException(
      '"none" cannot be combined with other IDE options.',
    );
  }
}

extension on CreateIdeOption {
  TemplateIde? get templateIde => switch (this) {
    CreateIdeOption.none => null,
    CreateIdeOption.antigravity => TemplateIde.antigravity,
    CreateIdeOption.codex => TemplateIde.codex,
    CreateIdeOption.claude => TemplateIde.claude,
    CreateIdeOption.cursor => TemplateIde.cursor,
    CreateIdeOption.opencode => TemplateIde.openCode,
    CreateIdeOption.vscode => TemplateIde.vscode,
  };
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

    final database = commandConfig.optionalValue(CreateOption.database) ?? true;
    final auth = commandConfig.optionalValue(CreateOption.auth);

    if (auth == true && !database) {
      log.error(
        'Authentication requires a database. Enable --database or remove '
        '--auth.',
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
      template: template,
      auth: (auth ?? true) && database,
      redis: commandConfig.optionalValue(CreateOption.redis) ?? true,
      postgres: database,
      website:
          commandConfig.optionalValue(CreateOption.website) ??
          template == ServerpodTemplateType.server,
      webapp:
          commandConfig.optionalValue(CreateOption.webapp) ??
          template != ServerpodTemplateType.server,
      ides: commandConfig
          .value(CreateOption.ide)
          .map((option) => option.templateIde)
          .nonNulls
          .toList(),
    );

    final useTui = (interactive ?? true) && !ci.isCI;

    if (useTui && !template.isMini) {
      await performCreateWithTui(
        name,
        force,
        template: template,
        interactive: true,
      );
      return;
    }

    final result = await performCreate(
      name,
      force,
      interactive: interactive,
      context: context,
    );

    if (result is! CreateSuccess) {
      throw ExitException.error();
    }
  }
}
