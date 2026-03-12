import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
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
/// Returns `true` if any of the changes are relevant for code generation
/// (endpoint, future call, or model changes), `false` otherwise.
Future<bool> updateAnalyzers({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  required FutureCallsAnalyzer futureCallsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
  required Set<String> affectedPaths,
}) async {
  var shouldGenerate = false;

  shouldGenerate |= await endpointsAnalyzer.updateFileContexts(affectedPaths);
  shouldGenerate |= await futureCallsAnalyzer.updateFileContexts(affectedPaths);

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
  }

  return shouldGenerate;
}

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

  log.debug('Analyzing the future calls models.');

  var futureCallsModelsAnalyzerCollector = CodeGenerationCollector();

  final futureCallModels = await futureCallsAnalyzer.analyzeModels(
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

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: <String>{...generatedModelFiles, ...generatedProtocolFiles},
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return success;
}

/// Computes the list of directories to watch for file changes.
///
/// Includes `lib/` and shared model package `lib/` directories.
/// If [includeWeb] is true, also includes the `web/` directory (if it exists).
List<String> watchPathsFromConfig(
  GeneratorConfig config, {
  bool includeWeb = false,
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
