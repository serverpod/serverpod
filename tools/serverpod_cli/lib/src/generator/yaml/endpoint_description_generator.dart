import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;

class EndpointDescriptionGenerator extends CodeGenerator {
  const EndpointDescriptionGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) {
    return {};
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var out = '';
    for (var endpoint in protocolDefinition.endpoints) {
      out += '${endpoint.name}:\n';
      for (var method in endpoint.methods) {
        out += '  - ${method.name}:\n';
      }
    }

    return {p.join('generated', 'protocol.yaml'): out};
  }
}
