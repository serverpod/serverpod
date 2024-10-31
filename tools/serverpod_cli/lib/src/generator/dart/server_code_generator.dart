import 'package:code_builder/code_builder.dart';
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

    var modelAllocatorContext =
        <({SerializableModelDefinition model, Allocator? allocator})>[];

    var sealedHierarchies = ModelFilterUtil.getSealedHierarchies(models);

    var modelsWithoutSealedHierarchies =
        ModelFilterUtil.getClassesWithoutSealedHierarchies(models);

    for (var sealedHierarchy in sealedHierarchies) {
      var partOfAllocator = PartOfAllocator([]);
      var partAllocator = PartAllocator(partOfAllocator);

      for (var protocolFile in sealedHierarchy) {
        modelAllocatorContext.add((
          model: protocolFile,
          allocator:
              protocolFile.isSealedTopNode ? partAllocator : partOfAllocator
        ));
      }
    }

    for (var protocolFile in modelsWithoutSealedHierarchies) {
      modelAllocatorContext.add((
        model: protocolFile,
        allocator: null,
      ));
    }

    return {
      for (var entry in modelAllocatorContext)
        p.joinAll([
          ...config.generatedServeModelPathParts,
          ...entry.model.subDirParts,
          '${entry.model.fileName}.dart'
        ]): serverSideGenerator
            .generateModelLibrary(entry.model)
            .generateCode(allocator: entry.allocator),
    };
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
