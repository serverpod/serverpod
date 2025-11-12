import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Analyze the server package and generate the code.
Future<bool> performGenerate({
  bool dartFormat = true,
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
}) async {
  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');

  var models = modelAnalyzer.validateAll();
  success &= !modelAnalyzer.hasSevereErrors;

  log.debug('Generating files for serializable models.');

  var generatedModelFiles =
      await ServerpodCodeGenerator.generateSerializableModels(
        models: models,
        config: config,
      );

  log.debug('Analyzing the endpoints.');

  var endpointAnalyzerCollector = CodeGenerationCollector();
  var endpoints = await endpointsAnalyzer.analyze(
    collector: endpointAnalyzerCollector,
    changedFiles: generatedModelFiles.toSet(),
  );

  success &= !endpointAnalyzerCollector.hasSevereErrors;
  endpointAnalyzerCollector.printErrors();

  log.debug('Generating the protocol.');

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    models: models,
  );

  var generatedProtocolFiles =
      await ServerpodCodeGenerator.generateProtocolDefinition(
        protocolDefinition: protocolDefinition,
        config: config,
      );

  log.debug('Cleaning old files.');

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: <String>{...generatedModelFiles, ...generatedProtocolFiles},
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return success;
}
