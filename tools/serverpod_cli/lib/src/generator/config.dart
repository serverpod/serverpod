import 'dart:io';

import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import 'types.dart';

/// The type of the package.
enum PackageType {
  /// Indicating a package of an end developer, creating an Serverpod
  /// base application. Or the main serverpod package.
  server,

  /// Indicating a module, that is used in other Serverpod based projects.
  module,
}

/// The configuration of the generation and analyzing process.
class GeneratorConfig {
  /// The name of the serverpod project.
  ///
  /// See also:
  ///  - [serverPackage]
  ///  - [dartClientPackage]
  late String name;

  /// The [PackageType] of the package this [GeneratorConfig] describes.
  late PackageType type;

  /// The name of the server package.
  ///
  /// See also:
  ///  - [dartClientPackage]
  ///  - [name]
  late String serverPackage;

  /// The name of the client package.
  ///
  /// See also:
  ///  - [serverPackage]
  ///  - [name]
  late String dartClientPackage;

  /// True, if the dart client depends on the `package:serverpod_service_client`.
  late bool dartClientDependsOnServiceClient;

  /// The relative path to the lib folder, starting in a package directory.
  final String relativeLibSourcePath = 'lib';

  /// The relative path to the protocol directory,
  /// starting in the server package.
  final String relativeProtocolSourcePath = p.join('lib', 'src', 'protocol');

  /// The relative path to the endpoints directory,
  /// starting in the server package.
  final String relativeEndpointsSourcePath = p.join('lib', 'src', 'endpoints');

  /// The relative path to the dart client package,
  /// starting in the server package.
  late String relativeClientPackagePath;

  /// The relative path to the protocol directory in the dart client package,
  /// starting in the server package.
  late String relativeGeneratedDartClientProtocolPath;

  /// The relative path of the directory, where the generated code is stored
  /// in the server package, starting in the server package.
  final String relativeGeneratedServerProtocolPath =
      p.join('lib', 'src', 'generated');

  /// All the modules defined in the config.
  List<ModuleConfig> modules = [];

  /// User defined class names for complex types.
  /// Useful for types used in caching and streams.
  List<TypeDefinition> extraClasses = [];

  /// Create a new [GeneratorConfig] by loading the configuration in the [dir].
  static GeneratorConfig? load([String dir = '']) {
    var config = GeneratorConfig();
    if (config._load(dir)) {
      return config;
    } else {
      return null;
    }
  }

  //TODO: at some point this should be directly done in load.
  bool _load([String dir = '']) {
    Map? pubspec;
    try {
      var file = File(p.join(dir, 'pubspec.yaml'));
      var yamlStr = file.readAsStringSync();
      pubspec = loadYaml(yamlStr);
    } catch (_) {
      print(
          'Failed to load pubspec.yaml. Are you running serverpod from your projects root directory?');
      return false;
    }

    if (pubspec!['name'] == null) {
      throw const FormatException('Package name is missing in pubspec.yaml');
    }
    serverPackage = pubspec['name'];
    name = _stripPackage(serverPackage);

    Map? generatorConfig;
    try {
      var file = File(p.join(dir, 'config', 'generator.yaml'));
      var yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    } catch (_) {
      print(
          'Failed to load config/generator.yaml. Is this a Serverpod project?');
      return false;
    }

    var typeStr = generatorConfig!['type'];
    if (typeStr == 'module') {
      type = PackageType.module;
    } else {
      type = PackageType.server;
    }

    if (generatorConfig['client_package_path'] == null) {
      throw const FormatException(
          'Option "client_package_path" is required in config/generator.yaml');
    }
    relativeClientPackagePath =
        p.joinAll(p.split(generatorConfig['client_package_path']));
    try {
      var file = File(p.join(relativeClientPackagePath, 'pubspec.yaml'));
      var yamlStr = file.readAsStringSync();
      var yaml = loadYaml(yamlStr);
      dartClientPackage = yaml['name'];
      dartClientDependsOnServiceClient =
          yaml['dependencies'].containsKey('serverpod_service_client');
    } catch (_) {
      print(
          'Failed to load client pubspec.yaml. Is your client_package_path set correctly?');
      return false;
    }
    relativeGeneratedDartClientProtocolPath =
        p.join(relativeClientPackagePath, 'lib', 'src', 'protocol');

    // Load module settings
    modules = [];
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

    // Load extraClasses
    extraClasses = [];
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

    return true;
  }

  @override
  String toString() {
    var str = '''type: $type
sourceProtocol: $relativeProtocolSourcePath
sourceEndpoints: $relativeEndpointsSourcePath
generatedClientDart: $relativeGeneratedDartClientProtocolPath
generatedServerProtocol: $relativeGeneratedServerProtocolPath
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
class ModuleConfig {
  /// The user defined nickname of the module.
  String nickname;

  /// The name of the module (without `_server` or `_client`).
  String name;

  /// The name of the dart client package.
  String dartClientPackage;

  /// The name of the server package.
  String serverPackage;

  ModuleConfig._withMap(this.name, Map map)
      : dartClientPackage = '${name}_client',
        serverPackage = '${name}_server',
        nickname = map['nickname']!;

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
