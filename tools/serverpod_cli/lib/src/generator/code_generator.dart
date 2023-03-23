import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/code_generator_dart.dart';
import 'package:serverpod_cli/src/generator/psql/pgsql_generator.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// A code generator is responsible for generating the code for the target language.
abstract class CodeGenerator {
  /// Create a new [CodeGenerator].
  const CodeGenerator();

  /// Generate the code.
  /// The key is path of the file, where the code has to be written to,
  /// the value a function that builds the content.
  ///
  /// Relative paths start at the server package directory.
  Map<String, Future<String> Function()> getCodeGeneration({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  /// List all the directories, that may contain files, that should be cleaned.
  /// For most [CodeGenerator]s, the output should just depend on [config].
  ///
  /// Relative paths start at the server package directory.
  Future<List<String>> getDirectoriesRequiringCleaning({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  /// The file extensions, this generator uses when generating files.
  List<String> get outputFileExtensions;

  /// The generators, that run on [generateAll].
  static const generators = [DartCodeGenerator(), PgsqlGenerator()];

  /// Run all [CodeGenerator]s and save the files.
  ///
  /// Set [cleanDirectories] to true, in order to delete old files in the output directories.
  /// The output directories, that may required cleaning are defined by [getDirectoriesRequiringCleaning].
  static Future<void> generateAll({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
    required bool cleanDirectories,
  }) async {
    collector.generatedFiles.clear();
    var allFiles = {
      for (var generator in generators)
        ...generator
            .getCodeGeneration(
          verbose: verbose,
          protocolDefinition: protocolDefinition,
          config: config,
        )
            .map((key, value) {
          if (verbose) {
            printww(key);
          }
          return MapEntry(key, value);
        })
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
        await out.writeAsString(await file.value());

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        printww('Failed to ${writing ? 'write' : 'generate'} ${file.key}');
        printInternalError(e, stackTrace);
      }
    }

    if (cleanDirectories) {
      if (verbose) {
        printww('Cleaning up old files.');
      }
      var keepPaths = allFiles.keys.toSet();
      for (var generator in generators) {
        var dirs = await generator.getDirectoriesRequiringCleaning(
            verbose: verbose,
            protocolDefinition: protocolDefinition,
            config: config);

        for (var dir in dirs) {
          await _removeOldFilesInPath(
            dir,
            keepPaths,
            verbose,
            generator.outputFileExtensions,
          );
        }
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
