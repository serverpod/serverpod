import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
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
        resolveUrl: _sharedPackageUrl,
      );

      // Prefixes are assigned from the complete set of imports, so every
      // library is emitted once to collect them before any is generated.
      var libraries = [
        for (var entry in modelAllocatorContext.entries)
          (entry: entry, library: generator.generateModelLibrary(entry.model)),
      ];

      for (var (:entry, :library) in libraries) {
        library.collectImports(entry.allocator);
      }

      for (var (:entry, :library) in libraries) {
        var path = entry.model.getFullFilePath(config, serverCode: false);
        result[path] = library.generateCode(
          allocator: entry.allocator,
          formatter: GeneratedDartFormatters.of(path),
        );
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
          databaseDialect: config.databaseDialect,
          experimentalFeatures: config.experimentalFeatures,
        ),
      );

      var protocolPath = p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        ...e.value,
        'lib',
        ...config.generatedServeModelPackagePathParts,
        'protocol.dart',
      ]);

      var protocol = sharedClassGenerator.generateProtocol();
      var allocator = StableImportAllocator(resolveUrl: _sharedPackageUrl);
      protocol.collectImports(allocator);

      result[protocolPath] = protocol.generateCode(
        allocator: allocator,
        formatter: GeneratedDartFormatters.of(protocolPath),
      );
    }

    return result;
  }
}

/// The package a shared model imports for [url].
///
/// Maps a serverpod URL to the package holding the classes it exports, for
/// a package that depends on neither the client nor the server.
///
/// Resolving URLs like this prevents having to transform all `serverCode`
/// bool parameters into an enum to account for shared packages as well. The
/// ideal solution is to refactor the code generator to avoid plumbing that
/// parameter to several calls as we currently do.
String _sharedPackageUrl(String url) => url
    .replaceAll(
      serverpodProtocolUrl(false),
      serverpodSerializationUrl,
    )
    .replaceAll(
      serverpodUrl(false),
      serverpodDatabaseUrl(false),
    )
    .replaceAll(
      serverpodServiceClientUrl(false),
      serverpodDatabaseUrl(false),
    );
