import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/server_test_tools_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';

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

    var modelAllocatorContext = ModelAllocatorContext.build(models, config);

    return {
      for (var entry in modelAllocatorContext.entries)
        entry.model.getFullFilePath(config, serverCode: true):
            serverSideGenerator
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
      p.joinAll([...config.generatedServerProtocolFilePathParts]):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServerEndpointFilePathParts]):
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
