import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Analyze the server package and generate the code.
///
/// When [affectedPaths] is non-empty, the analyzers are incrementally updated
/// for the changed files before generation. This keeps the Dart analysis
/// context fresh and updates the model analyzer for changed model files.
/// If the updates indicate no generation is needed (no endpoint, future call,
/// or model changes), the function returns `true` early without running the
/// full generation pipeline.
///
/// When [affectedPaths] is empty (default), the full generation pipeline runs
/// unconditionally.
Future<bool> performGenerate({
  bool dartFormat = true,
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  required FutureCallsAnalyzer futureCallsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
  Set<String> affectedPaths = const {},
}) async {
  // Incremental update: refresh analyzer contexts and update models.
  if (affectedPaths.isNotEmpty) {
    var shouldGenerate = false;

    shouldGenerate |= await endpointsAnalyzer.updateFileContexts(affectedPaths);
    shouldGenerate |=
        await futureCallsAnalyzer.updateFileContexts(affectedPaths);

    for (final path in affectedPaths) {
      if (ModelHelper.isModelFile(path, loadConfig: config)) {
        shouldGenerate = true;
        final file = File(path);
        if (file.existsSync()) {
          modelAnalyzer.addYamlModel(
            ModelHelper.createModelSourceForPath(
              config,
              path,
              file.readAsStringSync(),
            ),
          );
        } else {
          modelAnalyzer.removeYamlModel(Uri.parse(p.absolute(path)));
        }
      }
    }

    if (!shouldGenerate) {
      log.debug('No relevant changes detected, skipping code generation.');
      return true;
    }
  }

  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');

  final models = modelAnalyzer.validateAll();
  success &= !modelAnalyzer.hasSevereErrors;

  log.debug('Analyzing the future calls models.');

  var futureCallsModelsAnalyzerCollector = CodeGenerationCollector();

  final futureCallModels = await futureCallsAnalyzer.analyzeModels(
    futureCallsModelsAnalyzerCollector,
  );

  success &= !futureCallsModelsAnalyzerCollector.hasSevereErrors;
  futureCallsModelsAnalyzerCollector.printErrors();

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

  var futureCallsAnalyzerCollector = CodeGenerationCollector();
  var futureCalls = await futureCallsAnalyzer.analyze(
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
