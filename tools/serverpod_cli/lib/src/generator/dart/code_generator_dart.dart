import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/entities_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generator.dart';

/// A [CodeGenerator], that generates dart code.
class DartCodeGenerator extends CodeGenerator {
  /// Create a new [DartCodeGenerator]
  const DartCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: true,
      config: config,
    );
    var clientSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: false,
      config: config,
    );

    return {
      // Server
      // Generate a temporary protocol.dart file. Since this is required to
      // analyze the endpoints.
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverSideGenerator
              .generateTemporaryProtocol(entities: entities)
              .generateCode(),
      for (var protocolFile in entities)
        p.joinAll([
          ...config.generatedServerProtocolPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
            .generateEntityLibrary(protocolFile)
            .generateCode(),

      // Client
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
    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    var clientClassGenerator = LibraryGenerator(
      serverCode: false,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    return {
      // Server
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServerProtocolPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),

      // Client
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
