import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';

/// Configuration for [ServerpodCreateApp].
/// The enum values are mapped to the configurable features
/// for the `serverpod create` command, typically held by [TemplateContext].
enum ServerpodCreateConfig<T extends ConfigOption> {
  template<TemplateTypeOption>(
    label: 'Project Type',
    options: TemplateTypeOption.values,
    defaultOptions: {TemplateTypeOption.server},
    templates: [ServerpodTemplateType.server, ServerpodTemplateType.module],
  ),
  database<DatabaseConfigOption>(
    label: 'Database',
    options: DatabaseConfigOption.values,
    defaultOptions: {DatabaseConfigOption.postgres},
    templates: [ServerpodTemplateType.server, ServerpodTemplateType.module],
  ),
  redis<BoolConfigOption>(
    label: 'Redis (inter-server pubsub & caching)',
    options: BoolConfigOption.values,
    defaultOptions: {BoolConfigOption.enabled},
    templates: [ServerpodTemplateType.server, ServerpodTemplateType.module],
  ),
  web<BoolConfigOption>(
    label: 'Webserver',
    options: BoolConfigOption.values,
    defaultOptions: {BoolConfigOption.enabled},
    templates: [ServerpodTemplateType.server],
  ),
  auth<BoolConfigOption>(
    label: 'Authentication (requires Postgres)',
    options: BoolConfigOption.values,
    defaultOptions: {BoolConfigOption.enabled},
    templates: [ServerpodTemplateType.server],
    requirements: [
      ConfigRequirement(
        requiredConfig: ServerpodCreateConfig.database,
        requiredConfigOption: DatabaseConfigOption.postgres,
        disabledOption: BoolConfigOption.disabled,
      ),
    ],
  ),
  ide<IdeOption>(
    label: 'IDEs (click to select)',
    options: IdeOption.values,
    templates: [ServerpodTemplateType.server, ServerpodTemplateType.module],
    multiSelect: true,
  )
  ;

  const ServerpodCreateConfig({
    required this.label,
    required this.options,
    required this.templates,
    this.defaultOptions = const {},
    this.requirements = const [],
    this.multiSelect = false,
  });

  /// UI visible label for this config.
  final String label;

  /// Supported config options.
  final List<T> options;

  /// The default config options.
  final Set<T> defaultOptions;

  /// Requirements for other related configs that must be satisfied
  /// for this config to be enabled.
  final List<ConfigRequirement> requirements;

  /// Supported template types for this config.
  final List<ServerpodTemplateType> templates;

  /// Whether this config supports multi-select options.
  final bool multiSelect;
}

/// A [ServerpodCreateConfig] option.
abstract class ConfigOption {
  String get label;
}

/// [ConfigOption] that can either be [enabled] or [disabled].
enum BoolConfigOption implements ConfigOption {
  enabled('Enabled'),
  disabled('Disabled')
  ;

  const BoolConfigOption(this.label);

  @override
  final String label;
}

/// [ConfigOption] for supported databases.
enum DatabaseConfigOption implements ConfigOption {
  postgres('Postgres'),
  sqlite('SQLite'),
  none('None')
  ;

  const DatabaseConfigOption(this.label);

  @override
  final String label;
}

/// [ConfigOption] for supported template types.
enum TemplateTypeOption implements ConfigOption {
  server('Server'),
  module('Module')
  ;

  const TemplateTypeOption(this.label);

  @override
  final String label;
}

/// [ConfigOption] for supported IDEs.
enum IdeOption implements ConfigOption {
  antigravity('Antigravity'),
  codex('Codex'),
  claude('Claude'),
  cursor('Cursor'),
  openCode('OpenCode'),
  vsCode('VSCode')
  ;

  const IdeOption(this.label);

  @override
  final String label;
}

/// Represents a requirement for [ServerpodCreateConfig].
class ConfigRequirement<T extends ConfigOption> {
  const ConfigRequirement({
    required this.requiredConfig,
    required this.requiredConfigOption,
    required this.disabledOption,
  });

  /// The required config. The selected option for this config
  /// must be [requiredConfigOption] for the requirement to be satisfied.
  final ServerpodCreateConfig<T> requiredConfig;

  /// The option for [requiredConfig] that must be satisified.
  final T requiredConfigOption;

  /// Option to set if this requirement is not satisfied.
  final ConfigOption disabledOption;
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
