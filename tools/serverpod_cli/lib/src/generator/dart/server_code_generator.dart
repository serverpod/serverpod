import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';

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
    return {
      for (var protocolFile in models)
        p.joinAll([
          ...config.generatedServeModelPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
            .generateModelLibrary(protocolFile)
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
      p.joinAll([...config.generatedServeModelPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServeModelPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),
    };
  }
}
