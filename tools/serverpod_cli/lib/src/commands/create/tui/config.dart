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
    description: FormDescription(
      label:
          'Modules are reusable units (server code, models, and Flutter code) '
          'that you can use across multiple servers.',
      spacing: 2,
    ),
  ),
  database<DatabaseConfigOption>(
    label: 'Database & caching',
    options: DatabaseConfigOption.values,
    multiSelect: true,
    defaultOptions: {DatabaseConfigOption.database},
    description: FormDescription(
      label:
          'The database is required for many features (storage, authentication, '
          'future calls, etc). Enable Redis if you plan to use multiple servers '
          'for real-time communication.',
      spacing: 2,
    ),
  ),
  webserver<WebServerConfigOption>(
    label: 'Web server',
    options: [
      WebServerConfigOption.appOnly,
      WebServerConfigOption.appAndWebsite,
      WebServerConfigOption.none,
    ],
    defaultOptions: {WebServerConfigOption.appOnly},
    description: FormDescription(
      label:
          'Serverpod can serve web pages (e.g., a landing page or a companion '
          'HTML site) and your Flutter web app in addition to your app\'s API.',
      spacing: 2,
    ),
    requirements: [
      FormRequirement<TemplateTypeOption>(
        config: ServerpodCreateConfig.template,
        configOptions: {TemplateTypeOption.serverAndApp},
      ),
    ],
  ),
  serverOnlyWebserver<WebServerConfigOption>(
    label: 'Web server',
    options: [WebServerConfigOption.website, WebServerConfigOption.none],
    defaultOptions: {WebServerConfigOption.website},
    description: FormDescription(
      label:
          'Serverpod can serve web pages (e.g., a landing page or a companion '
          'HTML site) in addition to your app\'s API.',
      spacing: 2,
    ),
    requirements: [
      FormRequirement<TemplateTypeOption>(
        config: ServerpodCreateConfig.template,
        configOptions: {TemplateTypeOption.server},
      ),
    ],
  ),
  auth<BoolFormConfigOption>(
    label: 'Authentication',
    options: BoolFormConfigOption.values,
    defaultOptions: {BoolFormConfigOption.enabled},
    description: FormDescription(
      label:
          'Enable authentication if you want your users to be able to sign in '
          'with email or social logins.',
      spacing: 2,
    ),
    requirements: [
      FormRequirement<TemplateTypeOption>(
        config: ServerpodCreateConfig.template,
        configOptions: {
          TemplateTypeOption.server,
          TemplateTypeOption.serverAndApp,
        },
      ),
      FormRequirement<DatabaseConfigOption>(
        config: ServerpodCreateConfig.database,
        configOptions: {DatabaseConfigOption.database},
      ),
    ],
  ),
  ide<IdeOption>(
    label: 'Code editors & AI agents',
    options: IdeOption.values,
    multiSelect: true,
    defaultOptions: <IdeOption>{},
    description: FormDescription(
      label:
          'Select the editors and agents you are planning to use. We will '
          'install skills and MCP servers for your selected editors.',
      spacing: 2,
    ),
  )
  ;

  const ServerpodCreateConfig({
    required this.label,
    required this.options,
    required this.defaultOptions,
    this.requirements = const [],
    this.multiSelect = false,
    this.description,
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

  @override
  final FormDescription? description;
}

/// [FormConfigOption] for database & caching options.
enum DatabaseConfigOption implements FormConfigOption {
  database('Database (recommended)'),
  redis('Redis')
  ;

  const DatabaseConfigOption(this.label);

  @override
  final String label;
}

/// [FormConfigOption] for supported template types.
enum TemplateTypeOption implements FormConfigOption {
  serverAndApp('Server & Flutter app'),
  server('Server only'),
  module('Module')
  ;

  const TemplateTypeOption(this.label);

  @override
  final String label;
}

/// [FormConfigOption] for web server options.
enum WebServerConfigOption implements FormConfigOption {
  appOnly('Flutter app only (recommended)'),
  appAndWebsite('App and website'),
  website('Website'),
  none('None')
  ;

  const WebServerConfigOption(this.label);

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
    TemplateTypeOption.serverAndApp => ServerpodTemplateType.fullstack,
    TemplateTypeOption.module => ServerpodTemplateType.module,
  };
}

extension ServerpodTemplateTypeExtension on ServerpodTemplateType {
  TemplateTypeOption get toConfigOption => switch (this) {
    ServerpodTemplateType.server => TemplateTypeOption.server,
    ServerpodTemplateType.fullstack => TemplateTypeOption.serverAndApp,
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
