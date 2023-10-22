import 'dart:io';

import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:source_span/source_span.dart';
import 'package:super_string/super_string.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

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

/// The configuration of the generation and analyzing process.
class GeneratorConfig {
  const GeneratorConfig({
    required this.name,
    required this.type,
    required this.serverPackage,
    required this.dartClientPackage,
    required this.dartClientDependsOnServiceClient,
    required this.serverPackageDirectoryPathParts,
    required List<String> relativeDartClientPackagePathParts,
    required this.modules,
    required this.extraClasses,
    this.servers = const {},
    this.openAPIConfig,
    this.openAPIdocumentVersion = '',
  }) : _relativeDartClientPackagePathParts = relativeDartClientPackagePathParts;

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

  /// Path parts to the lib folder of the server package.
  List<String> get libSourcePathParts =>
      [...serverPackageDirectoryPathParts, 'lib'];

  /// Path parts to the protocol directory of the server package.
  List<String> get protocolSourcePathParts =>
      [...serverPackageDirectoryPathParts, 'lib', 'src', 'protocol'];

  /// Path parts to the endpoints directory of the server package.
  List<String> get endpointsSourcePathParts =>
      [...serverPackageDirectoryPathParts, 'lib', 'src', 'endpoints'];

  /// The path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServerProtocolPathParts =>
      [...serverPackageDirectoryPathParts, 'lib', 'src', 'generated'];

  /// The path parts of the directory, where the generated code is stored in the
  /// server package.
  List<String> get generatedServerOpenAPIPathParts => [
        ...serverPackageDirectoryPathParts,
        'generated',
        'openapi',
      ];

  /// Path parts from the server package to the dart client package.
  final List<String> _relativeDartClientPackagePathParts;

  /// Path parts to the client package.
  List<String> get clientPackagePathParts => [
        ...serverPackageDirectoryPathParts,
        ..._relativeDartClientPackagePathParts
      ];

  /// The path parts to the protocol directory in the dart client package.
  List<String> get generatedDartClientProtocolPathParts =>
      [...clientPackagePathParts, 'lib', 'src', 'protocol'];

  /// All the modules defined in the config.
  final List<ModuleConfig> modules;

  /// User defined class names for complex types.
  /// Useful for types used in caching and streams.
  final List<TypeDefinition> extraClasses;

  /// List of server runtime configurations, used by OpenAPI generator.
  final Set<OpenAPIServer> servers;

  /// Configuration for generation of OpenAPI specification.
  final OpenAPIConfig? openAPIConfig;

  /// The OpenAPI document version.
  final String openAPIdocumentVersion;

