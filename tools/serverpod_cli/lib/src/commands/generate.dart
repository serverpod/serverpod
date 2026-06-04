import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/pubspec_lock_parser.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum GenerateOption<V> implements OptionDefinition<V> {
  watch(
    FlagOption(
      argName: 'watch',
      argAbbrev: 'w',
      defaultsTo: false,
      negatable: false,
      helpText: 'Watch for changes and continuously generate code.',
    ),
  ),
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      defaultsTo: '',
      helpText:
          'The directory to generate code for (defaults to current directory).',
    ),
  ),
  force(
    FlagOption(
      argName: 'force',
      argAbbrev: 'f',
      defaultsTo: false,
      negatable: false,
      helpText:
          'Regenerate even when the output looks up to date. Use this '
          'to rebuild after hand-editing or reverting generated files.',
    ),
  ),
  ;

  const GenerateOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class GenerateCommand extends ServerpodCommand<GenerateOption> {
  @override
  final name = 'generate';
  @override
  final description = 'Generate code from yaml files for server and clients.';

  GenerateCommand() : super(options: GenerateOption.values);

  @override
  Future<void> runWithConfig(
    Configuration<GenerateOption> commandConfig,
  ) async {
    // Always do a full generate.
    bool watch = commandConfig.value(GenerateOption.watch);
    bool force = commandConfig.value(GenerateOption.force);
    String directory = commandConfig.value(GenerateOption.directory);

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    var serverPubspecFile = File(
      path.joinAll([
        ...config.serverPackageDirectoryPathParts,
        'pubspec.yaml',
      ]),
    );
    var clientPubspecFile = File(
      path.joinAll([
        ...config.clientPackagePathParts,
        'pubspec.yaml',
      ]),
    );
    var pubspecsToCheck = [
      serverPubspecFile,
      if (await clientPubspecFile.exists()) clientPubspecFile,
    ].map(PubspecPlus.fromFile);

    // Validate cli version is compatible with serverpod packages
    var cliVersion = Version.parse(templateVersion);
    var warnings = [
      for (var p in pubspecsToCheck)
        ...validateServerpodPackagesVersion(cliVersion, p),
    ];
    if (warnings.isNotEmpty) {
      log.warning(
        'The version of the CLI may be incompatible with the Serverpod '
        'packages used in your project.',
      );
      for (var warning in warnings) {
        log.sourceSpanException(warning);
      }
    }

    // Also check pubspec.lock files if pubspec validation passes
    if (warnings.isEmpty) {
      var serverLockFile = File(
        path.joinAll([
          ...config.serverPackageDirectoryPathParts,
          'pubspec.lock',
        ]),
      );
      var clientLockFile = File(
        path.joinAll([
          ...config.clientPackagePathParts,
          'pubspec.lock',
        ]),
      );

      var lockFilesToCheck = [
        if (await serverLockFile.exists()) serverLockFile,
        if (await clientLockFile.exists()) clientLockFile,
      ].map(PubspecLockParser.fromFile);

      var lockWarnings = [
        for (var lockParser in lockFilesToCheck)
          validateServerpodLockFileVersion(cliVersion, lockParser),
      ].nonNulls;

      for (var warning in lockWarnings) {
        log.sourceSpanException(warning);
      }
    }

    late final bool success;
    if (watch) {
      success = await _performGenerateWatch(config: config, force: force);
    } else {
      success = await performOneShotGenerate(config: config, force: force);
    }

    if (!success) {
      throw ExitException.error();
    } else {
      log.info('Done.', type: TextLogType.success);
    }
  }
}

/// Generates code if it is stale, returning whether it was already [upToDate]
/// and, when generation ran, whether it reported [success].
///
/// [createAnalyzers] must return an unprimed analyzer (ie. [Analyzers.create]).
/// The priming happens inside [analyzeAndGenerate].
///
/// When [keepPrimedWhenFresh] is `false` (one-shot generate) a fresh project
/// When [keepPrimedWhenFresh] is `false` a fresh project returns before the
/// analyzer is created. When `true` the analyzer is always created and primed
/// for an incremental loop.
/// When [force] is `true`, the staleness check is bypassed and generation
/// always runs.
Future<({bool upToDate, bool success})> generateIfStale({
  required GeneratorConfig config,
  required Future<Analyzers> Function() createAnalyzers,
  bool keepPrimedWhenFresh = false,
  bool force = false,
}) async {
  final allSources = await enumerateSourceFiles(config);
  if (!force &&
      !keepPrimedWhenFresh &&
      await isGenerationUpToDate(config, allSources)) {
    return (upToDate: true, success: true);
  }

  final analyzers = await createAnalyzers();
  // Re-verify staleness only when we skipped the up-front check (and aren't
  // forcing); the one-shot path already verified it, so generation runs
  // unconditionally.
  final result = await analyzeAndGenerate(
    config: config,
    analyzers: analyzers,
    affectedPaths: allSources.keys.toSet(),
    verifyStaleness: keepPrimedWhenFresh && !force,
    sourceStats: allSources,
  );
  // A full run only returns an empty file set when it skipped generation
  // because the output was already up to date.
  return (upToDate: result.generatedFiles.isEmpty, success: result.success);
}

