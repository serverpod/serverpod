import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/config/serverpod_manifest.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/yaml_util.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import '../generator/types.dart';

/// The type of the package.
enum PackageType {
  /// Indicating a package of an end developer, creating an Serverpod base
  /// application. Or the main serverpod package.
  server,

  /// Indicating a module, that is used in other Serverpod based projects.
  module,

  /// Indicating a package that is used internally by Serverpod (e.g. the
  /// serverpod package).
  internal,
}

class ServerpodProjectNotFoundException implements Exception {
  final String message;

  const ServerpodProjectNotFoundException(this.message);

  @override
  String toString() => message;
}

class ServerpodModulesNotFoundException implements Exception {
  final String message;

  const ServerpodModulesNotFoundException(this.message);

  @override
  String toString() => message;
}

abstract interface class ModelLoadConfig {
  /// Path parts to the lib/src/protocol directory of the server package.
  List<String> get protocolSourcePathParts;

  /// Path parts to the lib/src/models directory of the server package.
  List<String> get modelSourcePathParts;

  /// Path parts to the lib/src folder of the server package.
  List<String> get srcSourcePathParts;

  /// Path parts to the lib folder of the server package.
  List<String> get libSourcePathParts;

  /// Relative path parts to the model directory
  List<String> get relativeModelSourcePathParts;

  /// Relative path parts to the protocol directory
  List<String> get relativeProtocolSourcePathParts;
}

/// The configuration of the generation and analyzing process.
class GeneratorConfig implements ModelLoadConfig {
  const GeneratorConfig({
    required this.name,
    required this.type,
    required this.serverPackage,
    required this.dartClientPackage,
    required this.dartClientDependsOnServiceClient,
    required this.serverPackageDirectoryPathParts,
    required this.sharedModelsSourcePathsParts,
    List<String>? relativeServerTestToolsPathParts,
    required List<String> relativeDartClientPackagePathParts,
    required List<ModuleConfig> modules,
    this.serializeAsJsonbByDefault = false,
    required this.extraClasses,
    required this.isDatabaseEnabled,
    required this.databaseDialect,
    this.isFutureCallEnabled = true,
    this.experimentalFeatures = const [],
  }) : _relativeDartClientPackagePathParts = relativeDartClientPackagePathParts,
       _relativeServerTestToolsPathParts = relativeServerTestToolsPathParts,
       _modules = modules;

  /// The name of the serverpod project.
  ///
  /// See also:
  ///  - [serverPackage]
  ///  - [dartClientPackage]
  final String name;

  /// The [PackageType] of the package this [GeneratorConfig] describes.
  final PackageType type;

  /// The name of the server package.
  ///
  /// See also:
  ///  - [dartClientPackage]
  ///  - [name]
  final String serverPackage;

  /// The name of the client package.
  ///
  /// See also:
  ///  - [serverPackage]
  ///  - [name]
  final String dartClientPackage;

  /// True, if dart client depends on the `package:serverpod_service_client`.
  final bool dartClientDependsOnServiceClient;

  /// The parts of the absolute, normalized path where the server package
  /// is located. Anchored at [GeneratorConfig.load] time.
  final List<String> serverPackageDirectoryPathParts;

  /// The path parts to packages of shared models.
  /// The key is the package name, the value is the path parts to the package
  /// relative to the server package.
  final Map<String, List<String>> sharedModelsSourcePathsParts;

