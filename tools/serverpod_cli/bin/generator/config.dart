import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

var config = GeneratorConfig();

enum PackageType {
  server,
  module,
}

class GeneratorConfig {
  late String name;
  late PackageType type;

  late String serverPackage;

  final String libSourcePath = 'lib';
  final String protocolSourcePath = p.join('lib', 'src', 'protocol');
  final String endpointsSourcePath = p.join('lib', 'src', 'endpoints');

  late String clientPackagePath;
  late String generatedClientProtocolPath;
  final String generatedServerProtocolPath = p.join('lib', 'src', 'generated');

  List<ModuleConfig> modules = [];

  bool load([String dir = '']) {
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
    clientPackagePath = generatorConfig['client_package_path'];
    generatedClientProtocolPath =
        p.join(clientPackagePath, 'lib', 'src', 'protocol');

    // Load module settings
    if (type == PackageType.server) {
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
    }

    // print(this);

    return true;
  }

  @override
  String toString() {
    var str = '''type: $type
sourceProtocol: $protocolSourcePath
sourceEndpoints: $endpointsSourcePath
generatedClientDart: $generatedClientProtocolPath
generatedServerProtocol: $generatedServerProtocolPath
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

  @override
  String toString() {
    return '''name: $name
nickname: $nickname
clientPackage: $clientPackage
serverPackage: $serverPackage;
config:
$config''';
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
