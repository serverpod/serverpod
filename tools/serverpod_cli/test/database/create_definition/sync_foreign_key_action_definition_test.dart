import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/foreign_relation_definition_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';
import '../../test_util/builders/serializable_entity_field_definition_builder.dart';

void main() {
  ModelClassDefinition buildModel(ModelDatabaseDefinition database) {
    var relation = ForeignRelationDefinitionBuilder()
        .withParentTable('example')
        .withReferenceFieldName('id')
        .withOnDelete(ForeignKeyAction.restrict)
        .withOnUpdate(ForeignKeyAction.restrict)
        .build();

    var field = FieldDefinitionBuilder()
        .withName('parentId')
        .withIdType(isNullable: true)
        .withRelation(relation)
        .build();

    return ModelClassDefinitionBuilder()
        .withTableName('example')
        .withDatabase(database)
        .withField(field)
        .build();
  }

  group(
    'Given a class definition with "database: sync" and a foreign relation with onDelete set to "Restrict", '
    'when generating a database definition,',
    () {
      var databaseDefinition = createDatabaseDefinitionFromModels(
        [buildModel(ModelDatabaseDefinition.sync)],
        'example',
        [],
      );

      var foreignKey = databaseDefinition.tables.first.foreignKeys.first;

      test('then the onDelete action is replaced by "NoAction".', () {
        expect(foreignKey.onDelete, ForeignKeyAction.noAction);
      });

      test('then the onUpdate action is kept as "Restrict".', () {
        expect(foreignKey.onUpdate, ForeignKeyAction.restrict);
      });
    },
  );

  group(
    'Given a class definition with "database: all" and a foreign relation with onDelete set to "Restrict", '
    'when generating a database definition,',
    () {
      var databaseDefinition = createDatabaseDefinitionFromModels(
        [buildModel(ModelDatabaseDefinition.all)],
        'example',
        [],
      );

      var foreignKey = databaseDefinition.tables.first.foreignKeys.first;

      test('then the onDelete action is kept as "Restrict".', () {
        expect(foreignKey.onDelete, ForeignKeyAction.restrict);
      });
    },
  );
}
