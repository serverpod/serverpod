import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';

/// A [CodeGenerator] that generates a temporary protocol.dart file required
/// for analyzing the endpoints.
///
/// Differently from the other generators, this class is not meant to be invoked
/// by the [ServerpodCodeGenerator], since the temporary protocol file needs to
/// exist for a proper analysis of future calls.
class DartTemporaryProtocolGenerator extends CodeGenerator {
  const DartTemporaryProtocolGenerator();

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
      p.joinAll([
        ...config.generatedServeModelPathParts,
        'protocol.dart',
      ]): serverSideGenerator
          .generateTemporaryProtocol(models: models)
          .generateCode(),
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
