import 'dart:io';

import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart'
    show FutureCallDefinition, futureCallModelsDirectoryName;
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../commands/generate.dart';
import '../commands/watcher.dart';
import 'code_generation_collector.dart';
import 'dart/server_code_generator.dart';
import 'dart/temp_protocol_generator.dart';
import 'dart_formatters.dart';
import 'serverpod_code_generator.dart';

/// Result of a code generation run.
typedef GenerateResult = ({
  bool success,
  Set<String> generatedFiles,
  ProtocolAnalyticsSnapshot? protocolAnalyticsSnapshot,
});

/// Holds the set of analyzers needed for code generation.
///
/// Subclassed by `IsolatedAnalyzers` to run analysis on a worker isolate.
class Analyzers {
  final EndpointsAnalyzer _endpoints;
  final StatefulAnalyzer _models;
  final FutureCallsAnalyzer _futureCalls;

  /// Overlay provider backing the shared analysis context, used to shadow
  /// `protocol.dart` with a temporary stub during generation without touching
  /// the file on disk. `null` when the analyzers were constructed around a
  /// context that is not overlay-backed; the stub is then written to disk.
  final OverlayResourceProvider? _overlay;

  Analyzers({
    required EndpointsAnalyzer endpoints,
    required StatefulAnalyzer models,
    required FutureCallsAnalyzer futureCalls,
    OverlayResourceProvider? overlay,
  }) : _endpoints = endpoints,
       _models = models,
       _futureCalls = futureCalls,
       _overlay = overlay;

  /// Release resources. No-op for local analyzers; overridden by
  /// `IsolatedAnalyzers` to shut down the worker isolate.
  Future<void> close() async {}

  /// Creates the analyzers needed for code generation from [config].
  static Future<Analyzers> create(GeneratorConfig config) async {
    final libDirectory = Directory(p.joinAll(config.libSourcePathParts));
    // Overlay-backed so generation can shadow protocol.dart with a temporary
    // stub in memory instead of writing it to disk (see [performGenerate]).
    final overlay = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
    final collection = createAnalysisContextCollection(
      libDirectory,
      resourceProvider: overlay,
    );
    final generatedDirPaths = config.generatedDirPaths;
    final endpointsAnalyzer = EndpointsAnalyzer(
      libDirectory,
      collection: collection,
      extraClasses: config.extraClasses,
      generatedDirPaths: generatedDirPaths,
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
      generatedDirPaths: generatedDirPaths,
    );
    return Analyzers(
      endpoints: endpointsAnalyzer,
      models: modelAnalyzer,
      futureCalls: futureCallsAnalyzer,
      overlay: overlay,
    );
  }

  /// Creates and primes the analyzers for code generation.
  static Future<Analyzers> createAndUpdate(
    GeneratorConfig config,
  ) async {
    final analyzers = await Analyzers.create(config);
    await analyzers.update(
      config: config,
      affectedPaths: (await enumerateSourceFiles(config)).keys.toSet(),
    );
    return analyzers;
  }

  /// Incrementally updates analyzer state for the given [affectedPaths].
  ///
  /// Refreshes the Dart analysis context for endpoints and future calls,
  /// and updates the model analyzer for changed or removed model files.
  ///
  /// Returns the parts of the generation pipeline the changes call for, as
  /// recognized by the analyzers: model generation when a model file changed,
  /// future call model generation when a future call file changed, and
  /// protocol generation when any of those or an endpoint file changed.
  /// [GenerationRequirements.none] when no change is relevant for code
  /// generation.
  Future<GenerationRequirements> update({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
  }) async {
    // Fingerprinted once per call and used both to drop files that cannot have
    // changed what they declare and to record the result afterwards, so a
    // changed file is read once rather than once per purpose.
    final fingerprints = await _fingerprintDartFiles(affectedPaths);
    _forgetVerdictsIfAnythingChanged(affectedPaths, fingerprints);
    final pathsToAnalyze = _withoutUnchangedNonDeclaringFiles(
      affectedPaths,
      fingerprints,
    );
    if (pathsToAnalyze.isEmpty) return GenerationRequirements.none;

    final endpointsChanged = await _endpoints.updateFileContexts(
      pathsToAnalyze,
    );
    final futureCallsChanged = await _futureCalls.updateFileContexts(
      pathsToAnalyze,
    );
    // Fingerprinted again so a verdict is only kept for content the analyzers
    // have seen.
    final fingerprintsAfterAnalysis = await _fingerprintDartFiles(
      pathsToAnalyze,
    );
    _rememberNonDeclaringFiles(
      pathsToAnalyze,
      fingerprints,
      fingerprintsAfterAnalysis,
    );

    var modelsChanged = false;
    for (final path in affectedPaths) {
      if (ModelHelper.isModelFile(path)) {
        modelsChanged = true;
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
          _models.removeYamlModel(Uri.file(p.absolute(path)));
        }
      }
    }

