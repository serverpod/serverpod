import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';

/// Analyze the server package and generate the code.
Future<void> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  String? changedFile,
  required GeneratorConfig config,
  required ProtocolAnalyzer analyzer,
}) async {
  var collector = CodeGenerationCollector();

  var protocolDefinition = await analyzer.analyze(
    verbose: verbose,
    collector: collector,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    print('Generating classes.');
  }

  await CodeGenerator.generateAll(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
    cleanDirectories: true,
  );
}
