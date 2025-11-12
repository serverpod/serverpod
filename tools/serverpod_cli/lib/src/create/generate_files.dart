import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class GenerateFiles {
  static Future<bool> generateFiles(Directory serverDir) async {
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(serverDir.path);
    } catch (e) {
      log.error('An error occurred while parsing the server config file: $e');
      return false;
    }

    var libDirectory = Directory(p.joinAll(config.libSourcePathParts));
    var endpointsAnalyzer = EndpointsAnalyzer(libDirectory);

    var yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);

    bool hasErrors = false;
    final modelAnalyzer = StatefulAnalyzer(config, yamlModels, (
      uri,
      collector,
    ) {
      collector.printErrors();
      if (collector.errors.isNotEmpty) {
        hasErrors = true;
      }
    });

    if (hasErrors) {
      log.error(
        'There were errors parsing the models. Please fix them and try again.',
      );
      return false;
    }

    return await performGenerate(
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
      modelAnalyzer: modelAnalyzer,
    );
  }
}
