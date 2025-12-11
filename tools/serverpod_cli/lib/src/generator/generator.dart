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
  required FutureCallsAnalyzer futureCallsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
}) async {
  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');

  final models = modelAnalyzer.validateAll();
  success &= !modelAnalyzer.hasSevereErrors;

  log.debug('Analyzing future call models.');

  // analyze future calls to collect models for generation
  var futureCallsAnalyzerCollector = CodeGenerationCollector();
  var futureCalls = await futureCallsAnalyzer.analyze(
    collector: futureCallsAnalyzerCollector,
  );

  final futureCallModels = <SerializableModelDefinition>[];

  for (final futureCall in futureCalls) {
    for (final method in futureCall.methods) {
      if (method.futureCallMethodParameter != null) {
        futureCallModels.add(
          method.futureCallMethodParameter!.toSerializableModel(),
        );
      }
    }
  }

  log.debug('Generating files for serializable models.');

  final allModels = <SerializableModelDefinition>[
    ...models,
    ...futureCallModels,
  ];

  final generatedModelFiles =
      await ServerpodCodeGenerator.generateSerializableModels(
        models: allModels,
        config: config,
      );

  log.debug('Analyzing the endpoints.');

  final endpointAnalyzerCollector = CodeGenerationCollector();
  final endpoints = await endpointsAnalyzer.analyze(
    collector: endpointAnalyzerCollector,
    changedFiles: generatedModelFiles.toSet(),
  );

  success &= !endpointAnalyzerCollector.hasSevereErrors;
  endpointAnalyzerCollector.printErrors();

  log.debug('Analyzing the future calls.');

  futureCallsAnalyzerCollector = CodeGenerationCollector();
  futureCalls = await futureCallsAnalyzer.analyze(
    collector: futureCallsAnalyzerCollector,
    changedFiles: generatedModelFiles.toSet(),
  );

  success &= !futureCallsAnalyzerCollector.hasSevereErrors;
  futureCallsAnalyzerCollector.printErrors();

  log.debug('Generating the protocol.');

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    models: allModels,
    futureCalls: futureCalls,
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
