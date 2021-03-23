import 'dart:io';
import 'package:yaml/yaml.dart';

var config = GeneratorConfig();

class GeneratorConfig {
  String sourceProtocol;
  String sourceEndpoints;

  String generatedClientDart;
  String generatedServerProtocol;

  bool load() {
    Map generatorConfig;
    try {
      var file = File('config/generate.yaml');
      var yamlStr = file.readAsStringSync();
      generatorConfig = loadYaml(yamlStr);
    }
    catch(_) {
      print('Failed to load config/generator.yaml. Are you running serverpod from your projects root directory?');
      return false;
    }

    sourceProtocol = generatorConfig['source-protocol'];
    if (sourceProtocol == null) {
      print('Option "source-protocol" is required in config/generator.yaml');
      return false;
    }

    sourceEndpoints = generatorConfig['source-enpoints'];
    if (sourceEndpoints == null) {
      print('Option "source-enpoints" is required in config/generator.yaml');
      return false;
    }

    generatedClientDart = generatorConfig['generated-client-dart'];
    if (generatedClientDart == null) {
      print('Option "source-protocol" is required in config/generator.yaml');
      return false;
    }

    generatedServerProtocol = generatorConfig['generated-server-protocol'];
    if (generatedServerProtocol == null) {
      print('Option "source-enpoints" is required in config/generator.yaml');
      return false;
    }

    return true;
  }
}