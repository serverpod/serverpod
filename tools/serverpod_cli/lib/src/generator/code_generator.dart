import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/code_generator_dart.dart';
import 'package:serverpod_cli/src/generator/psql/pgsql_generator.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/print.dart';

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
    required bool verbose,
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
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  /// List all the directories, that may contain files, that should be cleaned.
  /// For most [CodeGenerator]s, the output should just depend on [config].
  ///
  /// Relative paths start at the server package directory.
  @protected
  Future<List<String>> getDirectoriesRequiringCleaning({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  /// The file extensions, this generator uses when generating files.
  @protected
  List<String> get outputFileExtensions;

  /// The generators, that run on [generateAll].
  static const generators = [DartCodeGenerator(), PgsqlCodeGenerator()];

  /// Generate from [CodeGenerator.generateSerializableEntitiesCode] for all
  /// [CodeGenerator]s and save the files.
  ///
  /// Returns a list of generated files.
  static Future<List<String>> generateSerializableEntities({
    required bool verbose,
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in generators)
        ...generator.generateSerializableEntitiesCode(
          verbose: verbose,
          entities: entities,
          config: config,
        )
    };
    for (var file in allFiles.entries) {
      bool writing = false;
      try {
        if (verbose) {
          printww('Generating ${file.key}...');
        }
        var out = File(file.key);
        writing = true;
        if (verbose) {
          printww('Writing ${file.key}...');
        }
        await out.create(recursive: true);
        await out.writeAsString(file.value, flush: true);

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        printww('Failed to ${writing ? 'write' : 'generate'} ${file.key}');
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
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in generators)
        ...generator.generateProtocolCode(
          verbose: verbose,
          protocolDefinition: protocolDefinition,
          config: config,
        )
    };
    for (var file in allFiles.entries) {
      bool writing = false;
      try {
        if (verbose) {
          printww('Generating ${file.key}...');
        }
        var out = File(file.key);
        writing = true;
        if (verbose) {
          printww('Writing ${file.key}...');
        }
        await out.create(recursive: true);
        await out.writeAsString(file.value, flush: true);

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        printww('Failed to ${writing ? 'write' : 'generate'} ${file.key}');
        printInternalError(e, stackTrace);
      }
    }

    return allFiles.keys.toList();
  }

  /// Removes files from previous generation runs.
  /// By removing old files that are not part of the [generatedFiles] in the
  /// [CodeGenerator.getDirectoriesRequiringCleaning] for each [CodeGenerator].
  static Future<void> cleanPreviouslyGeneratedFiles({
    required Set<String> generatedFiles,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required bool verbose,
  }) async {
    if (verbose) {
      printww('Cleaning up old files.');
    }
    for (var generator in generators) {
      var dirs = await generator.getDirectoriesRequiringCleaning(
          verbose: verbose,
          protocolDefinition: protocolDefinition,
          config: config);

      for (var dir in dirs) {
        await _removeOldFilesInPath(
          dir,
          generatedFiles,
          verbose,
          generator.outputFileExtensions,
        );
      }
    }
  }
}

Future<void> _removeOldFilesInPath(
  String directoryPath,
  Set<String> keepPaths,
  bool verbose,
  List<String> fileExtensions,
) async {
  var directory = Directory(directoryPath);
  if (verbose) {
    print('Remove old files from $directory');
  }
  var fileList = await directory.list(recursive: true).toList();

  for (var entity in fileList) {
    // Only check Dart files.
    if (entity is! File ||
        !fileExtensions.any((extension) => entity.path.endsWith(extension))) {
      continue;
    }

    if (!keepPaths.contains(entity.path)) {
      if (verbose) {
        print('Remove: $entity');
      }
      await entity.delete();
    }
  }
}