/// One-shot code generation in an isolate-friendly function.
///
/// Pass [force] to regenerate even when the output looks up to date.
Future<bool> performOneShotGenerate({
  required GeneratorConfig config,
  bool force = false,
}) async {
  final result = await generateIfStale(
    config: config,
    createAnalyzers: () => Analyzers.create(config),
    force: force,
  );
  if (result.upToDate) {
    log.info(generatedCodeAlreadyUpToDate, type: TextLogType.success);
  }
  return result.success;
}

/// Analyzes affected paths and runs code generation if needed.
///
/// An [incremental] (watcher-driven) run generates only [affectedPaths] and
/// skips when none of them affect generation; a full run regenerates the whole
/// project.
///
/// [verifyStaleness] applies only to full runs: skip generation when the stamp
/// is up to date. Pass `false` when the caller already verified staleness, so
/// generation runs and refreshes the stamp regardless.
///
/// The [requirements] parameter controls which parts of the generation
/// pipeline run. When model files change, use [GenerationRequirements.full].
/// When only Dart files change, use [GenerationRequirements.protocolOnly]
/// to skip expensive model generation.
///
/// Returns a [GenerateResult] with success status and the set of files
/// written by code generation (empty when generation was skipped).
Future<GenerateResult> analyzeAndGenerate({
  required GeneratorConfig config,
  required Analyzers analyzers,
  required Set<String> affectedPaths,
  bool incremental = false,
  bool verifyStaleness = true,
  Map<String, FileStamp>? sourceStats,
  GenerationRequirements requirements = GenerationRequirements.full,
}) async {
  bool needsGenerate = false;
  await log.progress('Analyzing changes', () async {
    needsGenerate = await analyzers.update(
      config: config,
      affectedPaths: affectedPaths,
      requirements: requirements,
    );
    return true;
  });
  if (incremental) {
    if (!needsGenerate) return (success: true, generatedFiles: <String>{});
  } else if (verifyStaleness &&
      sourceStats != null &&
      await isGenerationUpToDate(config, sourceStats)) {
    log.debug('Generated code is up to date, skipping.');
    return (success: true, generatedFiles: <String>{});
  }
  late final GenerateResult result;
  await log.progress('Generating code', () async {
    result = await analyzers.performGenerate(
      config: config,
      requirements: requirements,
      affectedPaths: incremental ? affectedPaths : null,
    );
    return result.success;
  });
  if (result.success) {
    await writeGenerationStamp(
      config,
      generatedFiles: result.generatedFiles,
      // A full run reuses the stamps captured at enumeration; an incremental
      // run re-enumerates, since its affected paths is only the changed subset.
      sourceStats: incremental ? null : sourceStats,
    );
    log.debug(incrementalCodeGenerationComplete);
  }
  return result;
}

/// Watch-mode code generation with persistent analyzers and file watching.
Future<bool> _performGenerateWatch({
  required GeneratorConfig config,
  bool force = false,
}) async {
  // keepPrimedWhenFresh: the incremental loop only updates changed files, so
  // the analyzer must be primed up front even when nothing needs regenerating.
  // In-process is fine here; only start's TUI needs the isolate offload.
  final analyzers = await Analyzers.create(config);
  final initialResult = await generateIfStale(
    config: config,
    createAnalyzers: () async => analyzers,
    keepPrimedWhenFresh: true,
    force: force,
  );
  if (!initialResult.success) {
    await analyzers.close();
    return false;
  }
  if (initialResult.upToDate) {
    log.info(generatedCodeAlreadyUpToDate, type: TextLogType.success);
  }

  log.debug(initialCodeGenerationComplete);

  // Set up file watcher for source directories only (no web or client).
  final watcher = FileWatcher(
    watchPaths: {
      path.absolute(path.joinAll(config.libSourcePathParts)),
      ...config.sharedModelsLibSourcePaths.map(path.absolute),
    },
  );

  // Process file change events.
  await for (final event in watcher.onFilesChanged) {
    final affectedPaths = {
      ...event.dartFiles,
      ...event.modelFiles,
    };

    if (affectedPaths.isEmpty) continue;

    try {
      await analyzeAndGenerate(
        config: config,
        analyzers: analyzers,
        affectedPaths: affectedPaths,
        incremental: true,
      );
    } catch (e, stackTrace) {
      log.error(e.toString(), stackTrace: stackTrace);
    }
  }

  // The await-for loop above runs indefinitely; this is unreachable.
  return true;
}

/// Specifies which parts of the code generation pipeline need to run.
///
/// Used to optimize watch-mode generation by skipping expensive steps
/// (like model generation) when they're not needed.
class GenerationRequirements {
  /// Whether model generation is required.
  /// Set to `true` when model files (.spy, .spy.yaml, .spy.yml) have changed.
  final bool generateModels;

  /// Whether endpoint analysis and protocol generation is required.
  /// Set to `true` when any Dart files have changed.
  final bool generateProtocol;

  const GenerationRequirements({
    required this.generateModels,
    required this.generateProtocol,
  });

  /// Full generation - models and protocol.
  static const full = GenerationRequirements(
    generateModels: true,
    generateProtocol: true,
  );

  /// Protocol-only generation - skips expensive model generation.
  static const protocolOnly = GenerationRequirements(
    generateModels: false,
    generateProtocol: true,
  );
}