  /// Create a new [GeneratorConfig] by loading the configuration in the [dir].
  static Future<GeneratorConfig?> load([
    String dir = '',
    String openAPIdocumentVersion = '',
  ]) async {
    var serverPackageDirectoryPathParts = p.split(dir);

    Map? pubspec;
    try {
      var file = File(p.join(dir, 'pubspec.yaml'));
      var yamlStr = file.readAsStringSync();
      pubspec = loadYaml(yamlStr);
    } catch (_) {
      log.error(
        'Failed to load pubspec.yaml. Are you running serverpod from your '
        'projects root directory?',
      );
      return null;
    }

    if (pubspec!['name'] == null) {
      throw const FormatException('Package name is missing in pubspec.yaml');
    }
    var serverPackage = pubspec['name'];
    var name = _stripPackage(serverPackage);

    Map? generatorConfig;
    try {
      var file = File(p.join(dir, 'config', 'generator.yaml'));
      var yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    } catch (_) {
      log.error('Failed to load config/generator.yaml. Is this a Serverpod '
          'project?');
      return null;
    }

    var typeStr = generatorConfig!['type'];
    late PackageType type;
    if (typeStr == 'module') {
      type = PackageType.module;
    } else if (typeStr == 'internal') {
      type = PackageType.internal;
    } else {
      type = PackageType.server;
    }

    if (generatorConfig['client_package_path'] == null) {
      throw const FormatException(
          'Option "client_package_path" is required in config/generator.yaml');
    }
    var relativeDartClientPackagePathParts =
        p.split(generatorConfig['client_package_path']);

    late String dartClientPackage;
    late bool dartClientDependsOnServiceClient;

    try {
      var file = File(p.joinAll([
        ...serverPackageDirectoryPathParts,
        ...relativeDartClientPackagePathParts,
        'pubspec.yaml'
      ]));
      var yamlStr = file.readAsStringSync();
      var yaml = loadYaml(yamlStr);
      dartClientPackage = yaml['name'];
      dartClientDependsOnServiceClient =
          yaml['dependencies'].containsKey('serverpod_service_client');
    } catch (_) {
      log.error(
        'Failed to load client pubspec.yaml. Is your client_package_path set '
        'correctly?',
      );
      return null;
    }

    // Load module settings
    var modules = <ModuleConfig>[];
    try {
      if (generatorConfig['modules'] != null) {
        Map modulesData = generatorConfig['modules'];
        for (var package in modulesData.keys) {
          modules.add(ModuleConfig._withMap(package, modulesData[package]));
        }
      }
    } catch (e) {
      throw const FormatException('Failed to load module config');
    }

    // Autodetect modules.
    var automagicModules = await locateModules(
      directory: Directory(dir),
      exludePackages: [serverPackage],
    );

    if (automagicModules == null) {
      return null;
    }

    for (var autoModule in automagicModules) {
      bool hasOverride = false;
      for (var module in modules) {
        if (module.name == autoModule.name) {
          hasOverride = true;
          break;
        }
      }

      if (!hasOverride) {
        modules.add(autoModule);
      }
    }

    // Load extraClasses
    var extraClasses = <TypeDefinition>[];
    if (generatorConfig['extraClasses'] != null) {
      try {
        for (var extraClassConfig in generatorConfig['extraClasses']) {
          extraClasses.add(
            parseAndAnalyzeType(
              extraClassConfig,
              analyzingExtraClasses: true,
              sourceSpan: generatorConfig['extraClasses'].span,
            ).type,
          );
        }
      } on SourceSpanException catch (_) {
        rethrow;
      } catch (e) {
        throw SourceSpanFormatException(
            'Failed to load \'extraClasses\' config',
            generatorConfig['extraClasses'].span);
      }
    }

    Set<OpenAPIServer> servers = _getServersFromConfigs(dir);
    OpenAPIConfig? openAPIConfig;

    bool hasOpenAPIConfiguration = generatorConfig.containsKey('openAPIConfig');
    if (hasOpenAPIConfiguration) {
      try {
        Map openAPIMap = generatorConfig['openAPIConfig'];

        openAPIConfig = OpenAPIConfig.fromConfig(
          openAPIMap,
          version: openAPIdocumentVersion.isNotEmpty
              ? openAPIdocumentVersion
              : pubspec['version'],
        );
      } catch (e) {
        log.error(
          'There\'s an issue with the \'openAPIConfig\' section in config/generator.yaml .',
        );
      }
    }

    return GeneratorConfig(
      name: name,
      type: type,
      serverPackage: serverPackage,
      dartClientPackage: dartClientPackage,
      dartClientDependsOnServiceClient: dartClientDependsOnServiceClient,
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      relativeDartClientPackagePathParts: relativeDartClientPackagePathParts,
      modules: modules,
      extraClasses: extraClasses,
      servers: servers,
      openAPIConfig: openAPIConfig,
      openAPIdocumentVersion: openAPIdocumentVersion,
    );
  }

  @override
  String toString() {
    var str = '''type: $type
sourceProtocol: ${p.joinAll(protocolSourcePathParts)}
sourceEndpoints: ${p.joinAll(endpointsSourcePathParts)}
generatedClientDart: ${p.joinAll(generatedDartClientProtocolPathParts)}
generatedServerProtocol: ${p.joinAll(generatedServerProtocolPathParts)}
''';
    if (modules.isNotEmpty) {
      str += '\nmodules:\n\n';
      for (var module in modules) {
        str += '$module';
      }
    }
    return str;
  }

  static Set<OpenAPIServer> _getServersFromConfigs(String dir) {
    Set<OpenAPIServer> servers = {};
    for (var path in ['development', 'staging', 'production']) {
      try {
        var config = ServerpodConfig(path, 'undefined', {'database': ''});
        servers.add(
          OpenAPIServer(
            url: config.apiServer.toUri(),
            description: '${path.toCamelCase()} Server',
          ),
        );
      } catch (e, s) {
        log.debug('Failed to load config/$path.yaml, $e\n$s');
      }
    }
    return servers;
  }
}

/// Describes the configuration of a Serverpod module a package depends on.
class ModuleConfig {
  /// The user defined nickname of the module.
  String nickname;

  /// The name of the module (without `_server` or `_client`).
  String name;

  /// The name of the dart client package.
  String dartClientPackage;

  /// The name of the server package.
  String serverPackage;

  ModuleConfig._withMap(String name, Map map)
      : this(
          name: name,
          nickname: map['nickname']!,
        );

  ModuleConfig({
    required this.name,
    required this.nickname,
  })  : dartClientPackage = '${name}_client',
        serverPackage = '${name}_server';

  /// The url when importing this module in dart code.
  String dartImportUrl(bool serverCode) =>
      'package:${serverCode ? serverPackage : dartClientPackage}/module.dart';

  @override
  String toString() {
    return '''name: $name
nickname: $nickname
clientPackage: $dartClientPackage
serverPackage: $serverPackage;
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
