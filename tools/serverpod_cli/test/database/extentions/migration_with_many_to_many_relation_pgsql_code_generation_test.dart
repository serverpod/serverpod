import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../generator/dart/client_code_generator/class_constructors_test.dart';

void main() {
  test(
      'Given a table that is referenced by another one, when it is renamed, then the migration code should not drop the foreign key twice',
      () {
    DatabaseDefinition sourceDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition =
          createDatabaseDefinitionFromModels(definitions, 'example', []);
    }

    DatabaseDefinition
        targetDefinition; // renames table `target` to `target_new`
    {
      var models = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target_new
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      targetDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
    }

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    expect(psql, isNot(contains('DROP CONSTRAINT "source_fk_0"')));
    expect(psql, contains('ADD CONSTRAINT "source_fk_0"'));
  });
}
