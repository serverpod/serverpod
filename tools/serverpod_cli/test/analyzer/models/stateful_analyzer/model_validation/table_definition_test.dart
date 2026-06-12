import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  const moduleName = 'example';

  List<SerializableModelDefinition> validateAndGetDefinitions(
    List<ModelSource> models,
    CodeGenerationCollector collector,
  ) {
    return StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();
  }

  TableDefinition getTableFromModels(
    List<ModelSource> models,
    CodeGenerationCollector collector,
  ) {
    var definitions = validateAndGetDefinitions(models, collector);
    var dbDef = createDatabaseDefinitionFromModels(
      definitions,
      moduleName,
      config.modules,
    );
    return dbDef.tables.first;
  }

  test(
    'Given a model with int serial default '
    'when parsing the TableDefinition '
    'then the columnDefault is "serial" and the id column is primary.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            id: int?, defaultPersist=serial
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var idColumn = table.columns.first;

      expect(idColumn.columnDefault, defaultIntSerial);
      expect(idColumn.isPrimary, isTrue);
    },
  );

  test(
    'Given a model with an int literal default '
    'when parsing the TableDefinition '
    'then the int default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            intDefault: int?, defaultPersist=1
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var intColumn = table.findColumnNamed('intDefault');

      expect(intColumn, isNotNull);
      expect(intColumn!.columnDefault, '1');
    },
  );

  test(
    'Given a model with a boolean default '
    'when parsing the TableDefinition '
    'then the boolean default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            flag: bool?, defaultPersist=true
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var boolColumn = table.findColumnNamed('flag');

      expect(boolColumn, isNotNull);
      expect(boolColumn!.columnDefault, 'true');
    },
  );

  test(
    'Given a model with a DateTime "now" default '
    'when parsing the TableDefinition '
    'then the default is kept as "now".',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            createdAt: DateTime?, defaultPersist=now
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var dateColumn = table.findColumnNamed('createdAt');

      expect(dateColumn, isNotNull);
      expect(dateColumn!.columnDefault, defaultDateTimeValueNow);
    },
  );

  test(
    'Given a model with a formatted DateTime default '
    'when parsing the TableDefinition '
    'then the formatted DateTime default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            at: DateTime?, defaultPersist=2024-05-01T22:00:00.000Z
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var dateColumn = table.findColumnNamed('at');

      expect(dateColumn, isNotNull);
      expect(dateColumn!.columnDefault, '2024-05-01T22:00:00.000Z');
    },
  );

  test(
    'Given a model with a Duration default '
    'when parsing the TableDefinition '
    'then the Duration default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            duration: Duration?, defaultPersist=1d 2h 10min 30s 100ms
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var durationColumn = table.findColumnNamed('duration');

      expect(durationColumn, isNotNull);
      expect(durationColumn!.columnDefault, '94230100');
    },
  );

  test(
    'Given a model with an enum default serialized by index '
    'when parsing the TableDefinition '
    'then the enum default is converted to the index of the default entry.',
    () {
      var models = [
        ModelSourceBuilder()
            .withYaml('''
          enum: ByIndexEnum
          serialized: byIndex
          values:
            - byIndex1
            - byIndex2
        ''')
            .withFileName('by_index_enum')
            .build(),
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            enumDefault: ByIndexEnum?, defaultPersist=byIndex2
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var enumColumn = table.findColumnNamed('enumDefault');

      expect(enumColumn, isNotNull);
      expect(enumColumn!.columnDefault, '1');
    },
  );

  test(
    'Given a model with an enum default serialized by name '
    'when parsing the TableDefinition '
    'then the enum default is converted to the quoted string value of the default entry.',
    () {
      var models = [
        ModelSourceBuilder()
            .withYaml('''
          enum: ByNameEnum
          serialized: byName
          values:
            - byName1
            - byName2
        ''')
            .withFileName('by_name_enum')
            .build(),
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            enumDefault: ByNameEnum?, defaultPersist=byName2
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var enumColumn = table.findColumnNamed('enumDefault');

      expect(enumColumn, isNotNull);
      expect(enumColumn!.columnDefault, "'byName2'");
    },
  );

  test(
    'Given a model with a String column with a literal default '
    'when parsing the TableDefinition '
    'then the literal default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            name: String?, defaultPersist='test'
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var stringColumn = table.findColumnNamed('name');

      expect(stringColumn, isNotNull);
      expect(stringColumn!.columnDefault, "'test'");
    },
  );

  test(
    'Given a model with a "random" default '
    'when parsing the TableDefinition '
    'then the default is kept as "random".',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            id: UuidValue?, defaultPersist=random
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var idColumn = table.columns.first;

      expect(idColumn.columnDefault, defaultUuidValueRandom);
      expect(idColumn.isPrimary, isTrue);
    },
  );

  test(
    'Given a model with a "random_v7" default '
    'when parsing the TableDefinition '
    'then the default is kept as "random_v7".',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            id: UuidValue?, defaultPersist=random_v7
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var idColumn = table.columns.first;

      expect(idColumn.columnDefault, defaultUuidValueRandomV7);
      expect(idColumn.isPrimary, isTrue);
    },
  );

  test(
    'Given a model with a UuidValue literal default '
    'when parsing the TableDefinition '
    'then the UuidValue default is kept as the original model value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            uuid: UuidValue?, defaultPersist='550e8400-e29b-41d4-a716-446655440000'
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      expect(collector.errors, isEmpty);
      var uuidColumn = table.findColumnNamed('uuid');

      expect(uuidColumn, isNotNull);
      expect(
        uuidColumn!.columnDefault,
        "'550e8400-e29b-41d4-a716-446655440000'",
      );
    },
  );

  test(
    'Given a model with indexes '
    'when parsing the TableDefinition '
    'then the primary key index is not included in the indexes list.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          fields:
            name: String?
          indexes:
            example_name_idx:
              fields: name
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var table = getTableFromModels(models, collector);

      final pkeyIndexes = table.indexes.any(
        (i) => i.isPrimary && i.indexName.endsWith('_pkey'),
      );

      expect(collector.errors, isEmpty);
      expect(table.indexes, isNotEmpty);
      expect(pkeyIndexes, isFalse);
    },
  );

  test(
    'Given a client database table '
    'when parsing the server TableDefinition '
    'then no table is generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          database: client
          fields:
            name: String
        ''').build(),
      ];
      var collector = CodeGenerationCollector();
      var definitions = validateAndGetDefinitions(models, collector);
      var dbDef = createDatabaseDefinitionFromModels(
        definitions,
        moduleName,
        config.modules,
      );

      expect(collector.errors, isEmpty);
      expect(dbDef.tables, isEmpty);
    },
  );
}
