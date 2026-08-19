import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/server_test_tools_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/dart/protocol_definition_extension.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';

/// A [CodeGenerator] that generates the server side dart code of a
/// serverpod project.
class DartServerCodeGenerator extends CodeGenerator {
  const DartServerCodeGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableModelLibraryGenerator(
      serverCode: true,
      config: config,
    );

    var serverClasses = models
        .where((element) => !element.isSharedModel)
        .toList();

    var modelAllocatorContext = ModelAllocatorContext.build(
      serverClasses,
      config,
    );

    return serverSideGenerator.generateCode(modelAllocatorContext);
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      sharedPackage: false,
      protocolDefinition: protocolDefinition,
      config: config,
    );

    var protocolPath = p.joinAll(config.generatedServerProtocolFilePathParts);
    var endpointsPath = p.joinAll(config.generatedServerEndpointFilePathParts);

    var codeMap = {
      protocolPath: serverClassGenerator.generateProtocol().generateCode(
        formatter: GeneratedDartFormatters.of(protocolPath),
      ),
      endpointsPath: serverClassGenerator
          .generateServerEndpointDispatch()
          .generateCode(formatter: GeneratedDartFormatters.of(endpointsPath)),
      ...generateFutureCallsCode(
        protocolDefinition: protocolDefinition,
        config: config,
      ),
    };

    // Modules are never booted on their own, so only server packages get the
    // pre-wired Serverpod entry point.
    if (config.type == PackageType.server) {
      var serverpodPath = p.joinAll(
        config.generatedServerServerpodFilePathParts,
      );
      codeMap[serverpodPath] = serverClassGenerator
          .generateServerpodClass()
          .generateCode(formatter: GeneratedDartFormatters.of(serverpodPath));
    }

    var generatedServerTestToolsPathParts =
        config.generatedServerTestToolsPathParts;
    if (generatedServerTestToolsPathParts != null) {
      var testToolsGenerator = ServerTestToolsGenerator(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      var testToolsPath = p.joinAll([
        ...generatedServerTestToolsPathParts,
        'serverpod_test_tools.dart',
      ]);
      codeMap[testToolsPath] = testToolsGenerator
          .generateTestHelper()
          .generateCode(formatter: GeneratedDartFormatters.of(testToolsPath));
    }

    return codeMap;
  }

  /// Generates the server future calls file, if the [protocolDefinition]
  /// contains any future calls.
  ///
  /// This only depends on the future calls (not the endpoints) of the
  /// [protocolDefinition], so it can be generated before endpoint analysis.
  Map<String, String> generateFutureCallsCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    if (!protocolDefinition.shouldGenerateFutureCalls) return {};

    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      sharedPackage: false,
      protocolDefinition: protocolDefinition,
      config: config,
    );

    var futureCallsPath = p.joinAll(
      config.generatedServerFutureCallFilePathParts,
    );

    return {
      futureCallsPath: serverClassGenerator
          .generateServerFutureCalls()
          .generateCode(
            formatter: GeneratedDartFormatters.of(futureCallsPath),
          ),
    };
  }
}
