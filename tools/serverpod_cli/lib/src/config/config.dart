import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/yaml_util.dart';
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
    List<String>? relativeServerTestToolsPathParts,
    required List<String> relativeDartClientPackagePathParts,
    required List<ModuleConfig> modules,
    required this.extraClasses,
    required this.enabledFeatures,
    this.experimentalFeatures = const [],
  })  : _relativeDartClientPackagePathParts =
            relativeDartClientPackagePathParts,
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

  /// The parts of the path where the server package is located at.
  /// Might be relative.
  final List<String> serverPackageDirectoryPathParts;

  @override
  List<String> get libSourcePathParts =>
      [...serverPackageDirectoryPathParts, 'lib'];

  @override
  List<String> get srcSourcePathParts => [...libSourcePathParts, 'src'];

  @override
  List<String> get relativeProtocolSourcePathParts =>
      ['lib', 'src', 'protocol'];

  @override
  List<String> get protocolSourcePathParts =>
      [...serverPackageDirectoryPathParts, ...relativeProtocolSourcePathParts];

  @override
  List<String> get relativeModelSourcePathParts => ['lib', 'src', 'models'];

  @override
  List<String> get modelSourcePathParts =>
      [...serverPackageDirectoryPathParts, ...relativeModelSourcePathParts];

  /// The internal package path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServeModelPackagePathParts => ['src', 'generated'];

  /// The path parts of the generated endpoint file.
  List<String> get generatedServerEndpointFilePathParts =>
      [...generatedServeModelPathParts, 'endpoints.dart'];

  /// The path parts of the generated protocol file.
  List<String> get generatedServerProtocolFilePathParts =>
      [...generatedServeModelPathParts, 'protocol.dart'];

  /// The path parts of the generated protocol file.
  List<String> get generatedServerEndpointDescriptionFilePathParts =>
      [...generatedServeModelPathParts, 'protocol.yaml'];

  /// The path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServeModelPathParts => [
        ...serverPackageDirectoryPathParts,
        'lib',
        ...generatedServeModelPackagePathParts
      ];

  /// Path parts from the server package to the dart client package.
  final List<String> _relativeDartClientPackagePathParts;

  /// Path parts to the client package.
  List<String> get clientPackagePathParts => [
        ...serverPackageDirectoryPathParts,
        ..._relativeDartClientPackagePathParts
      ];

  final List<String>? _relativeServerTestToolsPathParts;
  static const _defaultRelativeServerTestToolsPathParts = [
    'test',
    'integration',
    'test_tools'
  ];

  List<String>? get generatedServerTestToolsPathParts {
    var localRelativeServerTestToolsPathParts =
        _relativeServerTestToolsPathParts;
    if (localRelativeServerTestToolsPathParts != null) {
      return [
        ...serverPackageDirectoryPathParts,
        ...localRelativeServerTestToolsPathParts
      ];
    }

    var isServerpodMini = !isFeatureEnabled(ServerpodFeature.database);
    if (isServerpodMini) {
      return [
        ...serverPackageDirectoryPathParts,
        ..._defaultRelativeServerTestToolsPathParts
      ];
    }

    return null;
  }

  /// The path parts to the protocol directory in the dart client package.
  List<String> get generatedDartClientModelPathParts =>
      [...clientPackagePathParts, 'lib', 'src', 'protocol'];

  /// All the modules defined in the config.
  final List<ModuleConfig> _modules;

  /// User defined class names for complex types.
  /// Useful for types used in caching and streams.
  final List<TypeDefinition> extraClasses;

  /// All the features that are enabled in the serverpod project.
  final List<ServerpodFeature> enabledFeatures;

  bool isFeatureEnabled(ServerpodFeature feature) =>
      enabledFeatures.contains(feature);

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

  /// Create a new [GeneratorConfig] by loading the configuration in the [serverRootDir].
  static Future<GeneratorConfig> load([String serverRootDir = '']) async {
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
      throw const ServerpodProjectNotFoundException(
        'Could not find the Serverpod dependency. Are you running serverpod from your '
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
      relativeDartClientPackagePathParts =
          p.split(generatorConfig['client_package_path']);
    }

    List<String>? relativeServerTestToolsPathParts;
    if (generatorConfig['server_test_tools_path'] != null) {
      relativeServerTestToolsPathParts =
          p.split(generatorConfig['server_test_tools_path']);
    }

    late String dartClientPackage;
    late bool dartClientDependsOnServiceClient;

    try {
      var file = File(p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...relativeDartClientPackagePathParts,
        'pubspec.yaml'
      ]));
      var yamlStr = file.readAsStringSync();
      Map yaml = loadYaml(yamlStr);
      dartClientPackage = yaml['name'];
      dartClientDependsOnServiceClient =
          (yaml['dependencies'] as Map).containsKey('serverpod_service_client');
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

    var allPackagesAreInstalled = pubspec.dependencies.keys
        .every((dependencyName) => packageConfig[dependencyName] != null);
    if (!allPackagesAreInstalled) {
      log.warning(
          'Not all dependencies are installed, which might cause errors in your Serverpod code. Run `dart pub get`.');
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
            configExtraClasses is YamlNode ? configExtraClasses.span : null);
      }
    }

    var enabledFeatures = _enabledFeatures(file, generatorConfig);

    var enabledExperimentalFeatures = [
      ..._enabledExperimentalFeatures(file, generatorConfig),
      ...CommandLineExperimentalFeatures.instance.features,
    ];

    return GeneratorConfig(
      name: name,
      type: type,
      serverPackage: serverPackage,
      dartClientPackage: dartClientPackage,
      dartClientDependsOnServiceClient: dartClientDependsOnServiceClient,
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      relativeServerTestToolsPathParts: relativeServerTestToolsPathParts,
      relativeDartClientPackagePathParts: relativeDartClientPackagePathParts,
      modules: modules,
      extraClasses: extraClasses,
      enabledFeatures: enabledFeatures,
      experimentalFeatures: enabledExperimentalFeatures,
    );
  }

  static List<ServerpodFeature> _enabledFeatures(File file, Map config) {
    var enabledFeatures = <ServerpodFeature>[];
    if (!file.existsSync()) return enabledFeatures;

    if (!config.containsKey('features')) {
      enabledFeatures.add(ServerpodFeature.database);
    }

    var features = config['features'];

    if (features is! Map) return enabledFeatures;

    return ServerpodFeature.values
        .where((feature) => features[feature.name.toString()] == true)
        .toList();
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
    var str = '''type: $type
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

/// Describes the configuration of a Serverpod module a package depends on.
class ModuleConfig implements ModelLoadConfig {
  PackageType type;

  /// The user defined nickname of the module.
  String nickname;

  /// The name of the module (without `_server` or `_client`).
  String name;

  /// The name of the dart client package.
  String dartClientPackage;

  /// The name of the server package.
  String serverPackage;

  /// The parts of the path where the server package is located at.
  /// Might be relative.
  final List<String> serverPackageDirectoryPathParts;

  @override
  List<String> get libSourcePathParts =>
      [...serverPackageDirectoryPathParts, 'lib'];

  @override
  List<String> get srcSourcePathParts => [...libSourcePathParts, 'src'];

  @override
  List<String> get relativeProtocolSourcePathParts =>
      ['lib', 'src', 'protocol'];

  @override
  List<String> get protocolSourcePathParts =>
      [...serverPackageDirectoryPathParts, ...relativeProtocolSourcePathParts];

  @override
  List<String> get relativeModelSourcePathParts => ['lib', 'src', 'models'];

  @override
  List<String> get modelSourcePathParts =>
      [...serverPackageDirectoryPathParts, ...relativeModelSourcePathParts];

  /// The migration versions of the module.
  List<String> migrationVersions;

  ModuleConfig({
    required this.type,
    required this.name,
    required this.nickname,
    required this.migrationVersions,
    required this.serverPackageDirectoryPathParts,
  })  : dartClientPackage = '${name}_client',
        serverPackage = '${name}_server';

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
