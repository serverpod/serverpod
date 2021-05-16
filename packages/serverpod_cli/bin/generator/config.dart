import 'dart:io';
import 'package:yaml/yaml.dart';

var config = GeneratorConfig();

enum PackageType {
  server,
  module,
}

class GeneratorConfig {
  late String packageName;
  late PackageType type;

  late String sourceProtocol;
  late String sourceEndpoints;

  late String generatedClientDart;
  late String generatedServerProtocol;

  String? clientPackage;

  List<ModuleConfig> modules = [];

  bool load([String dir = '']) {
    Map? pubspec;
    try {
      var file = File('${dir}pubspec.yaml');
      var yamlStr = file.readAsStringSync();
      pubspec = loadYaml(yamlStr);
    }
    catch(_) {
      print('Failed to load pubspec.yaml. Are you running serverpod from your projects root directory?');
      return false;
    }

    if (pubspec!['name'] == null)
      throw FormatException('Package name is missing in pubspec.yaml');
    packageName = pubspec['name'];

    Map? generatorConfig;
    try {
      var file = File('${dir}config/generator.yaml');
      var yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    }
    catch(_) {
      print('Failed to load config/generator.yaml. Is this a Serverpod project?');
      return false;
    }

    var typeStr = generatorConfig!['type'];
    if (typeStr == 'module')
      type = PackageType.module;
    else
      type = PackageType.server;

    if (generatorConfig['source_protocol'] == null)
      throw FormatException('Option "source_protocol" is required in config/generator.yaml');
    sourceProtocol = generatorConfig['source_protocol'];

    if (generatorConfig['source_endpoints'] == null)
      throw FormatException('Option "source_endpoints" is required in config/generator.yaml');
    sourceEndpoints = generatorConfig['source_endpoints'];

    if (generatorConfig['generated_client_dart'] == null)
      throw FormatException('Option "generated_client_dart" is required in config/generator.yaml');
    generatedClientDart = generatorConfig['generated_client_dart'];

    if (generatorConfig['generated_server_protocol'] == null)
      throw FormatException('Option "generated_server_protocol" is required in config/generator.yaml');
    generatedServerProtocol = generatorConfig['generated_server_protocol'];

    // Load module settings
    if (type == PackageType.server) {
      try {
        if (generatorConfig['modules'] != null) {
          Map modulesData = generatorConfig['modules'];
          for (var package in modulesData.keys) {
            modules.add(ModuleConfig._withMap(package, modulesData[package]));
          }
        }
      }
      catch(e) {
        throw FormatException('Failed to load module config');
      }
    }
    else {
      if (generatorConfig['client_package'] == null)
        throw FormatException('Option "client_package" is required in config/generator.yaml');
      clientPackage = generatorConfig['client_package'];
    }

    // print(this);

    return true;
  }

  @override
  String toString() {
    var str = '''type: $type
sourceProtocol: $sourceProtocol
sourceEndpoints: $sourceEndpoints
generatedClientDart: $generatedClientDart
generatedServerProtocol: $generatedServerProtocol
''';
    if (modules.length > 0) {
      str += '\nmodules:\n\n';
      for (var module in modules) {
        str += '$module';
      }
    }
    return str;
  }
}

class ModuleConfig {
  String path;
  String name;
  String package;
  GeneratorConfig config = GeneratorConfig();

  ModuleConfig._withMap(this.package, Map map) :
    path=map['path']!,
    name=map['name']! {
    print('');
    config.load('$path/');
  }

  @override
  String toString() {
    return '''package: $package
path: $path
name: $name
config:
$config''';
  }
}