import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/entities_library_generator.dart';

/// A [CodeGenerator] that generates a temporary protocol.dart file required
/// for analyzing the endpoints.
class DartTemporaryProtocolGenerator extends CodeGenerator {
  const DartTemporaryProtocolGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableModelDefinition> entities,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableModelLibraryGenerator(
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
