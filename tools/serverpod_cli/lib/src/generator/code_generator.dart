import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/code_generator_dart.dart';
import 'package:serverpod_cli/src/generator/psql/pgsql_generator.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// A code generator is responsible for generating the code for the target language.
abstract class CodeGenerator {
  /// Generate the code.
  /// The key is path of the file, where the code has to be written to,
  /// the value a function that builds the content.
  Map<String, Future<String> Function()> generateCode({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });

  static Future<void> generateAllFiles({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required CodeGenerationCollector collector,
  }) async {
    var allFiles = {
      for (var generator in [DartCodeGenerator(), PgsqlGenerator()])
        ...generator.generateCode(
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
        await out.writeAsString(await file.value());

        collector.addGeneratedFile(out);
      } catch (e, stackTrace) {
        printww('Failed to ${writing ? 'write' : 'generate'} ${file.key}');
        printInternalError(e, stackTrace);
      }
    }
  }
}
