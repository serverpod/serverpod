import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart' as gen;
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/generator.dart'
    show updateAnalyzers;
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

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

  /// Analyze affected files and generate code.
  ///
  /// Overridden by `IsolatedAnalyzers` to run on a worker isolate.
  Future<GenerateResult> analyzeAndGenerate({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
    bool skipStalenessCheck = false,
    gen.GenerationRequirements requirements = gen.GenerationRequirements.full,
  }) => gen.analyzeAndGenerate(
    analyzers: this,
    config: config,
    affectedPaths: affectedPaths,
    skipStalenessCheck: skipStalenessCheck,
    requirements: requirements,
  );

  /// Release resources. No-op for local analyzers; overridden by
  /// `IsolatedAnalyzers` to shut down the worker isolate.
  Future<void> close() async {}
}

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
  return Analyzers(
    endpoints: endpointsAnalyzer,
    models: modelAnalyzer,
    futureCalls: futureCallsAnalyzer,
  );
}

/// Creates and primes the analyzers for code generation.
Future<Analyzers> createAndUpdateAnalyzers(GeneratorConfig config) async {
  final analyzers = await createAnalyzers(config);
  await updateAnalyzers(
    config: config,
    analyzers: analyzers,
    affectedPaths: await enumerateSourceFiles(config),
  );
  return analyzers;
}
