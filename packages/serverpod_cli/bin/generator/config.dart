import 'dart:io';
import 'package:yaml/yaml.dart';

var config = GeneratorConfig();

class GeneratorConfig {
  late String sourceProtocol;
  late String sourceEndpoints;

  late String generatedClientDart;
  late String generatedServerProtocol;

  bool load() {
    Map? generatorConfig;
    try {
      var file = File('config/generator.yaml');
      var yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    }
    catch(_) {
      print('Failed to load config/generator.yaml. Are you running serverpod from your projects root directory?');
      return false;
    }

    if (generatorConfig!['source-protocol'] == null)
      throw FormatException('Option "source-protocol" is required in config/generator.yaml');
    sourceProtocol = generatorConfig['source-protocol'];

    if (generatorConfig['source-enpoints'] == null)
      throw FormatException('Option "source-enpoints" is required in config/generator.yaml');
    sourceEndpoints = generatorConfig['source-enpoints'];

    if (generatorConfig['generated-client-dart'] == null)
      throw FormatException('Option "source-protocol" is required in config/generator.yaml');
    generatedClientDart = generatorConfig['generated-client-dart'];

    if (generatorConfig['generated-server-protocol'] == null)
      throw FormatException('Option "source-enpoints" is required in config/generator.yaml');
    generatedServerProtocol = generatorConfig['generated-server-protocol'];

    return true;
  }
}