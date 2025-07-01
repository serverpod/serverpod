import 'package:path/path.dart' as p;

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';

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

    var clientClasses = models.where((element) => !element.serverOnly).toList();

    var modelAllocatorContext =
        ModelAllocatorContext.build(clientClasses, config);

    return {
      for (var entry in modelAllocatorContext.entries)
        entry.model.getFullFilePath(config, serverCode: false):
            clientSideGenerator
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
