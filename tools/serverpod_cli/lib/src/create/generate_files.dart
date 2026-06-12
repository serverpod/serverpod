import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class GenerateFiles {
  /// Runs the full code generation pipeline.
  ///
  /// Analysis and codegen run on a worker isolate via [IsolatedAnalyzers] so
  /// the main isolate stays responsive during this step.
  static Future<bool> generateFiles(
    Directory serverDir, {
    required bool? interactive,
  }) async {
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(
        serverRootDir: serverDir.path,
        interactive: interactive,
      );
    } catch (e) {
      log.error('An error occurred while parsing the server config file: $e');
      return false;
    }

    final isolated = await IsolatedAnalyzers.create(config);
    try {
      final result = await isolated.performGenerate(config: config);
      return result.success;
    } finally {
      await isolated.close();
    }
  }
}
