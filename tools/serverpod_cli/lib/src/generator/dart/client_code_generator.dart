import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_filter_util.dart';

/// A [CodeGenerator] that generates the client side dart code of a
/// serverpod project.
class DartClientCodeGenerator extends CodeGenerator {
  const DartClientCodeGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) {
    var clientSideGenerator = SerializableModelLibraryGenerator(
      serverCode: false,
      config: config,
    );
    Map<String, String> generatedCode = {};

    var sealedHierarchies = getSealedHierarchies(models);

    var modelsWithoutSealedHierarchies =
        getClassesWithoutSealedHierarchies(models);

    for (var sealedHierarchy in sealedHierarchies) {
      var partOfAllocator = PartOfAllocator([]);
      var partAllocator = PartAllocator(partOfAllocator);

      for (var model in sealedHierarchy) {
        if (!model.serverOnly) {
          generatedCode[createFilePath(config, model, false)] =
              clientSideGenerator.generateModelLibrary(model).generateCode(
                    partOfAllocator: partOfAllocator,
                    partAllocator: partAllocator,
                  );
        }
      }
    }

    for (var model in modelsWithoutSealedHierarchies) {
      if (!model.serverOnly) {
        generatedCode[createFilePath(config, model, false)] =
            clientSideGenerator.generateModelLibrary(model).generateCode();
      }
    }

    return generatedCode;
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var clientClassGenerator = LibraryGenerator(
      serverCode: false,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    return {
      p.joinAll([...config.generatedDartClientModelPathParts, 'protocol.dart']):
          clientClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedDartClientModelPathParts, 'client.dart']):
          clientClassGenerator.generateClientEndpointCalls().generateCode(),
    };
  }
}
