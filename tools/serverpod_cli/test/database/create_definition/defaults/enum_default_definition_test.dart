import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/enum_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var enumDefinition = EnumDefinitionBuilder()
      .withClassName('ByNameEnum')
      .withFileName('by_name_enum')
      .withValues([
    ProtocolEnumValueDefinition('byName1'),
    ProtocolEnumValueDefinition('byName2'),
  ]).build();

  group('Given a class definition with an enum field', () {
    group('when "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', false)
          .withEnumDefinition(enumDefinition)
          .withDefaults(defaultPersistValue: 'byName1')
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
          '0',
        );
      });
    });

    group('when no "defaultPersist" is set', () {
      var field = FieldDefinitionBuilder()
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', false)
          .withEnumDefinition(enumDefinition)
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
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', true)
          .withEnumDefinition(enumDefinition)
          .withDefaults(defaultPersistValue: 'byName1')
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
          '0',
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
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', true)
          .withEnumDefinition(enumDefinition)
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
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', false)
          .withEnumDefinition(enumDefinition)
          .withDefaults(defaultModelValue: 'byName1')
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
          .withName('enumDefault')
          .withTypeDefinition('ByNameEnum', true)
          .withEnumDefinition(enumDefinition)
          .withDefaults(defaultModelValue: 'byName1')
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
