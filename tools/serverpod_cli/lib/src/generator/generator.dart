import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';

import 'code_cleaner.dart';
import '../analyzer/dart/endpoints_analyzer.dart';

Future<void> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  String? changedFile,
  required GeneratorConfig config,
  required EndpointsAnalyzer analyzer,
}) async {
  var collector = CodeGenerationCollector();

  var protocolDefinition = await ProtocolAnalyzer(
    packageDirectory: '',
    config: config,
  ).analyze(
    verbose: verbose,
    collector: collector,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    print('Generating classes.');
  }

  await CodeGenerator.generateAllFiles(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
  );

  if (verbose) {
    print('Cleaning up old files.');
  }

  performRemoveOldFiles(
    verbose: verbose,
    collector: collector,
    generatedServerProtocolPath: config.relativeGeneratedServerProtocolPath,
    generatedClientProtocolPath: config.relativeGeneratedClientProtocolPath,
  );
}
