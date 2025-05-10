import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum CreateOption<V> implements OptionDefinition<V> {
  force(FlagOption(
    argName: 'force',
    argAbbrev: 'f',
    defaultsTo: false,
    negatable: false,
    helpText:
        'Create the project even if there are issues that prevent it from '
        'running out of the box.',
  )),
  mini(FlagOption(
    argName: 'mini',
    defaultsTo: false,
    negatable: false,
    helpText: 'Shortcut for --template mini.',
    group: _templateGroup,
  )),
  template(EnumOption(
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
  )),
  name(StringOption(
    argName: 'name',
    argAbbrev: 'n',
    argPos: 0,
    helpText: 'The name of the project to create.\n'
        'Can also be specified as the first argument.',
    mandatory: true,
  ));

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

    if (restrictedNames.contains(name) && !force) {
      log.error(
        'Are you sure you want to create a project named "$name"?\n'
        'Use the --${CreateOption.force.option.argName} flag to force creation.',
      );
      throw ExitException.error();
    }

    if (!await performCreate(name, template, force)) {
      throw ExitException.error();
    }
  }
}
