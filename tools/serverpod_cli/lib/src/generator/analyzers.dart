import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../commands/generate.dart';
import 'code_generation_collector.dart';
import 'dart/temp_protocol_generator.dart';
import 'serverpod_code_generator.dart';

/// Result of a code generation run.
typedef GenerateResult = ({bool success, Set<String> generatedFiles});

/// Holds the set of analyzers needed for code generation.
///
/// Subclassed by `IsolatedAnalyzers` to run analysis on a worker isolate.
class Analyzers {
  final EndpointsAnalyzer _endpoints;
  final StatefulAnalyzer _models;
  final FutureCallsAnalyzer _futureCalls;

  Analyzers({
    required EndpointsAnalyzer endpoints,
    required StatefulAnalyzer models,
    required FutureCallsAnalyzer futureCalls,
  }) : _endpoints = endpoints,
       _models = models,
       _futureCalls = futureCalls;

  /// Release resources. No-op for local analyzers; overridden by
  /// `IsolatedAnalyzers` to shut down the worker isolate.
  Future<void> close() async {}

  /// Creates the analyzers needed for code generation from [config].
  static Future<Analyzers> create(GeneratorConfig config) async {
    final libDirectory = Directory(p.joinAll(config.libSourcePathParts));
    final collection = createAnalysisContextCollection(libDirectory);
    final endpointsAnalyzer = EndpointsAnalyzer(
      libDirectory,
      collection: collection,
    );
    final yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
    final modelAnalyzer = StatefulAnalyzer(config, yamlModels, (
      uri,
      collector,
    ) {
      collector.printErrors();
    });
    final futureCallsAnalyzer = FutureCallsAnalyzer(
      directory: libDirectory,
      collection: collection,
    );
    return Analyzers(
      endpoints: endpointsAnalyzer,
      models: modelAnalyzer,
      futureCalls: futureCallsAnalyzer,
    );
  }

  /// Creates and primes the analyzers for code generation.
  static Future<Analyzers> createAndUpdate(
    GeneratorConfig config,
  ) async {
    final analyzers = await Analyzers.create(config);
    await analyzers.update(
      config: config,
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
  Future<bool> update({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
    GenerationRequirements requirements = GenerationRequirements.full,
  }) async {
    var shouldGenerate = false;

    if (requirements.generateProtocol) {
      shouldGenerate |= await _endpoints.updateFileContexts(
        affectedPaths,
      );
      shouldGenerate |= await _futureCalls.updateFileContexts(
        affectedPaths,
      );
    }

    if (requirements.generateModels) {
      for (final path in affectedPaths) {
        if (ModelHelper.isModelFile(path, loadConfig: config)) {
          shouldGenerate = true;
          final file = File(path);
          if (file.existsSync()) {
            _models.addYamlModel(
              ModelHelper.createModelSourceForPath(
                config,
                path,
                file.readAsStringSync(),
              ),
            );
          } else {
            _models.removeYamlModel(Uri.parse(p.absolute(path)));
          }
        }
      }
    }
    return shouldGenerate;
  }

  /// Analyze the server package and generate the code.
  ///
  /// When [requirements] is provided, only generates the specified parts.
  /// This allows watch mode to skip expensive model generation when only
  /// Dart files (endpoints/future calls) changed.
  ///
  /// When [affectedPaths] is non-null, model validation only prints hint/info
  /// issues for files in that set (see [StatefulAnalyzer.validateAll]).
  Future<GenerateResult> performGenerate({
    bool dartFormat = true,
    required GeneratorConfig config,
    GenerationRequirements requirements = GenerationRequirements.full,
    Set<String>? affectedPaths,
  }) async {
    bool success = true;

    log.debug('Analyzing serializable models in the protocol directory.');

    final models = _models.validateAll(
      reportIssuesForPaths: affectedPaths,
    );
    success &= !_models.hasSevereErrors;

    List<String> generatedModelFiles = [];

    // Generate model files and a temporary protocol.dart before analyzing
    // future calls and endpoints. The temp protocol exports model classes so
    // that endpoint and future call files can resolve `import protocol.dart`.
    // The full protocol (with Protocol class, endpoint dispatch, etc.) is
    // generated later by ServerpodCodeGenerator.generateProtocolDefinition.
    if (requirements.generateModels) {
      log.debug('Generating files for serializable models.');

      var tempProtocolPath = await _writeTemporaryProtocol(
        models: models,
        config: config,
      );

      generatedModelFiles =
          await ServerpodCodeGenerator.generateSerializableModels(
            models: models,
            config: config,
          );

      await refreshAnalysisContext(
        _futureCalls.collection,
        [...generatedModelFiles, tempProtocolPath],
      );
    }

    log.debug('Analyzing the future calls models.');

    var futureCallsModelsAnalyzerCollector = CodeGenerationCollector();

    final futureCallModels = await _futureCalls.analyzeModels(
      futureCallsModelsAnalyzerCollector,
      models,
    );

    success &= !futureCallsModelsAnalyzerCollector.hasSevereErrors;
    futureCallsModelsAnalyzerCollector.printErrors();

    final allModels = <SerializableModelDefinition>[
      ...models,
      ...futureCallModels,
    ];

    // Regenerate model files if future calls introduced parameter models.
    if (requirements.generateModels && futureCallModels.isNotEmpty) {
      log.debug('Regenerating model files with future call parameter models.');
      generatedModelFiles =
          await ServerpodCodeGenerator.generateSerializableModels(
            models: allModels,
            config: config,
          );
    }

    if (!requirements.generateProtocol) {
      return (success: success, generatedFiles: generatedModelFiles.toSet());
    }

    final changedFiles = requirements.generateModels
        ? {...?affectedPaths, ...generatedModelFiles}
        : {...?affectedPaths};

    log.debug('Analyzing the endpoints.');
    final endpointAnalyzerCollector = CodeGenerationCollector();
    final endpoints = await _endpoints.analyze(
      collector: endpointAnalyzerCollector,
      changedFiles: changedFiles,
    );

    success &= !endpointAnalyzerCollector.hasSevereErrors;
    endpointAnalyzerCollector.printErrors();

    log.debug('Analyzing the future calls.');
    var futureCallsAnalyzerCollector = CodeGenerationCollector();
    var futureCalls = await _futureCalls.analyze(
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
}

/// Writes a temporary protocol.dart that exports all model classes.
///
/// This allows endpoint and future call files to resolve their
/// `import 'protocol.dart'` during analysis. The full protocol (with the
/// Protocol class, endpoint dispatch, etc.) overwrites this later via
/// [ServerpodCodeGenerator.generateProtocolDefinition].
Future<String> _writeTemporaryProtocol({
  required List<SerializableModelDefinition> models,
  required GeneratorConfig config,
}) async {
  var generatedTempProtocol = const DartTemporaryProtocolGenerator()
      .generateSerializableModelsCode(models: models, config: config);

  var protocolPath = generatedTempProtocol.keys.first;
  var content = generatedTempProtocol.values.first;

  var file = File(protocolPath);
  await file.create(recursive: true);
  await file.writeAsString(content, flush: true);

  return protocolPath;
}
