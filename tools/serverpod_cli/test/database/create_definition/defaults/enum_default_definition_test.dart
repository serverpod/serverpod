import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/enum_definition_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';

void main() {
  var byNameEnumDefinition = EnumDefinitionBuilder()
      .withClassName('ByNameEnum')
      .withFileName('by_name_enum')
      .withSerialized(EnumSerialization.byName)
      .withValues([
        ProtocolEnumValueDefinition('byName1'),
        ProtocolEnumValueDefinition('byName2'),
      ])
      .build();

  var byIndexEnumDefinition = EnumDefinitionBuilder()
      .withClassName('ByIndexEnum')
      .withFileName('by_index_enum')
      .withSerialized(EnumSerialization.byIndex)
      .withValues([
        ProtocolEnumValueDefinition('byIndex1'),
        ProtocolEnumValueDefinition('byIndex2'),
      ])
      .build();

  group('Given a class definition with an enum field', () {
    group('when the enum is serialized by name', () {
      group('and no "defaultPersist" is set', () {
        var field = FieldDefinitionBuilder()
            .withName('enumDefault')
            .withEnumDefinition(byNameEnumDefinition, true)
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

        test('then the table should contain a single entry', () {
          expect(
            databaseDefinition.tables,
            hasLength(1),
          );
        });

        test('then the table should be named correctly', () {
          var table = databaseDefinition.tables.first;
          expect(
            table.name,
            'example',
          );
        });

        test(
          'then the table should contain two columns: id and enumDefault',
          () {
            var table = databaseDefinition.tables.first;
            expect(
              table.columns,
              hasLength(2),
            );
          },
        );

        test('then the enumDefault column should not have a default value', () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.columnDefault,
            isNull,
          );
        });
      });

      group('and a "defaultPersist" value is set', () {
        var field = FieldDefinitionBuilder()
            .withName('enumDefault')
            .withEnumDefinition(byNameEnumDefinition, true)
            .withDefaults(defaultPersistValue: 'byName2')
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

        test('then the table should contain a single entry', () {
          expect(
            databaseDefinition.tables,
            hasLength(1),
          );
        });

        test('then the table should be named correctly', () {
          var table = databaseDefinition.tables.first;
          expect(
            table.name,
            'example',
          );
        });

        test(
          'then the table should contain two columns: id and enumDefault',
          () {
            var table = databaseDefinition.tables.first;
            expect(
              table.columns,
              hasLength(2),
            );
          },
        );

        test(
          'then the enumDefault column should store the enum name as the default value',
          () {
            var table = databaseDefinition.tables.first;
            var column = table.columns.last;
            expect(
              column.columnDefault,
              "'byName2'::text",
            );
          },
        );

        test('then the enumDefault column should be nullable', () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.isNullable,
            isTrue,
          );
        });
      });

      group('and "defaultModelValue" is set', () {
        var field = FieldDefinitionBuilder()
            .withName('enumDefault')
            .withEnumDefinition(byNameEnumDefinition, true)
            .withDefaults(defaultModelValue: 'byName1')
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

        test('then the table should contain a single entry', () {
          expect(
            databaseDefinition.tables,
            hasLength(1),
          );
        });

        test('then the table should be named correctly', () {
          var table = databaseDefinition.tables.first;
          expect(
            table.name,
            'example',
          );
        });

        test(
          'then the table should contain two columns: id and enumDefault',
          () {
            var table = databaseDefinition.tables.first;
            expect(
              table.columns,
              hasLength(2),
            );
          },
        );

        test(
          'then the enumDefault column should not have a default value persisted in the database',
          () {
            var table = databaseDefinition.tables.first;
            var column = table.columns.last;
            expect(
              column.columnDefault,
              isNull,
            );
          },
        );

        test('then the enumDefault column should be nullable', () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.isNullable,
            isTrue,
          );
        });
      });
    });

    group('when the enum is serialized by index', () {
      group('and a "defaultPersist" value is set', () {
        var field = FieldDefinitionBuilder()
            .withName('enumDefault')
            .withEnumDefinition(byIndexEnumDefinition, true)
            .withDefaults(defaultPersistValue: 'byIndex2')
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

        test('then the table should contain a single entry', () {
          expect(
            databaseDefinition.tables,
            hasLength(1),
          );
        });

        test('then the table should be named correctly', () {
          var table = databaseDefinition.tables.first;
          expect(
            table.name,
            'example',
          );
        });

        test(
          'then the table should contain two columns: id and enumDefault',
          () {
            var table = databaseDefinition.tables.first;
            expect(
              table.columns,
              hasLength(2),
            );
          },
        );

        test(
          'then the enumDefault column should store the index of the enum value as the default',
          () {
            var table = databaseDefinition.tables.first;
            var column = table.columns.last;
            expect(
              column.columnDefault,
              '1',
            );
          },
        );

        test('then the enumDefault column should be nullable', () {
          var table = databaseDefinition.tables.first;
          var column = table.columns.last;
          expect(
            column.isNullable,
            isTrue,
          );
        });
      });
    });
  });
}
