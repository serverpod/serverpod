import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum QuickstartOption<V> implements OptionDefinition<V> {
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
  template(
    EnumOption(
      enumParser: EnumParser([
        ServerpodTemplateType.server,
        ServerpodTemplateType.module,
      ]),
      argName: 'template',
      argAbbrev: 't',
      defaultsTo: ServerpodTemplateType.server,
      helpText: 'Template to use when creating a new project',
      allowedValues: [
        ServerpodTemplateType.server,
        ServerpodTemplateType.module,
      ],
      allowedHelp: {
        'server': 'Server project with standard features including database',
        'module': 'Serverpod Module project',
      },
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
  ),
  ;

  const QuickstartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class QuickstartCommand extends ServerpodCommand<QuickstartOption> {
  final restrictedNames = [
    ...ServerpodTemplateType.values.map((t) => t.name),
    'create',
    'migration',
    'repair',
    'repair-migration',
  ];

  @override
  final name = 'quickstart';

  @override
  final description =
      'Creates a new Serverpod project with basic options.\n'
      'Suitable for a simple project or quick experiment.\n'
      'Specify project name (must be lowercase with no special characters).';

  QuickstartCommand() : super(options: QuickstartOption.values);

  @override
  Future<void> runWithConfig(
    Configuration<QuickstartOption> commandConfig,
  ) async {
    var template = commandConfig.value(QuickstartOption.template);
    var force = commandConfig.value(QuickstartOption.force);
    var name = commandConfig.value(QuickstartOption.name);

    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    if (restrictedNames.contains(name) && !force) {
      log.error(
        'Are you sure you want to create a project named "$name"?\n'
        'Use the --${QuickstartOption.force.option.argName} flag to force creation.',
      );
      throw ExitException.error();
    }

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
          'Make sure that you are connected to the internet and that you '
          'are using the latest version of Serverpod.',
        );
        throw ExitException.error();
      }
    }

    final projectPath = await performCreate(
      name,
      template,
      force,
      interactive: interactive,
      context: TemplateContext(sqlite: true, web: true, skills: true),
    );

    if (projectPath == null) {
      throw ExitException.error();
    }
  }
}
