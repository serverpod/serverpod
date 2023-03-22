import 'dart:io';

import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import 'types.dart';

enum PackageType {
  server,
  module,
}

class GeneratorConfig {
  late String name;
  late PackageType type;

  late String serverPackage;
  late String clientPackage;
  late bool clientDependsOnServiceClient;

  final String relativeLibSourcePath = 'lib';
  final String relativeProtocolSourcePath = p.join('lib', 'src', 'protocol');
  final String relativeEndpointsSourcePath = p.join('lib', 'src', 'endpoints');

  late String relativeClientPackagePath;
  late String relativeGeneratedClientProtocolPath;
  final String relativeGeneratedServerProtocolPath =
      p.join('lib', 'src', 'generated');

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
    name = stripPackage(serverPackage);

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
      clientPackage = yaml['name'];
      clientDependsOnServiceClient =
          yaml['dependencies'].containsKey('serverpod_service_client');
    } catch (_) {
      print(
          'Failed to load client pubspec.yaml. Is your client_package_path set correctly?');
      return false;
    }
    relativeGeneratedClientProtocolPath =
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
generatedClientDart: $relativeGeneratedClientProtocolPath
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

class ModuleConfig {
  String nickname;
  String name;
  String clientPackage;
  String serverPackage;

  ModuleConfig._withMap(this.name, Map map)
      : clientPackage = '${name}_client',
        serverPackage = '${name}_server',
        nickname = map['nickname']!;

  String url(bool serverCode) =>
      'package:${serverCode ? serverPackage : clientPackage}/module.dart';

  @override
  String toString() {
    return '''name: $name
nickname: $nickname
clientPackage: $clientPackage
serverPackage: $serverPackage;
''';
  }
}

String stripPackage(String package) {
  var strippedPackage = package;
  if (strippedPackage.endsWith('_server')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  if (strippedPackage.endsWith('_client')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  return package;
}