  @override
  List<String> get libSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    'lib',
  ];

  @override
  List<String> get srcSourcePathParts => [...libSourcePathParts, 'src'];

  @override
  List<String> get relativeProtocolSourcePathParts => [
    'lib',
    'src',
    'protocol',
  ];

  @override
  List<String> get protocolSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    ...relativeProtocolSourcePathParts,
  ];

  @override
  List<String> get relativeModelSourcePathParts => ['lib', 'src', 'models'];

  @override
  List<String> get modelSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    ...relativeModelSourcePathParts,
  ];

  /// The paths of the lib directory in shared model packages.
  List<String> get sharedModelsLibSourcePaths => [
    for (var pathParts in sharedModelsSourcePathsParts.values)
      p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...pathParts,
        'lib',
      ]),
  ];

  /// The internal package path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServeModelPackagePathParts => ['src', 'generated'];

  /// The path parts of the generated endpoint file.
  List<String> get generatedServerEndpointFilePathParts => [
    ...generatedServeModelPathParts,
    'endpoints.dart',
  ];

  /// The path parts of the generated future calls class file.
  List<String> get generatedServerFutureCallFilePathParts => [
    ...generatedServeModelPathParts,
    'future_calls.dart',
  ];

  /// The path parts of the generated protocol file.
  List<String> get generatedServerProtocolFilePathParts => [
    ...generatedServeModelPathParts,
    'protocol.dart',
  ];

  /// The path parts of the generated serverpod server file.
  List<String> get generatedServerServerpodFilePathParts => [
    ...generatedServeModelPathParts,
    'serverpod.dart',
  ];

  /// The path parts of the generated sync tables file.
  List<String> get generatedServerSyncTablesFilePathParts => [
    ...generatedServeModelPathParts,
    'sync_tables.dart',
  ];

  /// The path parts of the generated protocol file.
  List<String> get generatedServerEndpointDescriptionFilePathParts => [
    ...generatedServeModelPathParts,
    'protocol.yaml',
  ];

  /// The path of the generated Serverpod package manifest.
  List<String> get generatedServerpodManifestFilePathParts => [
    ...generatedServeModelPathParts,
    ServerpodManifest.fileName,
  ];

  /// The path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServeModelPathParts => [
    ...serverPackageDirectoryPathParts,
    'lib',
    ...generatedServeModelPackagePathParts,
  ];

  /// The paths of the generated source code in shared model packages.
  List<String> get generatedSharedModelsPaths => [
    for (var pathParts in sharedModelsSourcePathsParts.values)
      p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...pathParts,
        'lib',
        ...generatedServeModelPackagePathParts,
      ]),
  ];

  /// Path parts from the server package to the dart client package.
  final List<String> _relativeDartClientPackagePathParts;

  /// Path parts to the client package.
  List<String> get clientPackagePathParts => [
    ...serverPackageDirectoryPathParts,
    ..._relativeDartClientPackagePathParts,
  ];

  /// Paths outside the source tree that may influence generated output
  List<String> get auxiliaryInputPaths => [
    p.joinAll([...serverPackageDirectoryPathParts, 'config', 'generator.yaml']),
    p.joinAll([...serverPackageDirectoryPathParts, 'analysis_options.yaml']),
    p.joinAll([...serverPackageDirectoryPathParts, 'pubspec.yaml']),
    p.joinAll([...serverPackageDirectoryPathParts, 'pubspec.lock']),
    p.joinAll([...clientPackagePathParts, 'analysis_options.yaml']),
    p.joinAll([...clientPackagePathParts, 'pubspec.yaml']),
    p.joinAll([...clientPackagePathParts, 'pubspec.lock']),
    for (final pathParts in sharedModelsSourcePathsParts.values) ...[
      p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...pathParts,
        'analysis_options.yaml',
      ]),
      p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...pathParts,
        'pubspec.yaml',
      ]),
      p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...pathParts,
        'pubspec.lock',
      ]),
    ],
  ];

  final List<String>? _relativeServerTestToolsPathParts;
  static const _defaultRelativeServerTestToolsPathParts = [
    'test',
    'integration',
    'test_tools',
  ];

  List<String>? get generatedServerTestToolsPathParts {
    var localRelativeServerTestToolsPathParts =
        _relativeServerTestToolsPathParts;
    if (localRelativeServerTestToolsPathParts != null) {
      return [
        ...serverPackageDirectoryPathParts,
        ...localRelativeServerTestToolsPathParts,
      ];
    }

    if (!isDatabaseEnabled) {
      return [
        ...serverPackageDirectoryPathParts,
        ..._defaultRelativeServerTestToolsPathParts,
      ];
    }

    return null;
  }

  /// The path parts to the protocol directory in the dart client package.
  List<String> get generatedDartClientModelPathParts => [
    ...clientPackagePathParts,
    'lib',
    'src',
    'protocol',
  ];

  /// All the modules defined in the config.
  final List<ModuleConfig> _modules;

  /// User defined class names for complex types.
  /// Useful for types used in caching and streams.
  final List<TypeDefinition> extraClasses;

  /// Whether serializable fields default to `jsonb` instead of `json` when
  /// stored in the database.
  final bool serializeAsJsonbByDefault;

  /// Whether the database is enabled in the serverpod project.
  final bool isDatabaseEnabled;

  /// The dialect of the database, if enabled. Default is [DatabaseDialect.postgres].
  final DatabaseDialect databaseDialect;

  /// Whether future calls are enabled in the serverpod project.
  final bool isFutureCallEnabled;

  final List<ExperimentalFeature> experimentalFeatures;

  bool isExperimentalFeatureEnabled(ExperimentalFeature feature) =>
      experimentalFeatures.contains(feature) ||
      experimentalFeatures.contains(ExperimentalFeature.all);

  /// All the modules defined in the config (of type module).
  List<ModuleConfig> get modules => _modules
      .where((module) => module.type == PackageType.module)
      .where((module) => module.name != name)
      .toList();

  /// All the modules excluding my self
  List<ModuleConfig> get modulesDependent =>
      _modules.where((module) => module.name != name).toList();

  /// All the modules including my self and internal modules.
  List<ModuleConfig> get modulesAll => _modules;

  /// The absolute server package directory [serverRootDir] names.
  ///
  /// An empty value searches from [startDir] or the current directory, which
  /// may prompt unless [interactive] is false, or null in CI.
  static Future<String> resolveServerRootDir(
    String serverRootDir, {
    required bool? interactive,
    Directory? startDir,
  }) async {
    // Auto-detect server directory if not specified
    if (serverRootDir.isEmpty) {
      // Determine if we should use interactive mode
      // Priority: explicit flag > CI detection > default (true)
      final isInteractive = interactive ?? !ci.isCI;

      var serverDir = await ServerDirectoryFinder.findOrPrompt(
        startDir: startDir,
        interactive: isInteractive,
      );
      serverRootDir = serverDir.path;
    }

    // Anchor the path once at resolution time,
    // so a later cwd change doesn't silently retarget config lookups.
    return p.normalize(p.absolute(serverRootDir));
  }

  /// Loads the config at [serverRootDir], resolved by [resolveServerRootDir].
  static Future<GeneratorConfig> load({
    String serverRootDir = '',
    required bool? interactive,
  }) async {
    serverRootDir = await resolveServerRootDir(
      serverRootDir,
      interactive: interactive,
    );

    var serverPackageDirectoryPathParts = p.split(serverRootDir);

    Pubspec? pubspec;
    try {
      pubspec = parsePubspec(File(p.join(serverRootDir, 'pubspec.yaml')));
    } catch (_) {}

    if (pubspec == null) {
      throw const ServerpodProjectNotFoundException(
        'Failed to load pubspec.yaml. Are you running serverpod from your '
        'projects server root directory?',
      );
    }

    if (!isServerDirectory(Directory(serverRootDir))) {
      throw ServerpodProjectNotFoundException(
        'Could not find the Serverpod dependency in the directory '
        '$serverRootDir. Are you running serverpod from your '
        'projects root directory?',
      );
    }

    var serverPackage = pubspec.name;
    var name = _stripPackage(serverPackage);

    var file = File(p.join(serverRootDir, 'config', 'generator.yaml'));
    YamlMap generatorConfig = await file.exists()
        ? loadYamlMap(await file.readAsString(), sourceUrl: file.uri)
        : YamlMap();
    var type = getPackageType(generatorConfig);

    var relativeDartClientPackagePathParts = ['..', '${name}_client'];

    if (generatorConfig['client_package_path'] != null) {
      relativeDartClientPackagePathParts = p.split(
        generatorConfig['client_package_path'],
      );
    }

    List<String>? relativeServerTestToolsPathParts;
    if (generatorConfig['server_test_tools_path'] != null) {
      relativeServerTestToolsPathParts = p.split(
        generatorConfig['server_test_tools_path'],
      );
    }

    late String dartClientPackage;
    late bool dartClientDependsOnServiceClient;

    try {
      var file = File(
        p.joinAll([
          ...serverPackageDirectoryPathParts,
          ...relativeDartClientPackagePathParts,
          'pubspec.yaml',
        ]),
      );
      var yamlStr = file.readAsStringSync();
      Map yaml = loadYaml(yamlStr);
      dartClientPackage = yaml['name'];
      dartClientDependsOnServiceClient = (yaml['dependencies'] as Map)
          .containsKey('serverpod_service_client');
    } catch (_) {
      throw const ServerpodProjectNotFoundException(
        'Failed to load client pubspec.yaml. If you are using a none default '
        'path it has to be specified in the config/generator.yaml file!',
      );
    }

    var packageConfig = await findPackageConfig(Directory(serverRootDir));

    if (packageConfig == null) {
      throw const ServerpodProjectNotFoundException(
        'Failed to read your server\'s package configuration. Have you run '
        '`dart pub get` in your server directory?',
      );
    }

    if (relativeServerTestToolsPathParts != null &&
        packageConfig['serverpod_test'] == null) {
      log.warning(
        'A `server_test_tools_path` was set in the generator config, '
        'but the `serverpod_test` package is not installed. '
        "Make sure it's part of your pubspec.yaml file and run `dart pub get`. "
        "If you don't want to use `serverpod_test`, then remove `server_test_tools_path`.",
      );
    }

    var allPackagesAreInstalled = pubspec.dependencies.keys.every(
      (dependencyName) => packageConfig[dependencyName] != null,
    );
    if (!allPackagesAreInstalled) {
      log.warning(
        'Not all dependencies are installed, which might cause errors in your Serverpod code. Run `dart pub get`.',
      );
    }

    var manualModules = <String, String?>{};
    if (generatorConfig['modules'] != null) {
      Map modulesData = generatorConfig['modules'];
      for (var package in modulesData.keys) {
        var packageValue = modulesData[package];
        var nickname = packageValue is Map ? packageValue['nickname'] : null;
        manualModules[package] = nickname is String ? nickname : null;
      }
    }

    var modules = loadModuleConfigs(
      packageConfig: packageConfig,
      projectPubspec: pubspec,
      nickNameOverrides: manualModules,
    );

    var sharedModelsSourcePathsParts = _extractSharedPackages(
      serverRootDir,
      generatorConfig,
    );

    // Load extraClasses
    var extraClasses = <TypeDefinition>[];
    var configExtraClasses = generatorConfig['extraClasses'];
    if (configExtraClasses != null) {
      try {
        for (var extraClassConfig in configExtraClasses) {
          extraClasses.add(
            parseType(
              extraClassConfig,
              extraClasses: null,
            ),
          );
        }
      } on SourceSpanException catch (_) {
        rethrow;
      } catch (e) {
        throw SourceSpanFormatException(
          'Failed to load \'extraClasses\' config',
          configExtraClasses is YamlNode ? configExtraClasses.span : null,
        );
      }
    }

    var enabledExperimentalFeatures = [
      ..._enabledExperimentalFeatures(file, generatorConfig),
      ...CommandLineExperimentalFeatures.instance.features,
    ];

    var runModeConfigsByFile = await _loadRunModeConfigFiles(serverRootDir);

    var databaseConfigsByFile = _loadDatabaseConfigsFromRunModeFiles(
      runModeConfigsByFile,
    );

    var isDatabaseEnabled = _inferDatabaseEnabledFromConfigs(
      databaseConfigsByFile,
    );

    var databaseDialect = _inferDatabaseDialectFromConfigs(
      databaseConfigsByFile,
    );

    var serializeAsJsonbByDefault = _loadSerializeAsJsonbByDefault(
      file,
      generatorConfig,
    );

    var isFutureCallEnabled = _loadIsFutureCallEnabledFromRunModeFiles(
      runModeConfigsByFile,
    );

    return GeneratorConfig(
      name: name,
      type: type,
      serverPackage: serverPackage,
      dartClientPackage: dartClientPackage,
      dartClientDependsOnServiceClient: dartClientDependsOnServiceClient,
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      sharedModelsSourcePathsParts: sharedModelsSourcePathsParts,
      relativeServerTestToolsPathParts: relativeServerTestToolsPathParts,
      relativeDartClientPackagePathParts: relativeDartClientPackagePathParts,
      serializeAsJsonbByDefault: serializeAsJsonbByDefault,
      modules: modules,
      extraClasses: extraClasses,
      isDatabaseEnabled: isDatabaseEnabled,
      databaseDialect: databaseDialect,
      isFutureCallEnabled: isFutureCallEnabled,
      experimentalFeatures: enabledExperimentalFeatures,
    );
  }

  static bool _loadSerializeAsJsonbByDefault(
    File file,
    Map config,
  ) {
    if (!file.existsSync()) return false;
    return config['serialize_as_jsonb_by_default'] ?? false;
  }

  static const _runModeConfigFileBaseNames = {
    'development.yaml',
    'staging.yaml',
    'production.yaml',
    'test.yaml',
  };

  /// Loads the content of each run-mode config file, keyed by file name. A
  /// run-mode config file whose content is not a map maps to `null`.
  static Future<Map<String, Map<dynamic, dynamic>?>> _loadRunModeConfigFiles(
    String serverRootDir,
  ) async {
    final configDir = Directory(p.join(serverRootDir, 'config'));
    if (!await configDir.exists()) {
      return {};
    }

    final configsByFile = <String, Map<dynamic, dynamic>?>{};
    await for (final entity in configDir.list(followLinks: false)) {
      if (entity is! File) continue;
      final basename = p.basename(entity.path);
      if (!_runModeConfigFileBaseNames.contains(basename)) {
        continue;
      }

      final yamlRoot = loadYaml(await entity.readAsString());
      configsByFile[basename] = yamlRoot is Map
          ? Map<dynamic, dynamic>.from(yamlRoot)
          : null;
    }

    return configsByFile;
  }

  /// Loads the database config of each run-mode config file, keyed by file
  /// name. A run-mode config file without a database section maps to `null`.
  static Map<String, DatabaseConfig?> _loadDatabaseConfigsFromRunModeFiles(
    Map<String, Map<dynamic, dynamic>?> runModeConfigsByFile,
  ) {
    return {
      for (final entry in runModeConfigsByFile.entries)
        if (entry.value case final configMap?)
          entry.key: inferDatabaseConfigFromConfigMap(
            configMap,
            environment: Platform.environment,
          ),
    };
  }

  /// Future calls are enabled unless the run-mode config files (when they
  /// exist) disable them through `futureCall.enabled` or the
  /// `SERVERPOD_FUTURE_CALL_ENABLED` environment variable.
  static bool _loadIsFutureCallEnabledFromRunModeFiles(
    Map<String, Map<dynamic, dynamic>?> runModeConfigsByFile,
  ) {
    final enabledByFile = <String, bool>{
      for (final entry in runModeConfigsByFile.entries)
        entry.key: inferFutureCallEnabledFromConfigMap(
          entry.value ?? const {},
          environment: Platform.environment,
        ),
    };

    if (enabledByFile.isEmpty) return true;

    final configurations = enabledByFile.values.toSet();
    if (configurations.length > 1) {
      final details = enabledByFile.entries
          .map((e) => '${e.key}: ${e.value ? 'enabled' : 'disabled'}')
          .sorted()
          .join(', ');
      throw StateError(
        'Inconsistent future call configurations across run-mode config files: $details. '
        'A Serverpod project must use uniform future call configuration in all run modes.',
      );
    }

    return configurations.single;
  }

  /// The database is enabled if run-mode config files (when they exist)
  /// all declare a database section.
  static bool _inferDatabaseEnabledFromConfigs(
    Map<String, DatabaseConfig?> databaseConfigsByFile,
  ) {
    if (databaseConfigsByFile.isEmpty) return true;

    final configurations = databaseConfigsByFile.values
        .map((config) => config != null)
        .toSet();
    if (configurations.length > 1) {
      final details = databaseConfigsByFile.entries
          .map((e) => '${e.key}: ${e.value != null ? 'enabled' : 'disabled'}')
          .sorted()
          .join(', ');
      throw StateError(
        'Inconsistent database configurations across run-mode config files: $details. '
        'A Serverpod project must use uniform database configuration in all run modes.',
      );
    }

    return configurations.single;
  }

  static DatabaseDialect _inferDatabaseDialectFromConfigs(
    Map<String, DatabaseConfig?> databaseConfigsByFile,
  ) {
    final dialectsByFile = <String, DatabaseDialect>{
      for (final entry in databaseConfigsByFile.entries)
        if (entry.value case final config?) entry.key: config.dialect,
    };

    if (dialectsByFile.isEmpty) {
      return DatabaseDialect.postgres;
    }

    final dialects = dialectsByFile.values.toSet();
    if (dialects.length > 1) {
      final details = dialectsByFile.entries
          .map((e) => '${e.key} (${e.value.name})')
          .sorted()
          .join(', ');
      throw StateError(
        'Inconsistent database dialects across run-mode config files: $details. '
        'A Serverpod project must use a single database dialect in all run modes.',
      );
    }

    return dialects.single;
  }

  static List<ExperimentalFeature> _enabledExperimentalFeatures(
    File file,
    Map config,
  ) {
    var enabledFeatures = <ExperimentalFeature>[];
    if (!file.existsSync()) return enabledFeatures;

    if (!config.containsKey('experimental_features')) {
      return enabledFeatures;
    }

    var features = config['experimental_features'];

    if (features is! Map) return enabledFeatures;

    return ExperimentalFeature.values
        .where((feature) => features[feature.name.toString()] == true)
        .toList();
  }

  static PackageType getPackageType(Map<dynamic, dynamic> generatorConfig) {
    var typeStr = generatorConfig['type'];
    PackageType type;
    if (typeStr == 'module') {
      type = PackageType.module;
    } else if (typeStr == 'internal') {
      type = PackageType.internal;
    } else {
      type = PackageType.server;
    }
    return type;
  }

  @override
  String toString() {
    var str =
        '''type: $type
sourceProtocol: ${p.joinAll(protocolSourcePathParts)}
sourceModel: ${p.joinAll(modelSourcePathParts)}
generatedClientDart: ${p.joinAll(generatedDartClientModelPathParts)}
generatedServerModel: ${p.joinAll(generatedServeModelPathParts)}
''';
    if (modules.isNotEmpty) {
      str += '\nmodules:\n\n';
      for (var module in modules) {
        str += '$module';
      }
    }
    return str;
  }
}

