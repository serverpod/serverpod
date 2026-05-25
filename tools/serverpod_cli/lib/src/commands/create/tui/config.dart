import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Configuration for [ServerpodCreateApp].
/// The enum values are mapped to the configurable features
/// for the `serverpod create` command, typically held by [TemplateContext].
enum ServerpodCreateConfig<T extends FormConfigOption>
    implements FormSelectionConfig<T> {
  template<TemplateTypeOption>(
    label: 'Project Type',
    options: TemplateTypeOption.values,
    defaultOptions: {TemplateTypeOption.server},
  ),
  database<DatabaseConfigOption>(
    label: 'Database',
    options: DatabaseConfigOption.values,
    defaultOptions: {DatabaseConfigOption.postgres},
  ),
  redis<BoolFormConfigOption>(
    label: 'Redis (inter-server pubsub & caching)',
    options: BoolFormConfigOption.values,
    defaultOptions: {BoolFormConfigOption.enabled},
  ),
  web<BoolFormConfigOption>(
    label: 'Webserver',
    options: BoolFormConfigOption.values,
    defaultOptions: {BoolFormConfigOption.enabled},
    requirements: [
      FormRequirement<TemplateTypeOption>(
        config: ServerpodCreateConfig.template,
        configOption: TemplateTypeOption.server,
      ),
    ],
  ),
  auth<BoolFormConfigOption>(
    label: 'Authentication (requires Postgres)',
    options: BoolFormConfigOption.values,
    defaultOptions: {BoolFormConfigOption.enabled},
    requirements: [
      FormRequirement<TemplateTypeOption>(
        config: ServerpodCreateConfig.template,
        configOption: TemplateTypeOption.server,
      ),
      FormRequirement<DatabaseConfigOption>(
        config: ServerpodCreateConfig.database,
        configOption: DatabaseConfigOption.postgres,
      ),
    ],
  ),
  ide<IdeOption>(
    label: 'IDEs',
    options: IdeOption.values,
    multiSelect: true,
    defaultOptions: <IdeOption>{},
  )
  ;

  const ServerpodCreateConfig({
    required this.label,
    required this.options,
    required this.defaultOptions,
    this.requirements = const [],
    this.multiSelect = false,
  });

  @override
  final String label;

  @override
  final List<T> options;

  @override
  final Set<T> defaultOptions;

  @override
  final List<FormRequirement> requirements;

  @override
  final bool multiSelect;
}

/// [FormConfigOption] for supported databases.
enum DatabaseConfigOption implements FormConfigOption {
  postgres('Postgres'),
  sqlite('SQLite'),
  none('None')
  ;

  const DatabaseConfigOption(this.label);

  @override
  final String label;
}

/// [FormConfigOption] for supported template types.
enum TemplateTypeOption implements FormConfigOption {
  server('Server'),
  module('Module')
  ;

  const TemplateTypeOption(this.label);

  @override
  final String label;
}

/// [FormConfigOption] for supported IDEs.
enum IdeOption implements FormConfigOption {
  antigravity('Antigravity'),
  codex('Codex'),
  claude('Claude'),
  cursor('Cursor'),
  openCode('OpenCode'),
  vsCode('VS Code')
  ;

  const IdeOption(this.label);

  @override
  final String label;
}

extension TemplateTypeOptionExtension on TemplateTypeOption {
  ServerpodTemplateType get toTemplate => switch (this) {
    TemplateTypeOption.server => ServerpodTemplateType.server,
    TemplateTypeOption.module => ServerpodTemplateType.module,
  };
}

extension ServerpodTemplateTypeExtension on ServerpodTemplateType {
  TemplateTypeOption get toConfigOption => switch (this) {
    ServerpodTemplateType.server => TemplateTypeOption.server,
    ServerpodTemplateType.module => TemplateTypeOption.module,
    ServerpodTemplateType.mini => throw UnsupportedError(
      'Mini template is not supported in the config.',
    ),
  };
}

extension IdeOptionsExtension on Set<IdeOption> {
  List<TemplateIde> get toTemplateIdes {
    return map((option) {
      return switch (option) {
        IdeOption.antigravity => TemplateIde.antigravity,
        IdeOption.codex => TemplateIde.codex,
        IdeOption.claude => TemplateIde.claude,
        IdeOption.cursor => TemplateIde.cursor,
        IdeOption.openCode => TemplateIde.openCode,
        IdeOption.vsCode => TemplateIde.vscode,
      };
    }).toList();
  }
}
