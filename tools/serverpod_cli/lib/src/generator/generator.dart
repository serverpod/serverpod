import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

/// Analyze the server package and generate the code.
Future<bool> performGenerate({
  bool dartFormat = true,
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  String? changedFilePath,
}) async {
  var collector = CodeGenerationCollector();
  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');
  var protocols = await ModelHelper.loadProjectYamlModelsFromDisk(config);

  var analyzer = StatefulAnalyzer(protocols, (uri, collector) {
    collector.printErrors();

    if (collector.hasSeverErrors) {
      success = false;
    }
  });

  var models = analyzer.validateAll();

  log.debug('Generating files for serializable models.');

  var generatedModelFiles =
      await ServerpodCodeGenerator.generateSerializableModels(
    models: models,
    config: config,
    collector: collector,
  );

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Analyzing the endpoints.');

  var changedFiles = generatedModelFiles.toSet();
  if (changedFilePath != null) {
    changedFiles.add(changedFilePath);
  }

  var endpoints = await endpointsAnalyzer.analyze(
    collector: collector,
    changedFiles: changedFiles,
  );

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Generating the protocol.');

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    models: models,
  );

  var generatedProtocolFiles =
      await ServerpodCodeGenerator.generateProtocolDefinition(
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
  );

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Cleaning old files.');

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: <String>{...generatedModelFiles, ...generatedProtocolFiles},
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return success;
}