Map<String, List<String>> _extractSharedPackages(
  String serverRootDir,
  YamlMap generatorConfig,
) {
  var sharedPackages = generatorConfig['shared_packages'];
  if (sharedPackages == null) {
    return {};
  }

  var sharedModelPackagesPathParts = <String, List<String>>{};

  if (sharedPackages is! YamlList) {
    throw SourceSpanFormatException(
      'The "shared_packages" property must be a list of package paths.',
      sharedPackages is YamlNode ? sharedPackages.span : null,
    );
  }

  for (var path in sharedPackages) {
    if (path is! String || p.isAbsolute(path)) {
      throw SourceSpanFormatException(
        'The path for the shared package must be a string path relative to the '
        'server package. Current path: $path',
        sharedPackages.span,
      );
    }

    try {
      var pubspecFile = File(p.join(serverRootDir, path, 'pubspec.yaml'));
      var yamlStr = pubspecFile.readAsStringSync();
      var pubspec = Pubspec.parse(yamlStr);
      sharedModelPackagesPathParts[pubspec.name] = p.split(path);
    } catch (_) {
      throw const ServerpodProjectNotFoundException(
        'Failed to load shared package pubspec.yaml. Make sure the path is '
        'correctly specified in the config/generator.yaml file.',
      );
    }
  }

  return sharedModelPackagesPathParts;
}

