import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
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
  final endpointsAnalyzer = EndpointsAnalyzer(libDirectory);
  final yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
  final modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
    collector.printErrors();
  });
  final futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
  );
  return (
    endpoints: endpointsAnalyzer,
    models: modelAnalyzer,
    futureCalls: futureCallsAnalyzer,
  );
}

/// Incrementally updates analyzer state for the given [affectedPaths].
///
/// Refreshes the Dart analysis context for endpoints and future calls,
/// and updates the model analyzer for changed or removed model files.
///
/// When [skipStalenessCheck] is `false` (default), checks whether the
/// affected files are newer than the generation stamp. If all files are
/// up to date, returns `false` without doing any analysis.
/// Set to `true` when the caller already knows the files changed (e.g.
/// from a file watcher event).
///
/// Returns `true` if any of the changes are relevant for code generation
/// (endpoint, future call, or model changes), `false` otherwise.
Future<bool> updateAnalyzers({
  required GeneratorConfig config,
  required Analyzers analyzers,
  required Set<String> affectedPaths,
  bool skipStalenessCheck = false,
}) async {
  if (!skipStalenessCheck && isGenerationUpToDate(config, affectedPaths)) {
    log.debug('All affected files are older than generation stamp, skipping.');
    return false;
  }

  var shouldGenerate = false;

  shouldGenerate |= await analyzers.endpoints.updateFileContexts(affectedPaths);
  shouldGenerate |= await analyzers.futureCalls.updateFileContexts(
    affectedPaths,
  );

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

  if (!shouldGenerate) {
    log.debug('No relevant changes detected, skipping code generation.');
  }

  return shouldGenerate;
}

/// Result of a code generation run.
typedef GenerateResult = ({bool success, Set<String> generatedFiles});

/// Analyze the server package and generate the code.
Future<GenerateResult> performGenerate({
  bool dartFormat = true,
  required GeneratorConfig config,
  required Analyzers analyzers,
}) async {
  bool success = true;

  log.debug('Analyzing serializable models in the protocol directory.');

  final models = analyzers.models.validateAll();
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

  final generatedModelFiles =
      await ServerpodCodeGenerator.generateSerializableModels(
        models: allModels,
        config: config,
      );

  log.debug('Analyzing the endpoints.');

  final endpointAnalyzerCollector = CodeGenerationCollector();
  final endpoints = await analyzers.endpoints.analyze(
    collector: endpointAnalyzerCollector,
    changedFiles: generatedModelFiles.toSet(),
  );

  success &= !endpointAnalyzerCollector.hasSevereErrors;
  endpointAnalyzerCollector.printErrors();

  log.debug('Analyzing the future calls.');

  var futureCallsAnalyzerCollector = CodeGenerationCollector();
  var futureCalls = await analyzers.futureCalls.analyze(
    collector: futureCallsAnalyzerCollector,
    changedFiles: generatedModelFiles.toSet(),
    analyzedModels: allModels,
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

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: allGeneratedFiles,
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return (success: success, generatedFiles: allGeneratedFiles);
}

/// Computes the list of directories to watch for file changes.
///
/// Includes server `lib/` and shared model package `lib/` directories.
/// If [includeWeb] is true, also includes the `web/` directory (if it exists).
/// If [includeClientPackage] is true, also includes the client package `lib/`
/// directory so that generated client code changes are picked up (needed for
/// compilation in `serverpod start --watch`).
List<String> watchPathsFromConfig(
  GeneratorConfig config, {
  bool includeWeb = false,
  bool includeClientPackage = false,
}) {
  final paths = <String>[
    p.absolute(p.joinAll(config.libSourcePathParts)),
    for (final pathParts in config.sharedModelsSourcePathsParts.values)
      p.absolute(
        p.joinAll([
          ...config.serverPackageDirectoryPathParts,
          ...pathParts,
          'lib',
        ]),
      ),
  ];

  if (includeClientPackage) {
    final clientLib = p.absolute(
      p.joinAll([...config.clientPackagePathParts, 'lib']),
    );
    if (Directory(clientLib).existsSync()) {
      paths.add(clientLib);
    }
  }

  if (includeWeb) {
    final webPath = p.absolute(
      p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
    );
    if (Directory(webPath).existsSync()) {
      paths.add(webPath);
    }
  }

  return paths;
}
