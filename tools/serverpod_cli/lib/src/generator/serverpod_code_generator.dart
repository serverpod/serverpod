import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

abstract class ServerpodCodeGenerator {
  static final List<CodeGenerator> _generators = [
    const DartServerCodeGenerator(),
    const DartClientCodeGenerator(),
    const DartSharedCodeGenerator(),
    const EndpointDescriptionGenerator(),
  ];

  /// Generate from [CodeGenerator.generateSerializableModelsCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateSerializableModels({
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
    await _writeFiles(allFiles);

    return allFiles.keys.toList();
  }

  /// Generate from [CodeGenerator.generateProtocolCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateProtocolDefinition({
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
    await _writeFiles(allFiles);

    return allFiles.keys.toList();
  }

  /// Writes generated files to disk, skipping files whose content is
  /// unchanged to avoid unnecessary file-system modification timestamps.
  static Future<void> _writeFiles(Map<String, String> files) async {
    for (var file in files.entries) {
      try {
        log.debug('Generating ${file.key}.');
        var out = File(file.key);

        // Skip the write if the file already has the same content.
        if (out.existsSync()) {
          final existing = await out.readAsString();
          if (existing == file.value) continue;
        }

        await out.create(recursive: true);
        await out.writeAsString(file.value, flush: true);
      } catch (e, stackTrace) {
        log.error('Failed to generate ${file.key}.');
        printInternalError(e, stackTrace);
      }
    }
  }

  /// Removes files from previous generation runs.
  /// By removing old files that are not part of the [generatedFiles].
  static Future<void> cleanPreviouslyGeneratedDartFiles({
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
