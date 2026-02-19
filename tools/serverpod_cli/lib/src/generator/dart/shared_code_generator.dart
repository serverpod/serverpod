import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/shared.dart';

/// A [CodeGenerator] that generates dart code for shared (model-only) packages.
/// Shared package models depend only on [serverpod_serialization] and are
/// generated into their own package directories, not into the client or server.
class DartSharedCodeGenerator extends CodeGenerator {
  const DartSharedCodeGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) {
    var sharedModels = models.where((e) => e.isSharedModel).toList();
    if (sharedModels.isEmpty) return {};

    var generator = SerializableModelLibraryGenerator(
      serverCode: false,
      config: config,
    );

    var result = <String, String>{};

    for (var packageName in config.sharedModelsSourcePathsParts.keys) {
      var packageModels = sharedModels
          .where((m) => m.sharedPackageName == packageName)
          .toList();
      if (packageModels.isEmpty) continue;

      var modelAllocatorContext = ModelAllocatorContext.build(
        packageModels,
        config,
      );

      for (var entry in modelAllocatorContext.entries) {
        var path = entry.model.getFullFilePath(config, serverCode: false);
        var code = generator
            .generateModelLibrary(entry.model)
            .generateCode(allocator: entry.allocator)
            .replaceAll(serverpodProtocolUrl(false), serverpodSerializationUrl);
        result[path] = code;
      }
    }

    return result;
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var result = <String, String>{};

    for (var e in config.sharedModelsSourcePathsParts.entries) {
      var packageModels = protocolDefinition.models
          .where((m) => m.sharedPackageName == e.key)
          .toList();

      if (packageModels.isEmpty) continue;
      var sharedClassGenerator = LibraryGenerator(
        serverCode: false,
        sharedPackage: true,
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: packageModels,
          futureCalls: [],
        ),
        config: GeneratorConfig(
          name: config.name,
          type: config.type,
          serverPackage: config.serverPackage,
          dartClientPackage: config.dartClientPackage,
          dartClientDependsOnServiceClient:
              config.dartClientDependsOnServiceClient,
          serverPackageDirectoryPathParts:
              config.serverPackageDirectoryPathParts,
          sharedModelsSourcePathsParts: config.sharedModelsSourcePathsParts,
          relativeDartClientPackagePathParts: config.clientPackagePathParts
              .skip(config.serverPackageDirectoryPathParts.length)
              .toList(),
          extraClasses: [],
          enabledFeatures: config.enabledFeatures,
          modules: [],
          experimentalFeatures: config.experimentalFeatures,
        ),
      );

      result[p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        ...e.value,
        'lib',
        'src',
        'generated',
        'protocol.dart',
      ])] = sharedClassGenerator.generateProtocol().generateCode().replaceAll(
        serverpodProtocolUrl(false),
        serverpodSerializationUrl,
      );
    }

    return result;
  }
}
