import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/code_generator_dart.dart';
import 'package:serverpod_cli/src/generator/psql/legacy_pgsql_generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';

/// A code generator is responsible for generating the code for the target
/// language.
abstract class CodeGenerator {
  /// Create a new [CodeGenerator].
  const CodeGenerator();

  /// Generates the content of files that only depend the SerializableEntities.
  ///
  /// Returns a map where they key is the path of the file and the the value is
  /// the files content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// Called and generated before [generateProtocolCode].
  @protected
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  });

  /// Generate the content of files that depend on the entire
  /// [ProtocolDefinition].
  ///
  /// Returns a map where they key is the path of the file and the the value is
  /// the files content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// At the time this is called, [generateSerializableEntitiesCode] should
  /// already be called and generated.
  @protected
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  /// The generators, that run on [generateAll].
  static const generators = [DartCodeGenerator(), LegacyPgsqlCodeGenerator()];

  /// Generate from [CodeGenerator.generateSerializableEntitiesCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateSerializableEntities({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in generators)
        ...generator.generateSerializableEntitiesCode(
          entities: entities,
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
      for (var generator in generators)
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
        protocolDefinition: protocolDefinition, config: config);

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
    p.joinAll(config.generatedServerProtocolPathParts),
    p.joinAll(config.generatedDartClientProtocolPathParts),
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
