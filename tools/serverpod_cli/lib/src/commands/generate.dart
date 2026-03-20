import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
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
  );

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
    final logLevel = log.logLevel;
    if (watch) {
      // Watch mode: the entire loop (generation + file watching) runs in one
      // long-lived isolate so analyzers persist and can be updated
      // incrementally on each file change.
      success = await Isolate.run(
        () => _performGenerateWatch(config: config, logLevel: logLevel),
      );
    } else {
      success = await generateInIsolate(config);
    }

    if (!success) {
      throw ExitException.error();
    } else {
      log.info('Done.', type: TextLogType.success);
    }
  }
}

/// One-shot code generation in an isolate-friendly function.
///
/// Sets the log level (for isolate use) and creates fresh analyzers.
Future<bool> performOneShotGenerate({
  required GeneratorConfig config,
  required LogLevel logLevel,
}) async {
  log.logLevel = logLevel;
  final analyzers = await createAnalyzers(config);
  final allSources = await enumerateSourceFiles(config);
  return analyzeAndGenerate(
    config: config,
    analyzers: analyzers,
    affectedPaths: allSources,
    // Always run generation to prevent bad output from the watch command to be
    // persisted, since the generation stamp will be greater than source files.
    skipStalenessCheck: true,
  );
}

/// Runs one-shot code generation in a fresh isolate.
Future<bool> generateInIsolate(GeneratorConfig config) {
  final logLevel = log.logLevel;
  return Isolate.run(
    () => performOneShotGenerate(config: config, logLevel: logLevel),
  );
}

/// Analyzes affected paths and runs code generation if needed.
///
/// When [skipStalenessCheck] is `true`, skips the mtime check against the
/// generation stamp (use when the caller already knows files changed, e.g.
/// from a file watcher event).
///
/// The [requirements] parameter controls which parts of the generation
/// pipeline run. When model files change, use [GenerationRequirements.full].
/// When only Dart files change, use [GenerationRequirements.protocolOnly]
/// to skip expensive model generation.
///
/// Returns `true` if generation succeeded or was not needed.
///
/// When [skipStalenessCheck] is `true` (watcher-driven runs), model hint/info
/// output is limited to [affectedPaths]. When `false`, all model issues are
/// reported (one-shot generate and runs that re-check staleness against the
/// whole project).
Future<bool> analyzeAndGenerate({
  required GeneratorConfig config,
  required Analyzers analyzers,
  required Set<String> affectedPaths,
  bool skipStalenessCheck = false,
  GenerationRequirements requirements = GenerationRequirements.full,
}) async {
  bool needsGenerate = false;
  await log.progress('Analyzing changes', () async {
    needsGenerate = await updateAnalyzers(
      config: config,
      analyzers: analyzers,
      affectedPaths: affectedPaths,
      requirements: requirements,
    );
    return true;
  });
  if (!needsGenerate) return true;
  if (!skipStalenessCheck && isGenerationUpToDate(config, affectedPaths)) {
    log.debug('All affected files are older than generation stamp, skipping.');
    return true;
  }
  late final GenerateResult result;
  await log.progress('Generating code', () async {
    result = await performGenerate(
      config: config,
      analyzers: analyzers,
      requirements: requirements,
      affectedPaths: skipStalenessCheck ? affectedPaths : null,
    );
    return result.success;
  });
  if (result.success) {
    await writeGenerationStamp(config, generatedFiles: result.generatedFiles);
    log.debug(incrementalCodeGenerationComplete);
  }
  return result.success;
}

/// Watch-mode code generation with persistent analyzers and file watching.
Future<bool> _performGenerateWatch({
  required GeneratorConfig config,
  required LogLevel logLevel,
}) async {
  log.logLevel = logLevel;

  final analyzers = await createAnalyzers(config);
  final allSources = await enumerateSourceFiles(config);
  final success = await analyzeAndGenerate(
    config: config,
    analyzers: analyzers,
    affectedPaths: allSources,
  );
  if (!success) return false;

  log.debug(initialCodeGenerationComplete);

  // Set up file watcher.
  final watcher = config.createFileWatcher();

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
        skipStalenessCheck: true,
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
