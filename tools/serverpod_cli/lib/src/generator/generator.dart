import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/sdk_path.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Holds the set of analyzers needed for code generation.
typedef Analyzers = ({
  EndpointsAnalyzer endpoints,
  StatefulAnalyzer models,
  FutureCallsAnalyzer futureCalls,
});

/// Creates the analyzers needed for code generation from [config].
Future<Analyzers> createAnalyzers(GeneratorConfig config) async {
  final libDirectory = Directory(p.joinAll(config.libSourcePathParts));
  final collection = createAnalysisContextCollection(libDirectory);
  final endpointsAnalyzer = EndpointsAnalyzer(
    libDirectory,
    collection: collection,
  );
  final yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
  final modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
    collector.printErrors();
  });
  final futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
    collection: collection,
  );
  return (
    endpoints: endpointsAnalyzer,
    models: modelAnalyzer,
    futureCalls: futureCallsAnalyzer,
  );
}

/// Creates and updates the analyzers needed for code generation from [config].
///
/// Returns the analyzers after they have been primed with the current
/// state of the source files.
Future<Analyzers> createAndUpdateAnalyzers(GeneratorConfig config) async {
  final analyzers = await createAnalyzers(config);
  await updateAnalyzers(
    config: config,
    analyzers: analyzers,
    affectedPaths: await enumerateSourceFiles(config),
  );
  return analyzers;
}

/// Incrementally updates analyzer state for the given [affectedPaths].
///
/// Refreshes the Dart analysis context for endpoints and future calls,
/// and updates the model analyzer for changed or removed model files.
///
/// The [requirements] parameter controls which analyzers to update.
/// When [GenerationRequirements.generateModels] is `false`, the model
/// analyzer is not updated (saving time when only Dart files changed).
///
/// Returns `true` if any of the changes are relevant for code generation
/// (endpoint, future call, or model changes), `false` otherwise.
Future<bool> updateAnalyzers({
  required GeneratorConfig config,
  required Analyzers analyzers,
  required Set<String> affectedPaths,
  GenerationRequirements requirements = GenerationRequirements.full,
}) async {
  var shouldGenerate = false;

  if (requirements.generateProtocol) {
    shouldGenerate |= await analyzers.endpoints.updateFileContexts(
      affectedPaths,
    );
    shouldGenerate |= await analyzers.futureCalls.updateFileContexts(
      affectedPaths,
    );
  }

  if (requirements.generateModels) {
    for (final path in affectedPaths) {
      if (ModelHelper.isModelFile(path, loadConfig: config)) {
        shouldGenerate = true;
        final file = File(path);
        if (file.existsSync()) {
          analyzers.models.addYamlModel(
            ModelHelper.createModelSourceForPath(
              config,
              path,
              file.readAsStringSync(),
            ),
          );
        } else {
          analyzers.models.removeYamlModel(Uri.parse(p.absolute(path)));
        }
      }
    }
  }

  if (!shouldGenerate) {
    log.debug('No relevant changes detected, skipping code generation.');
  }

  return shouldGenerate;
}

/// Result of a code generation run.
typedef GenerateResult = ({bool success, Set<String> generatedFiles});

/// Analyze the server package and generate the code.
///
/// When [requirements] is provided, only generates the specified parts.
/// This allows watch mode to skip expensive model generation when only
/// Dart files (endpoints/future calls) changed.
///
/// When [reportIssuesForPaths] is non-null, model validation only prints
/// hint/info issues for files in that set (see [StatefulAnalyzer.validateAll]).
Future<GenerateResult> performGenerate({
  bool dartFormat = true,
  required GeneratorConfig config,
  required Analyzers analyzers,
  GenerationRequirements requirements = GenerationRequirements.full,
  Set<String>? reportIssuesForPaths,
}) async {
  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');

  final models = analyzers.models.validateAll(
    reportIssuesForPaths: reportIssuesForPaths,
  );
  success &= !analyzers.models.hasSevereErrors;

  log.debug('Analyzing the future calls models.');

  var futureCallsModelsAnalyzerCollector = CodeGenerationCollector();

  final futureCallModels = await analyzers.futureCalls.analyzeModels(
    futureCallsModelsAnalyzerCollector,
    models,
  );

  success &= !futureCallsModelsAnalyzerCollector.hasSevereErrors;
  futureCallsModelsAnalyzerCollector.printErrors();

  log.debug('Generating files for serializable models.');

  final allModels = <SerializableModelDefinition>[
    ...models,
    ...futureCallModels,
  ];

  List<String> generatedModelFiles = [];

  if (requirements.generateModels) {
    log.debug('Generating files for serializable models.');
    generatedModelFiles =
        await ServerpodCodeGenerator.generateSerializableModels(
          models: allModels,
          config: config,
        );
  }

  if (!requirements.generateProtocol) {
    return (success: success, generatedFiles: generatedModelFiles.toSet());
  }
  log.debug('Analyzing the endpoints.');
  final changedFiles = requirements.generateModels
      ? generatedModelFiles.toSet()
      : <String>{};

  final endpointAnalyzerCollector = CodeGenerationCollector();
  final endpoints = await analyzers.endpoints.analyze(
    collector: endpointAnalyzerCollector,
    changedFiles: changedFiles,
  );

  success &= !endpointAnalyzerCollector.hasSevereErrors;
  endpointAnalyzerCollector.printErrors();

  log.debug('Analyzing the future calls.');

  var futureCallsAnalyzerCollector = CodeGenerationCollector();
  var futureCalls = await analyzers.futureCalls.analyze(
    collector: futureCallsAnalyzerCollector,
    changedFiles: changedFiles,
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
  final allGeneratedFiles = <String>{
    ...generatedModelFiles,
    ...generatedProtocolFiles,
  };

  // When doing protocol-only generation, we need to preserve existing model
  // files from the generation stamp so they don't get cleaned up.
  if (!requirements.generateModels) {
    final previouslyGeneratedModelsDirs = [
      p.joinAll(config.generatedServeModelPathParts),
      p.joinAll(config.generatedDartClientModelPathParts),
      ...config.generatedSharedModelsPaths,
    ];

    // Keep previous model files so they don't get deleted.
    final previousFiles = readGenerationStamp(config);
    final previousModelFiles = previousFiles.where(
      (f) => previouslyGeneratedModelsDirs.any((dir) => p.isWithin(dir, f)),
    );

    allGeneratedFiles.addAll(previousModelFiles);
    log.debug(
      'Preserving ${previousModelFiles.length} existing model files from stamp.',
    );
  }

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: allGeneratedFiles,
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return (success: success, generatedFiles: allGeneratedFiles);
}
