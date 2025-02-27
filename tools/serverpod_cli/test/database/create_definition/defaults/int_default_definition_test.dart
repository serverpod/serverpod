import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';

void main() {
  group('Given a class definition with an int field', () {
    group('when "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', false)
          .withDefaults(defaultPersistValue: '10')
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should have the correct default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          '10',
        );
      });
    });

    group('when no "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', false)
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should not have a default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          isNull,
        );
      });
    });

    group('when the field is nullable and has a "defaultPersist" value', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', true)
          .withDefaults(defaultPersistValue: '10')
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should have the correct default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          '10',
        );
      });

      test('then the last column should be nullable', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.isNullable,
          isTrue,
        );
      });
    });

    group('when the field is nullable and has no "defaultPersist" value', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', true)
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should not have a default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          isNull,
        );
      });

      test('then the last column should be nullable', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.isNullable,
          isTrue,
        );
      });
    });

    group('when "defaultModelValue" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', false)
          .withDefaults(defaultModelValue: '10')
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should not have a default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          isNull,
        );
      });
    });

    group('when the field is nullable and "defaultModelValue" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('intDefault')
          .withTypeDefinition('int', true)
          .withDefaults(defaultModelValue: '10')
          .build();

      var model = ModelClassDefinitionBuilder()
          .withTableName('example')
          .withField(field)
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      );

      test('then the table should have one table', () {
        expect(
          databaseDefinition.tables,
          hasLength(1),
        );
      });

      test('then the table should have the correct name', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.name,
          'example',
        );
      });

      test('then the table should have two columns', () {
        var table = databaseDefinition.tables.first;
        expect(
          table.columns,
          hasLength(2),
        );
      });

      test('then the last column should not have a default value', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.columnDefault,
          isNull,
        );
      });

      test('then the last column should be nullable', () {
        var table = databaseDefinition.tables.first;
        var column = table.columns.last;
        expect(
          column.isNullable,
          isTrue,
        );
      });
    });
  });
}