/// Describes the configuration of a Serverpod module a package depends on.
class ModuleConfig implements ModelLoadConfig {
  PackageType type;

  /// The user defined nickname of the module.
  String nickname;

  /// Whether the module exports a generated sync tables list for the
  /// `serverpod_offline_sync` package, as advertised by its manifest.
  final bool hasSyncTables;

  /// The name of the module (without `_server` or `_client`).
  String name;

  /// The name of the dart client package.
  String dartClientPackage;

  /// The name of the server package.
  String serverPackage;

  /// The parts of the path where the server package is located at.
  /// Might be relative.
  final List<String> serverPackageDirectoryPathParts;

  /// The installed shared packages the module owns, mapping each package name
  /// to the path parts of its package root from the package config.
  final Map<String, List<String>> sharedPackageRootPathParts;

  @override
  List<String> get libSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    'lib',
  ];

  @override
  List<String> get srcSourcePathParts => [...libSourcePathParts, 'src'];

  @override
  List<String> get relativeProtocolSourcePathParts => [
    'lib',
    'src',
    'protocol',
  ];

  @override
  List<String> get protocolSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    ...relativeProtocolSourcePathParts,
  ];

  @override
  List<String> get relativeModelSourcePathParts => ['lib', 'src', 'models'];

  @override
  List<String> get modelSourcePathParts => [
    ...serverPackageDirectoryPathParts,
    ...relativeModelSourcePathParts,
  ];

  /// The migration versions of the module.
  List<String> migrationVersions;

  ModuleConfig({
    required this.type,
    required this.name,
    required this.nickname,
    required this.migrationVersions,
    required this.serverPackageDirectoryPathParts,
    this.sharedPackageRootPathParts = const {},
    this.hasSyncTables = false,
  }) : // The internal serverpod module does not follow the module naming
       // convention: its server package is `serverpod` and its generated
       // client lives in `serverpod_service_client`.
       dartClientPackage = name == 'serverpod'
           ? 'serverpod_service_client'
           : '${name}_client',
       serverPackage = name == 'serverpod' ? 'serverpod' : '${name}_server';

  /// The url when importing this module in dart code.
  String dartImportUrl(bool serverCode) {
    var packageName = serverCode ? serverPackage : dartClientPackage;
    return 'package:$packageName/$packageName.dart';
  }

  @override
  String toString() {
    return '''type: $type
name: $name
nickname: $nickname
clientPackage: $dartClientPackage
serverPackage: $serverPackage
migrationVersions: $migrationVersions
''';
  }
}

/// Just get the core name of a package.
/// (without `_server` or `client`)
String _stripPackage(String package) {
  var strippedPackage = package;
  if (strippedPackage.endsWith('_server')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  if (strippedPackage.endsWith('_client')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  return package;
}

extension on Iterable<String> {
  List<String> sorted() => toList()..sort();
}
