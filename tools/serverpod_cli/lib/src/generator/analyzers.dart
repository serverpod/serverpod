import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

import '../commands/generate.dart';

/// Result of a code generation run.
typedef GenerateResult = ({bool success, Set<String> generatedFiles});

/// Holds the set of analyzers needed for code generation.
///
/// Subclassed by `IsolatedAnalyzers` to run analysis on a worker isolate.
class Analyzers {
  final EndpointsAnalyzer endpoints;
  final StatefulAnalyzer models;
  final FutureCallsAnalyzer futureCalls;

  Analyzers({
    required this.endpoints,
    required this.models,
    required this.futureCalls,
  });

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
      shouldGenerate |= await endpoints.updateFileContexts(
        affectedPaths,
      );
      shouldGenerate |= await futureCalls.updateFileContexts(
        affectedPaths,
      );
    }

    if (requirements.generateModels) {
      for (final path in affectedPaths) {
        if (ModelHelper.isModelFile(path, loadConfig: config)) {
          shouldGenerate = true;
          final file = File(path);
          if (file.existsSync()) {
            models.addYamlModel(
              ModelHelper.createModelSourceForPath(
                config,
                path,
                file.readAsStringSync(),
              ),
            );
          } else {
            models.removeYamlModel(Uri.parse(p.absolute(path)));
          }
        }
      }
    }
    return shouldGenerate;
  }
}
