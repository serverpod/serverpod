import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/library_generators/entities_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';

/// A [CodeGenerator] that generates the server side dart code of a
/// serverpod project.
class ServerCodeGenerator extends CodeGenerator {
  const ServerCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: true,
      config: config,
    );
    return {
      for (var protocolFile in entities)
        p.joinAll([
          ...config.generatedServerProtocolPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
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

    return {
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServerProtocolPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),
    };
  }
}
