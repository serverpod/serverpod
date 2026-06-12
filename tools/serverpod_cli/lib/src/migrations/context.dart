import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class MigrationGenerationContext {
  MigrationGenerationContext._({required this.modelDefinitions});

  final List<SerializableModelDefinition> modelDefinitions;

  bool get hasClientDatabaseTables => modelDefinitions.any(
    (definition) =>
        definition is ModelClassDefinition &&
        definition.shouldGenerateTableCode(false),
  );

  static Future<MigrationGenerationContext> load(GeneratorConfig config) async {
    var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
    var modelDefinitions = StatefulAnalyzer(config, models, (uri, collector) {
      collector.printErrors();

      if (collector.hasSevereErrors) {
        throw GenerateMigrationDatabaseDefinitionException();
      }
    }).validateAll();

    return MigrationGenerationContext._(modelDefinitions: modelDefinitions);
  }
}
