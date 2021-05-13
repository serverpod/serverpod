import 'dart:io';
import 'package:yaml/yaml.dart';

var config = GeneratorConfig();

enum PackageType {
  server,
  bundle,
}

class GeneratorConfig {
  late String packageName;
  late PackageType type;

  late String sourceProtocol;
  late String sourceEndpoints;

  String? generatedClientDart;
  late String generatedServerProtocol;

  List<BundleConfig> bundles = [];

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
    if (typeStr == 'bundle')
      type = PackageType.bundle;
    else
      type = PackageType.server;

    if (generatorConfig['source-protocol'] == null)
      throw FormatException('Option "source-protocol" is required in config/generator.yaml');
    sourceProtocol = generatorConfig['source-protocol'];

    if (generatorConfig['source-enpoints'] == null)
      throw FormatException('Option "source-enpoints" is required in config/generator.yaml');
    sourceEndpoints = generatorConfig['source-enpoints'];

    if (type == PackageType.server && generatorConfig['generated-client-dart'] == null)
      throw FormatException('Option "source-protocol" is required in config/generator.yaml');
    generatedClientDart = generatorConfig['generated-client-dart'];

    if (generatorConfig['generated-server-protocol'] == null)
      throw FormatException('Option "source-enpoints" is required in config/generator.yaml');
    generatedServerProtocol = generatorConfig['generated-server-protocol'];

    // Load bundle settings
    if (type == PackageType.server) {
      try {
        if (generatorConfig['bundles'] != null) {
          Map bundlesData = generatorConfig['bundles'];
          for (var package in bundlesData.keys) {
            bundles.add(BundleConfig._withMap(package, bundlesData[package]));
          }
        }
      }
      catch(e) {
        throw FormatException('Failed to load bundle config');
      }
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
    if (bundles.length > 0) {
      str += '\nbundles:\n\n';
      for (var bundle in bundles) {
        str += '$bundle';
      }
    }
    return str;
  }
}

class BundleConfig {
  String path;
  String name;
  String package;
  GeneratorConfig config = GeneratorConfig();

  BundleConfig._withMap(this.package, Map map) :
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