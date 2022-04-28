import 'dart:io';

import 'package:yaml/yaml.dart';

GeneratorConfig config = GeneratorConfig();

enum PackageType {
  server,
  module,
}

class GeneratorConfig {
  late String name;
  late PackageType type;

  late String serverPackage;

  final String libSourcePath = 'lib';
  final String protocolSourcePath =
      'lib${Platform.pathSeparator}src${Platform.pathSeparator}protocol';
  final String endpointsSourcePath =
      'lib${Platform.pathSeparator}src${Platform.pathSeparator}endpoints';

  late String clientPackagePath;
  late String generatedClientProtocolPath;
  final String generatedServerProtocolPath =
      'lib${Platform.pathSeparator}src${Platform.pathSeparator}generated';

  List<ModuleConfig> modules = <ModuleConfig>[];

  bool load([String dir = '']) {
    Map<String, dynamic>? pubspec;
    try {
      File file = File('${dir}pubspec.yaml');
      String yamlStr = file.readAsStringSync();
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

    Map<String, dynamic>? generatorConfig;
    try {
      File file = File('${dir}config${Platform.pathSeparator}generator.yaml');
      String yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    } catch (_) {
      print(
          'Failed to load config/generator.yaml. Is this a Serverpod project?');
      return false;
    }

    dynamic typeStr = generatorConfig!['type'];
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
        '$clientPackagePath${Platform.pathSeparator}lib${Platform.pathSeparator}src${Platform.pathSeparator}protocol';

    // Load module settings
    if (type == PackageType.server) {
      try {
        if (generatorConfig['modules'] != null) {
          Map<String, dynamic> modulesData = generatorConfig['modules'];
          for (String package in modulesData.keys) {
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
    String str = '''type: $type
sourceProtocol: $protocolSourcePath
sourceEndpoints: $endpointsSourcePath
generatedClientDart: $generatedClientProtocolPath
generatedServerProtocol: $generatedServerProtocolPath
''';
    if (modules.isNotEmpty) {
      str += '\nmodules:\n\n';
      for (ModuleConfig module in modules) {
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

  ModuleConfig._withMap(this.name, Map<String, dynamic> map)
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
  String strippedPackage = package;
  if (strippedPackage.endsWith('_server')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  if (strippedPackage.endsWith('_client')) {
    return strippedPackage.substring(0, strippedPackage.length - 7);
  }
  return package;
}
