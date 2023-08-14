import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/foreign_relation_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class definition with a table, then generate a table with that name.',
      () {
    var field = FieldDefinitionBuilder().withPrimaryKey().build();
    var entity = ClassDefinitionBuilder()
        .withTableName('example')
        .withField(field)
        .build();

    var databaseDefinition = createDatabaseDefinitionFromEntities([entity]);

    expect(databaseDefinition.tables, hasLength(1));
    expect(databaseDefinition.tables.first.name, 'example');
  });
  group(
      'Given a class definition with a foreign relation with onDelete and onUpdate set to "SetNull"',
      () {
    var relation = ForeignRelationDefinitionBuilder()
        .withParentTable('example')
        .withReferenceFieldName('id')
        .withOnDelete(ForeignKeyAction.setNull)
        .withOnUpdate(ForeignKeyAction.setNull)
        .build();

    var field = FieldDefinitionBuilder()
        .withName('parentId')
        .withIdType(true)
        .withRelation(relation)
        .build();

    var entity = ClassDefinitionBuilder()
        .withTableName('example')
        .withField(field)
        .build();

    var databaseDefinition = createDatabaseDefinitionFromEntities([entity]);

    var tablesDoNotExist = databaseDefinition.tables.isEmpty;
    test('then a foreign relation exists.', () {
      var table = databaseDefinition.tables.first;
      expect(
        table.foreignKeys,
        isNotEmpty,
        reason: 'Expected a foreign relation to exists.',
      );
    }, skip: tablesDoNotExist);

    group(' ', () {
      var table = databaseDefinition.tables.first;

      var foreignKeyDoNotExist =
          databaseDefinition.tables.first.foreignKeys.isEmpty;

      test('then the foreign key references is a self reference.', () {
        var foreignKey = table.foreignKeys.first;

        var referenceDatabase = foreignKey.referenceTable;
        expect(referenceDatabase, 'example');

        var referenceColumn = foreignKey.referenceColumns.first;
        expect(referenceColumn, 'id');
      }, skip: foreignKeyDoNotExist);

      test(
          'then generate a database definition with onDelete set on the foreign key.',
          () {
        var foreignKey = table.foreignKeys.first;

        expect(foreignKey.onDelete, ForeignKeyAction.setNull);
      }, skip: foreignKeyDoNotExist);

      test(
          'then generate a database definition with onUpdate set on the foreign key.',
          () {
        var foreignKey = table.foreignKeys.first;
        expect(foreignKey.onUpdate, ForeignKeyAction.setNull);
      }, skip: foreignKeyDoNotExist);
    }, skip: tablesDoNotExist);

    group('when generating sql code', () {
      // TODO: fix this, not sure what this does or why it is not set in the
      // definition creator ?! But code generator crashes without it.
      databaseDefinition.priority = 1;

      var sql = databaseDefinition.toPgSql(
        version: 'version',
        module: 'mock',
      );

      test('then on delete is set.', () {
        expect(sql.contains('ON DELETE SET NULL;'), isTrue);
      });

      test('then on update is set.', () {
        expect(sql.contains('ON UPDATE SET NULL;'), isTrue);
      });
    });
  });
}
