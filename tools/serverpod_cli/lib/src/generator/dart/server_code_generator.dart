import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/server_test_tools_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_filter_util.dart';

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

    Map<String, String> generatedCode = {};

    var sealedHierarchies = getSealedHierarchies(models);

    var modelsWithoutSealedHierarchies =
        getClassesWithoutSealedHierarchies(models);

    for (var sealedHierarchy in sealedHierarchies) {
      var partOfAllocator = PartOfAllocator([]);
      var partAllocator = PartAllocator(partOfAllocator);

      for (var protocolFile in sealedHierarchy) {
        generatedCode[createFilePath(config, protocolFile, true)] =
            serverSideGenerator.generateModelLibrary(protocolFile).generateCode(
                  partOfAllocator: partOfAllocator,
                  partAllocator: partAllocator,
                );
      }
    }

    for (var protocolFile in modelsWithoutSealedHierarchies) {
      generatedCode[createFilePath(config, protocolFile, true)] =
          serverSideGenerator.generateModelLibrary(protocolFile).generateCode();
    }

    return generatedCode;
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      protocolDefinition: protocolDefinition,
      config: config,
    );

    var codeMap = {
      p.joinAll([...config.generatedServeModelPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServeModelPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),
    };

    var generatedServerTestToolsPathParts =
        config.generatedServerTestToolsPathParts;
    if (generatedServerTestToolsPathParts != null) {
      var testToolsGenerator = ServerTestToolsGenerator(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      codeMap.addAll({
        p.joinAll([
          ...generatedServerTestToolsPathParts,
          'serverpod_test_tools.dart'
        ]): testToolsGenerator.generateTestHelper().generateCode(),
      });
    }

    return codeMap;
  }
}