    return GenerationRequirements(
      generateModels: modelsChanged,
      generateProtocol: endpointsChanged || futureCallsChanged || modelsChanged,
      generateFutureCallModels: futureCallsChanged,
    );
  }

  /// Content fingerprints of Dart files the analyzers examined and found to
  /// declare neither an endpoint nor a future call.
  ///
  /// A watcher event does not mean a file's content changed. Editors rewrite
  /// files wholesale on save, and a format-on-save that changes nothing, a
  /// touch, or a branch checkout that restores identical content all report a
  /// change. When such a file is byte-for-byte what was already analyzed, it
  /// cannot have started declaring something, so analyzing it again can only
  /// reach the same answer.
  ///
  /// Only files whose content is unchanged are skipped. Anything that actually
  /// differs goes to the analyzers, which remain the only thing that decides
  /// what a file declares.
  ///
  /// What a file declares also depends on the code around it: a class starts
  /// declaring an endpoint when the base class it extends, in another file,
  /// becomes one. So these verdicts only hold until something really changes,
  /// see [_forgetVerdictsIfAnythingChanged].
  ///
  /// Keyed by [_fingerprintKey].
  final Map<String, int> _nonDeclaringFingerprints = {};

  /// Content fingerprints of every Dart file passed to [update], whatever it
  /// declares, to tell a file that really changed from one that was only
  /// reported as changed.
  ///
  /// Keyed by [_fingerprintKey].
  final Map<String, int> _contentFingerprints = {};

  /// The key of [path] in the fingerprint maps. The same file can be reported
  /// under differently spelled paths (mixed casing)
  /// which must not make it look like a second file.
  static String _fingerprintKey(String path) => p.canonicalize(path);

  /// Forgets every non-declaring verdict when [paths] contains a real change:
  /// a file that is new, deleted or not a Dart file, or a Dart file with
  /// content that differs from what was last seen.
  ///
  /// A real change anywhere can change what an untouched file declares, so
  /// after one, every file is analyzed again the next time it is reported.
  /// Batches of nothing but unchanged files, which is what a touch or a save
  /// without edits produces, leave the verdicts in place.
  void _forgetVerdictsIfAnythingChanged(
    Set<String> paths,
    Map<String, int> fingerprints,
  ) {
    var anythingChanged = false;
    for (final path in paths) {
      final key = _fingerprintKey(path);
      final fingerprint = fingerprints[path];
      if (fingerprint == null || fingerprint != _contentFingerprints[key]) {
        anythingChanged = true;
      }
      if (fingerprint != null) {
        _contentFingerprints[key] = fingerprint;
      } else {
        _contentFingerprints.remove(key);
      }
    }
    if (anythingChanged) _nonDeclaringFingerprints.clear();
  }

  /// Fingerprints the Dart files among [paths], in bounded-concurrency
  /// batches. A path missing from the result could not be read.
  Future<Map<String, int>> _fingerprintDartFiles(Set<String> paths) async {
    const concurrency = 32;
    final dartPaths = paths.where((path) => path.endsWith('.dart')).toList();
    final fingerprints = <String, int>{};

    for (var start = 0; start < dartPaths.length; start += concurrency) {
      final batch = dartPaths.skip(start).take(concurrency).toList();
      final hashes = await Future.wait(batch.map(_fingerprintOf));
      for (var i = 0; i < batch.length; i++) {
        final hash = hashes[i];
        if (hash != null) fingerprints[batch[i]] = hash;
      }
    }

    return fingerprints;
  }

  /// [paths] without the Dart files already known to declare nothing and whose
  /// content has not changed since that was established.
  Set<String> _withoutUnchangedNonDeclaringFiles(
    Set<String> paths,
    Map<String, int> fingerprints,
  ) {
    if (_nonDeclaringFingerprints.isEmpty) return paths;

    return {
      for (final path in paths)
        // Only Dart files are classified this way; everything else, model
        // files included, passes through untouched. So does a file that could
        // not be fingerprinted, which includes every deletion.
        if (_nonDeclaringFingerprints[_fingerprintKey(path)] == null ||
            _nonDeclaringFingerprints[_fingerprintKey(path)] !=
                fingerprints[path])
          path,
    };
  }

  /// Records the content fingerprint of every Dart file in [paths] that the
  /// analyzers did not take up as an endpoint or future call file.
  ///
  /// The analyzers read a file some time after it was fingerprinted, so a
  /// write in between would attach their verdict to content they never saw.
  /// [fingerprints] were taken before the analysis and
  /// [fingerprintsAfterAnalysis] after it. A file whose two fingerprints differ
  /// changed while it was being analyzed. Nothing is remembered about it, so it
  /// counts as changed and is analyzed again the next time it is reported.
  void _rememberNonDeclaringFiles(
    Set<String> paths,
    Map<String, int> fingerprints,
    Map<String, int> fingerprintsAfterAnalysis,
  ) {
    // The analyzers spell paths as the analysis context does, which may differ
    // from how [paths] spells them, so both sides are compared by key.
    final declaringKeys = {
      for (final path in _endpoints.endpointFiles) _fingerprintKey(path),
      for (final path in _futureCalls.futureCallFiles) _fingerprintKey(path),
    };

    for (final path in paths) {
      final key = _fingerprintKey(path);
      final fingerprint = fingerprints[path];
      if (fingerprint != fingerprintsAfterAnalysis[path]) {
        _nonDeclaringFingerprints.remove(key);
        _contentFingerprints.remove(key);
      } else if (fingerprint == null || declaringKeys.contains(key)) {
        _nonDeclaringFingerprints.remove(key);
      } else {
        _nonDeclaringFingerprints[key] = fingerprint;
      }
    }
  }

  /// A fingerprint of [path]'s bytes, or `null` when it cannot be read.
  ///
  /// Only ever compared against another fingerprint of the same path, so any
  /// stable content hash will do.
  static Future<int?> _fingerprintOf(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      var hash = 0x811c9dc5;
      for (final byte in bytes) {
        hash = ((hash ^ byte) * 0x01000193) & 0xFFFFFFFF;
      }
      // The length sits above the 32-bit hash rather than being mixed into it,
      // so contents of different lengths never share a fingerprint. Contents of
      // the same length still can, when their hashes collide.
      return (bytes.length << 32) | hash;
    } on IOException {
      return null;
    }
  }

  /// Analyze the server package and generate the code.
  ///
  /// When [requirements] is provided, only generates the specified parts.
  /// This allows watch mode to skip expensive model generation when only
  /// Dart files (endpoints/future calls) changed. Future call parameter
  /// models are still generated when
  /// [GenerationRequirements.generateFutureCallModels] is set.
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
    final protocolBackups = <String, String>{};
    final stubOverlayPaths = <String>[];
    var wroteStubsToDisk = false;
    var wroteFullProtocol = false;
    final tempProtocolPaths = <String>[];
    // Analyzer paths where the future calls file is currently shadowed.
    final futureCallsOverlayPaths = <String>[];

    // Refresh the run-scoped registry so persistent analyzers do not retain
    // formatter settings from an earlier generation.
    await GeneratedDartFormatters.resolve(config);

    try {
      log.debug('Analyzing serializable models in the protocol directory.');

      final models = _models.validateAll(reportIssuesForPaths: affectedPaths);
      success &= !_models.hasSevereErrors;

      // Every model file this run owns, for the generation stamp and for
      // cleanup of stale output.
      List<String> generatedModelFiles = [];
      // The subset whose content actually changed, which is all the analysis
      // context needs to hear about.
      Set<String> changedModelFiles = {};

      // Generate model files and temporary protocol.dart stubs before analyzing
      // future calls and endpoints. The temp protocols export model classes so
      // imports against the server and client barrels resolve. The full
      // protocols are generated later by
      // ServerpodCodeGenerator.generateProtocolDefinition.
      if (requirements.generateModels) {
        log.debug('Generating files for serializable models.');

        final tempProtocols = _temporaryProtocols(
          models: models,
          config: config,
        );
        tempProtocolPaths.addAll(tempProtocols.keys);

        final overlay = _overlay;
        if (overlay != null) {
          for (final entry in tempProtocols.entries) {
            // Overlay paths must use the same normalization as
            // refreshAnalysisContext.
            final analyzerPath = p.normalize(File(entry.key).absolute.path);
            overlay.setOverlay(
              analyzerPath,
              content: entry.value,
              modificationStamp: DateTime.now().microsecondsSinceEpoch,
            );
            stubOverlayPaths.add(analyzerPath);
          }
        } else {
          // No overlay provider backs the analysis context; fall back to disk.
          for (final entry in tempProtocols.entries) {
            final protocolFile = File(entry.key);
            if (protocolFile.existsSync()) {
              protocolBackups[entry.key] = await protocolFile.readAsString();
            }
            await protocolFile.create(recursive: true);
            await protocolFile.writeAsString(entry.value, flush: true);
          }
          wroteStubsToDisk = true;
        }

        final modelFiles =
            await ServerpodCodeGenerator.generateSerializableModels(
              models: models,
              config: config,
            );
        generatedModelFiles = modelFiles.all;
        changedModelFiles = modelFiles.written;

        await refreshAnalysisContext(
          _futureCalls.collection,
          [...changedModelFiles, ...tempProtocolPaths],
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
      //
      // The whole set is re-emitted, not just the parameter models: analyzing
      // the future calls above resolves model dependencies a second time, over
      // a model list that now includes the parameter models, and that pass
      // mutates the project models. Emitting only the new files leaves the
      // project models written from the earlier, less resolved state, which
      // drops relations whose foreign field is established by that second pass.
      if (requirements.generateModels && futureCallModels.isNotEmpty) {
        log.debug(
          'Regenerating model files with future call parameter models.',
        );
        final modelFiles =
            await ServerpodCodeGenerator.generateSerializableModels(
              models: allModels,
              config: config,
            );
        generatedModelFiles = modelFiles.all;
        changedModelFiles = {...changedModelFiles, ...modelFiles.written};
      } else if (requirements.generateFutureCallModels &&
          futureCallModels.isNotEmpty) {
        // A future call file changed without any model file changing. Its
        // parameter models come from the Dart file, so they must be written
        // for the protocol generated below to resolve.
        log.debug('Generating files for future call parameter models.');
        final modelFiles =
            await ServerpodCodeGenerator.generateSerializableModels(
              models: futureCallModels,
              config: config,
            );
        generatedModelFiles = modelFiles.all;
        changedModelFiles = {...changedModelFiles, ...modelFiles.written};
      }

      if (!requirements.generateProtocol) {
        return (
          success: success,
          generatedFiles: generatedModelFiles.toSet(),
          protocolAnalyticsSnapshot: null,
        );
      }

      final changedFiles = {...?affectedPaths, ...changedModelFiles};

      log.debug('Analyzing the future calls.');
      var futureCallsAnalyzerCollector = CodeGenerationCollector();
      var futureCalls = await _futureCalls.analyze(
        collector: futureCallsAnalyzerCollector,
        changedFiles: changedFiles,
      );

      success &= !futureCallsAnalyzerCollector.hasSevereErrors;
      futureCallsAnalyzerCollector.printErrors();

      futureCallsOverlayPaths.addAll(
        await _shadowFutureCallsFile(
          models: allModels,
          futureCalls: futureCalls,
          config: config,
          changedFiles: changedFiles,
        ),
      );

      log.debug('Analyzing the endpoints.');
      final endpointAnalyzerCollector = CodeGenerationCollector();
      final endpoints = await _endpoints.analyze(
        collector: endpointAnalyzerCollector,
        models: _models.models,
        changedFiles: changedFiles,
      );

      success &= !endpointAnalyzerCollector.hasSevereErrors;
      endpointAnalyzerCollector.printErrors();

      log.debug('Generating the protocol.');
      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: allModels,
        futureCalls: futureCalls,
      );

      var generatedProtocolFiles =
          (await ServerpodCodeGenerator.generateProtocolDefinition(
            protocolDefinition: protocolDefinition,
            config: config,
          )).all;
      wroteFullProtocol = true;

      // The full protocols are on disk now (or were already up to date); retire
      // the stub overlays so analysis resolves their real content from here on.
      // Same for the future calls overlay.
      if (stubOverlayPaths.isNotEmpty) {
        for (final path in stubOverlayPaths) {
          _overlay!.removeOverlay(path);
        }
        stubOverlayPaths.clear();
        await refreshAnalysisContext(
          _futureCalls.collection,
          tempProtocolPaths,
        );
      }
      if (futureCallsOverlayPaths.isNotEmpty) {
        for (final path in futureCallsOverlayPaths) {
          _overlay!.removeOverlay(path);
        }
        await refreshAnalysisContext(
          _futureCalls.collection,
          futureCallsOverlayPaths,
        );
        futureCallsOverlayPaths.clear();
      }

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
        var previousModelFiles = previousFiles.where(
          (f) => previouslyGeneratedModelsDirs.any((dir) => p.isWithin(dir, f)),
        );

        // When future call parameter models are regenerated, the ones
        // left over from the previous run are stale and should be cleaned.
        if (requirements.generateFutureCallModels) {
          previousModelFiles = previousModelFiles.where(
            (f) => !p.split(f).contains(futureCallModelsDirectoryName),
          );
        }

        allGeneratedFiles.addAll(previousModelFiles);
        log.debug(
          'Preserving ${previousModelFiles.length} existing model files from stamp.',
        );
      }

      await ServerpodCodeGenerator.cleanPreviouslyGeneratedFiles(
        generatedFiles: allGeneratedFiles,
        protocolDefinition: protocolDefinition,
        config: config,
      );

      return (
        success: success,
        generatedFiles: allGeneratedFiles,
        protocolAnalyticsSnapshot: _createProtocolAnalyticsSnapshot(
          protocolDefinition: protocolDefinition,
          config: config,
        ),
      );
    } finally {
      // Retire still-active stubs after an interrupted, models-only, or failed
      // generation. Overlays only need to be removed; disk fallbacks restore
      // any previous protocol contents.
      if (stubOverlayPaths.isNotEmpty) {
        for (final path in stubOverlayPaths) {
          _overlay!.removeOverlay(path);
        }
        await refreshAnalysisContext(
          _futureCalls.collection,
          tempProtocolPaths,
        );
      }
      if (futureCallsOverlayPaths.isNotEmpty) {
        for (final path in futureCallsOverlayPaths) {
          _overlay!.removeOverlay(path);
        }
        await refreshAnalysisContext(
          _futureCalls.collection,
          futureCallsOverlayPaths,
        );
      }
      if (wroteStubsToDisk && !wroteFullProtocol) {
        for (final protocolPath in tempProtocolPaths) {
          final backup = protocolBackups[protocolPath];
          if (backup != null) {
            await File(protocolPath).writeAsString(backup, flush: true);
          }
        }
      }
    }
  }

  /// Makes the generated future calls file resolvable before endpoint
  /// analysis, so endpoints that import it to schedule future calls don't
  /// fail analysis on a clean tree, aborting generation before the file
  /// would be written.
  ///
  /// Like the temporary protocols, the content is shadowed in the analyzer
  /// via the overlay (or written to disk without one); the real file is
  /// written by [ServerpodCodeGenerator.generateProtocolDefinition]. Returns
  /// the overlaid paths for the caller to retire after that write.
  Future<List<String>> _shadowFutureCallsFile({
    required List<SerializableModelDefinition> models,
    required List<FutureCallDefinition> futureCalls,
    required GeneratorConfig config,
    required Set<String> changedFiles,
  }) async {
    final overlayPaths = <String>[];

    final futureCallsCode = const DartServerCodeGenerator()
        .generateFutureCallsCode(
          protocolDefinition: ProtocolDefinition(
            endpoints: const [],
            models: models,
            futureCalls: futureCalls,
          ),
          config: config,
        );

    for (final entry in futureCallsCode.entries) {
      final overlay = _overlay;
      if (overlay != null) {
        // Overlay paths must use the same normalization as
        // refreshAnalysisContext.
        final analyzerPath = p.normalize(File(entry.key).absolute.path);
        overlay.setOverlay(
          analyzerPath,
          content: entry.value,
          modificationStamp: DateTime.now().microsecondsSinceEpoch,
        );
        overlayPaths.add(analyzerPath);
      } else {
        final file = File(entry.key);
        await file.create(recursive: true);
        await file.writeAsString(entry.value, flush: true);
      }
      changedFiles.add(entry.key);
    }

    return overlayPaths;
  }
}

ProtocolAnalyticsSnapshot? _createProtocolAnalyticsSnapshot({
  required ProtocolDefinition protocolDefinition,
  required GeneratorConfig config,
}) {
  try {
    return ProtocolFeatureAnalyzer.analyze(
      protocolDefinition: protocolDefinition,
      config: config,
    );
  } catch (_) {
    // Analytics must never disrupt generation.
    return null;
  }
}

/// Generates temporary protocol.dart stubs for the server and client packages.
///
/// These stubs allow endpoint and future call imports to resolve before the
/// full protocols are generated.
Map<String, String> _temporaryProtocols({
  required List<SerializableModelDefinition> models,
  required GeneratorConfig config,
}) {
  return const DartTemporaryProtocolGenerator().generateSerializableModelsCode(
    models: models,
    config: config,
  );
}
