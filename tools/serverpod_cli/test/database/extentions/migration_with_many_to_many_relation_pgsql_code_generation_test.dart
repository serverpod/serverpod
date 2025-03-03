import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../generator/dart/client_code_generator/class_constructors_test.dart';
import '../../test_util/builders/model_source_builder.dart';

void main() {
  test(
      'Given a table that is referenced by another one, when it is renamed, then the migration code should drop both tables and recreate them in a working order',
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

      sourceDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
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

    var dropTableSourceIndex = psql.indexOf('DROP TABLE "source"');
    var dropTableTargetIndex = psql.indexOf('DROP TABLE "target"');
    var createTableSourceIndex = psql.indexOf('CREATE TABLE "source"');
    var createTableTargetIndex = psql.indexOf('CREATE TABLE "target_new"');
    var addForegeinKeyIndex = psql.indexOf('ADD CONSTRAINT "source_fk_0"');

    expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
    expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
    expect(createTableSourceIndex, greaterThanOrEqualTo(0));
    expect(createTableTargetIndex, greaterThanOrEqualTo(0));
    expect(addForegeinKeyIndex, greaterThanOrEqualTo(0));

    expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
    expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
    expect(createTableSourceIndex, lessThan(createTableTargetIndex));
    expect(createTableTargetIndex, lessThan(addForegeinKeyIndex));
  });

  test(
      'Given a table that is optionally referenced by another one, when it is renamed, then the migration code should drop both tables and recreate them in a working order',
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
  target: Target?, relation(optional)
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
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
  target: Target?, relation(optional)
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

    var dropTableSourceIndex = psql.indexOf('DROP TABLE "source"');
    var dropTableTargetIndex = psql.indexOf('DROP TABLE "target"');
    var createTableSourceIndex = psql.indexOf('CREATE TABLE "source"');
    var createTableTargetIndex = psql.indexOf('CREATE TABLE "target_new"');
    var addForegeinKeyIndex = psql.indexOf('ADD CONSTRAINT "source_fk_0"');

    expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
    expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
    expect(createTableSourceIndex, greaterThanOrEqualTo(0));
    expect(createTableTargetIndex, greaterThanOrEqualTo(0));
    expect(addForegeinKeyIndex, greaterThanOrEqualTo(0));

    expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
    expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
    expect(createTableSourceIndex, lessThan(createTableTargetIndex));
    expect(createTableTargetIndex, lessThan(addForegeinKeyIndex));
  });

  test(
      'Given two tables that reference each other, when one is renamed, then the migration code should drop both tables and recreate them in a working order',
      () {
    DatabaseDefinition sourceDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
    }

    // renames table `target` to `target_new`
    DatabaseDefinition targetDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a_new
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
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

    var dropTableSourceIndex = psql.indexOf('DROP TABLE "b"');
    var dropTableTargetIndex = psql.indexOf('DROP TABLE "a"');
    var createTableTargetIndex = psql.indexOf('CREATE TABLE "a_new"');
    var createTableSourceIndex = psql.indexOf('CREATE TABLE "b"');
    var addForegeinKeyAIndex = psql.indexOf('ADD CONSTRAINT "a_new_fk_0"');
    var addForegeinKeyBIndex = psql.indexOf('ADD CONSTRAINT "b_fk_0"');

    expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
    expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
    expect(createTableSourceIndex, greaterThanOrEqualTo(0));
    expect(createTableTargetIndex, greaterThanOrEqualTo(0));
    expect(addForegeinKeyAIndex, greaterThanOrEqualTo(0));
    expect(addForegeinKeyBIndex, greaterThanOrEqualTo(0));

    expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
    expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
    expect(createTableTargetIndex, lessThan(createTableSourceIndex));
    expect(createTableSourceIndex, lessThan(addForegeinKeyAIndex));
    expect(addForegeinKeyAIndex, lessThan(addForegeinKeyBIndex));
  });

  test(
      'Given two tables that reference each other, when one is renamed, then the migration code should not mention an unrelated table',
      () {
    DatabaseDefinition sourceDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('c').withYaml(
          '''
class: C
table: c
fields:
  name: String?
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
    }

    // renames table `target` to `target_new`
    DatabaseDefinition targetDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a_new
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('c').withYaml(
          '''
class: C
table: c
fields:
  name: String?
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

    expect(psql, isNot(contains('"c"'))); // C is unchanged
  });

  test(
      'Given a table that is referenced by another one, when it is renamed while the pointing table is dropping the reference column, then the migration code should only drop and recreate the renamed table and drop just the column on the "pointing" one',
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
  name: String
  target: Target?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
    }

    DatabaseDefinition
        targetDefinition; // renames table `target` to `target_new` and `Source` drops the reference to `Target`
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
  name: String
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

    var dropTableSourceIndex =
        psql.indexOf('DROP TABLE "source"'); // should not be dropped
    var dropTableTargetIndex = psql.indexOf('DROP TABLE "target"');
    var dropSourceConstraint =
        psql.indexOf('ALTER TABLE "source" DROP CONSTRAINT "source_fk_0"');
    var dropSourceColumnPointingTotarget =
        psql.indexOf('ALTER TABLE "source" DROP COLUMN "targetId"');
    var createNewTargetTable = psql.indexOf('CREATE TABLE "target_new"');

    expect(dropTableSourceIndex, -1);
    expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
    expect(dropSourceConstraint, greaterThanOrEqualTo(0));
    expect(dropSourceColumnPointingTotarget, greaterThanOrEqualTo(0));
    expect(createNewTargetTable, greaterThanOrEqualTo(0));

    expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
    expect(dropTableTargetIndex, lessThan(dropSourceConstraint));
    expect(dropSourceConstraint, lessThan(dropSourceColumnPointingTotarget));
    expect(dropSourceColumnPointingTotarget, lessThan(createNewTargetTable));
  });
}
