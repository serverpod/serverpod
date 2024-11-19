import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';
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

    var modelAllocatorContext =
        <({SerializableModelDefinition model, Allocator? allocator})>[];

    var clientClasses = models.where((element) => !element.serverOnly).toList();

    var sealedHierarchies = ModelFilterUtil.getSealedHierarchies(clientClasses);

    var modelsWithoutSealedHierarchies =
        ModelFilterUtil.getClassesWithoutSealedHierarchies(clientClasses);

    for (var sealedHierarchy in sealedHierarchies) {
      var topNode =
          sealedHierarchy.firstWhere((element) => element.isSealedTopNode);

      var importCollector = ImportCollector(
        getGeneratedModelPath(topNode, config, false),
      );

      for (var model in sealedHierarchy) {
        var currentPath = getGeneratedModelPath(model, config, false);

        var partOfAllocator = PartOfAllocator(
          currentPath: currentPath,
          importCollector: importCollector,
        );

        modelAllocatorContext.add((
          model: model,
          allocator: model.isSealedTopNode
              ? PartAllocator(partOfAllocator: partOfAllocator)
              : partOfAllocator,
        ));
      }
    }

    for (var model in modelsWithoutSealedHierarchies) {
      modelAllocatorContext.add((
        model: model,
        allocator: null,
      ));
    }

    return {
      for (var entry in modelAllocatorContext)
        getGeneratedModelPath(entry.model, config, false): clientSideGenerator
            .generateModelLibrary(entry.model)
            .generateCode(allocator: entry.allocator),
    };
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
