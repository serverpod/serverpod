import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/entities_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generator.dart';

/// A [CodeGenerator] that generates the client side dart code of a
/// serverpod project.
class ClientCodeGenerator extends CodeGenerator {
  const ClientCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  }) {
    var clientSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: false,
      config: config,
    );

    return {
      for (var protocolFile in entities)
        if (!protocolFile.serverOnly)
          p.joinAll([
            ...config.generatedDartClientProtocolPathParts,
            ...protocolFile.subDirParts,
            '${protocolFile.fileName}.dart',
          ]): clientSideGenerator
              .generateEntityLibrary(protocolFile)
              .generateCode(),
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
      p.joinAll([
        ...config.generatedDartClientProtocolPathParts,
        'protocol.dart'
      ]): clientClassGenerator.generateProtocol().generateCode(),
      p.joinAll(
              [...config.generatedDartClientProtocolPathParts, 'client.dart']):
          clientClassGenerator.generateClientEndpointCalls().generateCode(),
    };
  }
}
