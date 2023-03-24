import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// Analyze the server package and generate the code.
Future<void> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  String? changedFile,
  required GeneratorConfig config,
  required ProtocolEndpointsAnalyzer endpointsAnalyzer,
}) async {
  var collector = CodeGenerationCollector();

  if (verbose) {
    printww('Analyzing entities in the protocol directory...');
  }
  var entities = await ProtocolEntityAnalyzer.analyzeAll(
    verbose: verbose,
    collector: collector,
    config: config,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    printww('Generating only based on the entity files...');
  }

  var generatedEntityFiles = await CodeGenerator.generateForEntities(
    verbose: verbose,
    entities: entities,
    config: config,
    collector: collector,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    printww('Analyzing endpoints...');
  }

  var endpoints = await endpointsAnalyzer.analyze(
    verbose: verbose,
    collector: collector,
    changedFiles: generatedEntityFiles.toSet(),
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    printww('Generating only based on the entire protocol definition...');
  }

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    entities: entities,
  );

  var generatedProtocolFiles =
      await CodeGenerator.generateForProtocolDefinition(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    printww('Deleting old files.');
  }

  await CodeGenerator.cleanFiles(
    generatedFiles: <String>{
      ...generatedEntityFiles,
      ...generatedProtocolFiles
    },
    protocolDefinition: protocolDefinition,
    config: config,
    verbose: verbose,
  );
}
