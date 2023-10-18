import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

/// Analyze the server package and generate the code.
Future<bool> performGenerate({
  bool dartFormat = true,
  String? changedFile,
  Set<CodeOutputFormats> codeGenerationType = const {
    CodeOutputFormats.dart,
  },
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
}) async {
  var collector = CodeGenerationCollector();
  bool success = true;

  log.debug('Analyzing serializable entities in the protocol directory.');
  var protocols = await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

  var analyzer = StatefulAnalyzer(protocols, (uri, collector) {
    collector.printErrors();

    if (collector.hasSeverErrors) {
      success = false;
    }
  });

  analyzer.validateAll();
  var entities = analyzer.validEntities;

  log.debug('Generating files for serializable entities.');

  var generatedEntityFiles =
      await ServerpodCodeGenerator.generateSerializableEntities(
    entities: entities,
    config: config,
    collector: collector,
  );

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Analyzing the endpoints.');

  var endpoints = await endpointsAnalyzer.analyze(
    collector: collector,
    changedFiles: generatedEntityFiles.toSet(),
  );

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Generating the protocol.');

  var protocolDefinition = ProtocolDefinition(
    endpoints: endpoints,
    entities: entities,
  );

  var generatedProtocolFiles =
      await ServerpodCodeGenerator.generateProtocolDefinition(
    protocolDefinition: protocolDefinition,
    config: config,
    collector: collector,
  );

  List<String>? generatedOpenAPIFiles;
  if (codeGenerationType.contains(CodeOutputFormats.openAPI)) {
    log.debug('Generating openAPI schema');
    generatedOpenAPIFiles = await ServerpodCodeGenerator.generateOpenAPISchema(
      protocolDefinition: protocolDefinition,
      config: config,
      collector: collector,
    );
  }

  if (collector.hasSeverErrors) {
    success = false;
  }
  collector.printErrors();
  collector.clearErrors();

  log.debug('Cleaning old files.');

  await ServerpodCodeGenerator.cleanPreviouslyGeneratedDartFiles(
    generatedFiles: {
      ...generatedEntityFiles,
      ...generatedProtocolFiles,
      if (generatedOpenAPIFiles != null) ...generatedOpenAPIFiles,
    },
    protocolDefinition: protocolDefinition,
    config: config,
  );

  return success;
}
