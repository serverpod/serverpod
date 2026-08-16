import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

import '../generator/dart/client_code_generator/class_constructors_test.dart';

({DatabaseDefinition sourceDefinition, DatabaseDefinition targetDefinition})
databaseDefinitionsFromModels(
  List<ModelSource> sourceModels,
  List<ModelSource> targetModels,
) {
  DatabaseDefinition createDefinition(models) {
    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    assert(
      collector.errors.isEmpty,
      'Errors found during analysis: ${collector.errors}',
    );

    return createDatabaseDefinitionFromModels(
      definitions,
      'example',
      [],
    );
  }

  return (
    sourceDefinition: createDefinition(sourceModels),
    targetDefinition: createDefinition(targetModels),
  );
}
