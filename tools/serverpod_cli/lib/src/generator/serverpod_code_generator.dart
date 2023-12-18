import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/temp_protocol_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';

abstract class ServerpodCodeGenerator {
  static final List<CodeGenerator> _generators = [
    const DartTemporaryProtocolGenerator(),
    const DartServerCodeGenerator(),
    const DartClientCodeGenerator(),
    const EndpointDescriptionGenerator(),
  ];

  /// Generate from [CodeGenerator.generateSerializableModelsCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateSerializableModels({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in _generators)
        ...generator.generateSerializableModelsCode(
          models: models,
          config: config,
        )
    };
    for (var file in allFiles.entries) {
      try {
        log.debug('Generating ${file.key}.');
        var out = File(file.key);
        await out.create(recursive: true);
        await out.writeAsString(file.value, flush: true);

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        log.error('Failed to generate ${file.key}!');
        printInternalError(e, stackTrace);
      }
    }

    return allFiles.keys.toList();
  }

  /// Generate from [CodeGenerator.generateProtocolCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateProtocolDefinition({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in _generators)
        ...generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )
    };
    for (var file in allFiles.entries) {
      try {
        log.debug('Generating ${file.key}.');
        var out = File(file.key);
        await out.create(recursive: true);
        await out.writeAsString(file.value, flush: true);

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        log.error('Failed to generate ${file.key}');
        printInternalError(e, stackTrace);
      }
    }

    return allFiles.keys.toList();
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

  for (var entity in fileList) {
    // Only check Dart files.
    if (entity is! File ||
        !fileExtensions.any((extension) => entity.path.endsWith(extension))) {
      continue;
    }

    if (!keepPaths.contains(entity.path)) {
      log.debug('Remove: $entity');
      await entity.delete();
    }
  }
}
