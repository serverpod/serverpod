import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

/// Analyze the server package and generate the code.
Future<bool> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  String? changedFile,
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
}) async {
  var collector = CodeGenerationCollector();
  bool hasErrors = false;

  if (verbose) {
    log.debug('Analyzing serializable entities in the protocol directory.');
  }
  var entities = await SerializableEntityAnalyzer.analyzeAllFiles(
    verbose: verbose,
    collector: collector,
    config: config,
  );

  if (collector.hasSeverErrors) {
    hasErrors = true;
  }
  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    log.debug('Generating files for serializable entities.');
  }

  var generatedEntityFiles = await CodeGenerator.generateSerializableEntities(
    verbose: verbose,
    entities: entities,
    config: config,
    collector: collector,
  );

  if (collector.hasSeverErrors) {
    hasErrors = true;
  }
  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    log.debug('Analyzing the endpoints.');
  }

  var endpoints = await endpointsAnalyzer.analyze(
    verbose: verbose,
    collector: collector,
    changedFiles: generatedEntityFiles.toSet(),
  );

  if (collector.hasSeverErrors) {
    hasErrors = true;
  }
  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    log.debug('Generating the protocol.');
  }

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    entities: entities,
  );

  var generatedProtocolFiles = await CodeGenerator.generateProtocolDefinition(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
  );

  if (collector.hasSeverErrors) {
    hasErrors = true;
  }
  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    log.debug('Cleaning old files.');
  }

  await CodeGenerator.cleanPreviouslyGeneratedFiles(
    generatedFiles: <String>{
      ...generatedEntityFiles,
      ...generatedProtocolFiles
    },
    protocolDefinition: protocolDefinition,
    config: config,
    verbose: verbose,
  );

  return hasErrors;
}
