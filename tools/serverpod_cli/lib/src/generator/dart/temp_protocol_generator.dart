import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/entities_library_generator.dart';

/// A [CodeGenerator] that generates a temporary protocol.dart file required
/// for analyzing the endpoints.
class TemporaryProtocolGenerator extends CodeGenerator {
  const TemporaryProtocolGenerator();

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
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverSideGenerator
              .generateTemporaryProtocol(entities: entities)
              .generateCode()
    };
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    return {};
  }
}
