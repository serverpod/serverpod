import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class definition with a bool field', () {
    test(
        'when "defaultPersist" is set, then the table should have the correct default value.',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', false)
          .withDefaults(defaultPersistValue: 'true')
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        'true',
      );
    });

    test(
        'when no "defaultPersist" is set, then the table should not have a default value.',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', false)
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        isNull,
      );
    });

    test(
        'when the field is nullable and has a "defaultPersist" value, then the table should have the correct default value and be nullable.',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', true)
          .withDefaults(defaultPersistValue: 'true')
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        'true',
      );

      expect(
        column.isNullable,
        isTrue,
      );
    });

    test(
        'when the field is nullable and has no "defaultPersist" value, then the table should be nullable with no default value.',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', true)
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        isNull,
      );

      expect(
        column.isNullable,
        isTrue,
      );
    });

    test(
        'when "defaultModelValue" is set, then the table should not have a default value',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', false)
          .withDefaults(defaultModelValue: 'true')
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        isNull,
      );
    });

    test(
        'when the field is nullable and "defaultModelValue" is set, then the table should be nullable with no default value',
        () {
      var field = FieldDefinitionBuilder()
          .withName('boolDefault')
          .withTypeDefinition('bool', true)
          .withDefaults(defaultModelValue: 'true')
          .build();

      var model = ClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      expect(
        databaseDefinition.tables,
        hasLength(1),
      );

      var table = databaseDefinition.tables.first;

      expect(
        table.name,
        'example',
      );

      expect(
        table.columns,
        hasLength(2),
      );

      var column = table.columns.last;

      expect(
        column.columnDefault,
        isNull,
      );

      expect(
        column.isNullable,
        isTrue,
      );
    });
  });
}
