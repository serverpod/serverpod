import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';

/// A [CodeGenerator] that generates temporary protocol.dart files required
/// for analyzing endpoints and future calls.
///
/// Differently from the other generators, this class is not meant to be invoked
/// by the [ServerpodCodeGenerator], since the temporary protocol files need to
/// exist for a proper analysis of future calls and endpoints.
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
    var clientSideGenerator = SerializableModelLibraryGenerator(
      serverCode: false,
      config: config,
    );
    var projectModels = models.where((model) => !model.isSharedModel).toList();
    var clientModels = projectModels
        .where((model) => !model.serverOnly)
        .toList();
    return {
      p.joinAll([
        ...config.generatedServeModelPathParts,
        'protocol.dart',
      ]): serverSideGenerator
          .generateTemporaryProtocol(models: projectModels)
          .generateCode(),
      p.joinAll([
        ...config.generatedDartClientModelPathParts,
        'protocol.dart',
      ]): clientSideGenerator
          .generateTemporaryProtocol(models: clientModels)
          .generateCode(),
      for (final sharedPackage in config.sharedModelsSourcePathsParts.entries)
        p.joinAll([
          ...config.serverPackageDirectoryPathParts,
          ...sharedPackage.value,
          'lib',
          'src',
          'generated',
          'protocol.dart',
        ]): clientSideGenerator
            .generateTemporaryProtocol(
              models: models
                  .where(
                    (model) => model.sharedPackageName == sharedPackage.key,
                  )
                  .toList(),
            )
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
