import 'dart:async';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart' as gen;
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/util/isolated_object.dart';

/// An [Analyzers] that runs on a dedicated worker isolate via
/// [IsolatedObject].
///
/// All heavy analysis and code generation work happens off the main isolate,
/// keeping the event loop (and TUI) responsive. Follows the same pattern as
/// [IsolatedLogger].
final class IsolatedAnalyzers extends IsolatedObject<Analyzers>
    implements Analyzers {
  IsolatedAnalyzers._(super.create);

  /// Creates and primes analyzers on a worker isolate.
  static Future<IsolatedAnalyzers> create(GeneratorConfig config) async {
    final isolated = IsolatedAnalyzers._(
      () => createAndUpdateAnalyzers(config),
    );
    // Wait for the isolate to finish creating + priming the analyzers.
    await isolated.evaluate((_) {});
    return isolated;
  }

  @override
  Future<GenerateResult> analyzeAndGenerate({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
    bool skipStalenessCheck = false,
    gen.GenerationRequirements requirements = gen.GenerationRequirements.full,
  }) {
    return evaluate(
      (analyzers) => gen.analyzeAndGenerate(
        config: config,
        analyzers: analyzers,
        affectedPaths: affectedPaths,
        skipStalenessCheck: skipStalenessCheck,
        requirements: requirements,
      ),
    );
  }

  // These are not accessible on the isolated proxy - the real instances
  // live on the worker isolate.
  @override
  Never get endpoints => throw UnsupportedError('Use analyzeAndGenerate()');
  @override
  Never get models => throw UnsupportedError('Use analyzeAndGenerate()');
  @override
  Never get futureCalls => throw UnsupportedError('Use analyzeAndGenerate()');
}
