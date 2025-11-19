import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';

void main() {
  group('Given a class definition with a Duration field', () {
    group('when "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('durationDefault')
          .withTypeDefinition('Duration', false)
          .withDefaults(defaultPersistValue: '1d 2h 10min 30s 100ms')
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

      test(
        'then the last column should have the correct default value in milliseconds',
        () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.columnDefault,
            '94230100', // 1 day, 2 hours, 10 minutes, 30 seconds, 100 milliseconds in total
          );
        },
      );
    });

    group('when no "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('durationDefault')
          .withTypeDefinition('Duration', false)
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
          .withName('durationDefault')
          .withTypeDefinition('Duration', true)
          .withDefaults(defaultPersistValue: '1d 2h 10min 30s 100ms')
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

      test(
        'then the last column should have the correct default value in milliseconds',
        () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.columnDefault,
            '94230100', // 1 day, 2 hours, 10 minutes, 30 seconds, 100 milliseconds in total
          );
        },
      );

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
          .withName('durationDefault')
          .withTypeDefinition('Duration', true)
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
          .withName('durationDefault')
          .withTypeDefinition('Duration', false)
          .withDefaults(defaultModelValue: '1d 2h 10min 30s 100ms')
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
          .withName('durationDefault')
          .withTypeDefinition('Duration', true)
          .withDefaults(defaultModelValue: '1d 2h 10min 30s 100ms')
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
