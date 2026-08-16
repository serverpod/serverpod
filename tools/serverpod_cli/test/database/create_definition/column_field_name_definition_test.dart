import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../test_util/builders/foreign_relation_definition_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';
import '../../test_util/builders/serializable_entity_field_definition_builder.dart';

void main() {
  group(
    'Given a persisted model field whose database column names matches its Dart field names, '
    'when creating a database definition, ',
    () {
      const tableName = 'example';
      var model = ModelClassDefinitionBuilder()
          .withTableName(tableName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(ModelFieldScopeDefinition.all)
                .withShouldPersist(true)
                .build(),
          )
          .build();

      test('then the id column maps `name` and `fieldName` to "id".', () {
        var databaseDefinition = createDatabaseDefinitionFromModels(
          [model],
          tableName,
          [],
        );
        var table = databaseDefinition.findTableNamed(tableName)!;
        var idColumn = table.findColumnNamed('id')!;
        expect(idColumn.name, 'id');
        expect(idColumn.fieldName, 'id');
      });

      test(
        'then the regular column use the field name for both `name` and `fieldName`.',
        () {
          var databaseDefinition = createDatabaseDefinitionFromModels(
            [model],
            tableName,
            [],
          );
          var table = databaseDefinition.findTableNamed(tableName)!;
          var titleColumn = table.findColumnNamed('title')!;
          expect(titleColumn.name, 'title');
          expect(titleColumn.fieldName, 'title');
        },
      );
    },
  );

  group(
    'Given a persisted model field with an explicit database column name override, '
    'when creating a database definition, ',
    () {
      const dartFieldName = 'userName';
      const dbColumnName = 'user_name';
      const tableName = 'example';

      var model = ModelClassDefinitionBuilder()
          .withTableName(tableName)
          .withField(
            FieldDefinitionBuilder()
                .withName(dartFieldName)
                .withColumnNameOverride(dbColumnName)
                .withTypeDefinition('String', true)
                .withScope(ModelFieldScopeDefinition.all)
                .withShouldPersist(true)
                .build(),
          )
          .build();

      test(
        'then the overridden column uses the database name in `name` and the model field name in `fieldName`.',
        () {
          var databaseDefinition = createDatabaseDefinitionFromModels(
            [model],
            tableName,
            [],
          );
          var table = databaseDefinition.findTableNamed(tableName)!;
          var column = table.findColumnNamed(dbColumnName)!;
          expect(column.name, dbColumnName);
          expect(column.fieldName, dartFieldName);
        },
      );
    },
  );

  group(
    'Given a foreign key field with an explicit database column name override, '
    'when creating a database definition, ',
    () {
      const parentTable = 'example_parent';
      const childTable = 'example_child';
      const dartFieldName = 'parentId';
      const dbColumnName = 'parent_id';

      var relation = ForeignRelationDefinitionBuilder()
          .withParentTable(parentTable)
          .withReferenceFieldName('id')
          .build();

      var childModel = ModelClassDefinitionBuilder()
          .withTableName(childTable)
          .withField(
            FieldDefinitionBuilder()
                .withName(dartFieldName)
                .withColumnNameOverride(dbColumnName)
                .withIdType(isNullable: true)
                .withRelation(relation)
                .build(),
          )
          .build();

      test(
        'then the foreign key column uses the database name in `name` and the model field name in `fieldName`.',
        () {
          var databaseDefinition = createDatabaseDefinitionFromModels(
            [childModel],
            childTable,
            [],
          );
          var table = databaseDefinition.findTableNamed(childTable)!;
          var column = table.findColumnNamed(dbColumnName)!;
          expect(column.name, dbColumnName);
          expect(column.fieldName, dartFieldName);
        },
      );
    },
  );
}
