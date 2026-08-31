import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/sync.dart';
import 'package:serverpod_cli/src/config/serverpod_manifest.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';

class ServerpodManifestGenerator extends CodeGenerator {
  const ServerpodManifestGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
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
    if (config.type == PackageType.server) {
      return {};
    }

    var manifest = ServerpodManifest(
      sharedPackages: config.sharedModelsSourcePathsParts.keys,
      syncTables: config.syncModule != null,
    );
    if (manifest.isEmpty) return {};

    return {
      p.joinAll(config.generatedServerpodManifestFilePathParts): manifest
          .toYaml(),
    };
  }
}
