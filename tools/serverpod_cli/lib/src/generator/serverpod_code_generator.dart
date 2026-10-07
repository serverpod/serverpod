import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/serverpod_manifest_generator.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// The paths a generation step produced, split by whether writing them changed
/// anything on disk.
///
/// [all] is every path the step owns; the generation stamp and the cleanup of
/// stale output both need it in full. [written] is the subset whose content
/// actually changed, and is what the analysis context has to be told about.
/// The distinction matters because the generator rewrites every file on every
/// run while almost none of them change: reporting the full set marks hundreds
/// of unchanged files dirty, and each one then costs a full library resolve
/// that can only arrive at what the analyzer already held.
typedef GeneratedFilePaths = ({List<String> all, Set<String> written});

abstract class ServerpodCodeGenerator {
  static final List<CodeGenerator> _generators = [
    const DartServerCodeGenerator(),
    const DartClientCodeGenerator(),
    const DartSharedCodeGenerator(),
    const EndpointDescriptionGenerator(),
    const ServerpodManifestGenerator(),
  ];

  /// Generate from [CodeGenerator.generateSerializableModelsCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns the generated files, and which of them changed on disk.
  static Future<GeneratedFilePaths> generateSerializableModels({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) async {
    var allFiles = {
      for (var generator in _generators)
        ...generator.generateSerializableModelsCode(
          models: models,
          config: config,
        ),
    };
    var written = await _writeFiles(allFiles);

    return (all: allFiles.keys.toList(), written: written);
  }

  /// Generate from [CodeGenerator.generateProtocolCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns the generated files, and which of them changed on disk.
  static Future<GeneratedFilePaths> generateProtocolDefinition({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) async {
    var allFiles = {
      for (var generator in _generators)
        ...generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        ),
    };
    var written = await _writeFiles(allFiles);

    return (all: allFiles.keys.toList(), written: written);
  }

  /// Writes generated files to disk, skipping files whose content is
  /// unchanged to avoid unnecessary file-system modification timestamps.
  ///
  /// Returns the paths that were actually written. Files are handled in
  /// bounded-concurrency batches: each one is an independent compare-then-write
  /// against its own path, and a project generates hundreds of them, so doing
  /// them one await at a time pays the full round trip per file.
  static Future<Set<String>> _writeFiles(Map<String, String> files) async {
    const concurrency = 32;
    final entries = files.entries.toList();
    final written = <String>{};

    for (var start = 0; start < entries.length; start += concurrency) {
      final batch = entries.skip(start).take(concurrency);
      final results = await Future.wait(batch.map(_writeFile));
      written.addAll(results.nonNulls);
    }

    return written;
  }

  /// Writes one generated file, returning its path when the write happened and
  /// `null` when it was skipped or failed.
  static Future<String?> _writeFile(MapEntry<String, String> file) async {
    try {
      log.debug('Generating ${file.key}.');
      var out = File(file.key);

      // The protocol generator's migration_registry.dart has no `part` directives.
      // `create-migration` adds `part` lines so each migration can ship generated
      // code; if the file on disk already has `part` declarations, skip the write
      // so we do not erase that registry.
      if (p
              .normalize(file.key)
              .endsWith(p.join('migrations', 'migration_registry.dart')) &&
          out.existsSync() &&
          (await out.readAsString()).contains("part '")) {
        return null;
      }

      // Skip the write if the file already has the same content.
      if (out.existsSync()) {
        final existing = await out.readAsString();
        if (existing == file.value) return null;
      }

      await out.create(recursive: true);
      await out.writeAsString(file.value, flush: true);
      return file.key;
    } catch (e, stackTrace) {
      log.error('Failed to generate ${file.key}.');
      printInternalError(e, stackTrace);
      return null;
    }
  }

  /// Removes files from previous generation runs.
  /// By removing old files that are not part of the [generatedFiles].
  static Future<void> cleanPreviouslyGeneratedFiles({
    required Set<String> generatedFiles,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) async {
    log.debug('Cleaning up old files.');
    var dirs = _getDirectoriesRequiringCleaning(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    for (var dir in dirs) {
      await _removeOldFilesInPath(
        dir,
        generatedFiles,
        ['.dart'],
      );
    }

    var manifestPath = p.joinAll(
      config.generatedServerpodManifestFilePathParts,
    );
    if (!generatedFiles.contains(manifestPath)) {
      var manifestFile = File(manifestPath);
      if (await manifestFile.exists()) {
        log.debug('Remove: $manifestFile');
        await manifestFile.delete();
      }
    }
  }
}

/// List all the directories, that may contain files, that should be cleaned
/// after code generation is complete.
///
/// Relative paths start at the server package directory.
List<String> _getDirectoriesRequiringCleaning({
  required ProtocolDefinition protocolDefinition,
  required GeneratorConfig config,
}) {
  return [
    p.joinAll(config.generatedServeModelPathParts),
    p.joinAll(config.generatedDartClientModelPathParts),
    ...config.generatedSharedModelsPaths,
  ];
}

Future<void> _removeOldFilesInPath(
  String directoryPath,
  Set<String> keepPaths,
  List<String> fileExtensions,
) async {
  var directory = Directory(directoryPath);
  log.debug('Remove old files from $directory');
  var fileList = await directory.list(recursive: true).toList();

  for (var file in fileList) {
    // Only check Dart files.
    if (file is! File ||
        !fileExtensions.any((extension) => file.path.endsWith(extension))) {
      continue;
    }

    if (!keepPaths.contains(file.path)) {
      log.debug('Remove: $file');
      await file.delete();
    }
  }
}
