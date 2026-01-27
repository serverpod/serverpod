import 'dart:convert';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a TableMigration JSON without renameColumns field', () {
    const jsonWithoutRenameColumns = '''
    {
      "__className__": "serverpod.TableMigration",
      "name": "example_table",
      "schema": "public",
      "addColumns": [],
      "deleteColumns": [],
      "modifyColumns": [],
      "addIndexes": [],
      "deleteIndexes": [],
      "addForeignKeys": [],
      "deleteForeignKeys": [],
      "warnings": []
    }
    ''';

    test('when deserializing then it should succeed without errors.', () {
      var decoded = jsonDecode(jsonWithoutRenameColumns) as Map<String, dynamic>;
      
      expect(
        () => TableMigration.fromJson(decoded),
        returnsNormally,
      );
    });

    test('when deserializing then renameColumns should be null.', () {
      var decoded = jsonDecode(jsonWithoutRenameColumns) as Map<String, dynamic>;
      var tableMigration = TableMigration.fromJson(decoded);
      
      expect(tableMigration.renameColumns, isNull);
    });

    test('when deserializing then all other fields should be populated correctly.', () {
      var decoded = jsonDecode(jsonWithoutRenameColumns) as Map<String, dynamic>;
      var tableMigration = TableMigration.fromJson(decoded);
      
      expect(tableMigration.name, 'example_table');
      expect(tableMigration.schema, 'public');
      expect(tableMigration.addColumns, isEmpty);
      expect(tableMigration.deleteColumns, isEmpty);
      expect(tableMigration.modifyColumns, isEmpty);
      expect(tableMigration.addIndexes, isEmpty);
      expect(tableMigration.deleteIndexes, isEmpty);
      expect(tableMigration.addForeignKeys, isEmpty);
      expect(tableMigration.deleteForeignKeys, isEmpty);
      expect(tableMigration.warnings, isEmpty);
    });
  });

  group('Given a TableMigration JSON with renameColumns field', () {
    const jsonWithRenameColumns = '''
    {
      "__className__": "serverpod.TableMigration",
      "name": "example_table",
      "schema": "public",
      "addColumns": [],
      "deleteColumns": [],
      "modifyColumns": [],
      "renameColumns": {
        "old_name": "new_name",
        "another_old": "another_new"
      },
      "addIndexes": [],
      "deleteIndexes": [],
      "addForeignKeys": [],
      "deleteForeignKeys": [],
      "warnings": []
    }
    ''';

    test('when deserializing then it should succeed without errors.', () {
      var decoded = jsonDecode(jsonWithRenameColumns) as Map<String, dynamic>;
      
      expect(
        () => TableMigration.fromJson(decoded),
        returnsNormally,
      );
    });

    test('when deserializing then renameColumns should be populated.', () {
      var decoded = jsonDecode(jsonWithRenameColumns) as Map<String, dynamic>;
      var tableMigration = TableMigration.fromJson(decoded);
      
      expect(tableMigration.renameColumns, isNotNull);
      expect(tableMigration.renameColumns, hasLength(2));
      expect(tableMigration.renameColumns!['old_name'], 'new_name');
      expect(tableMigration.renameColumns!['another_old'], 'another_new');
    });
  });

  group('Given a DatabaseMigration JSON with an alterTable action without renameColumns', () {
    const jsonWithAlterTable = '''
    {
      "__className__": "serverpod.DatabaseMigration",
      "actions": [
        {
          "__className__": "serverpod.DatabaseMigrationAction",
          "type": "alterTable",
          "alterTable": {
            "__className__": "serverpod.TableMigration",
            "name": "test_table",
            "schema": "public",
            "addColumns": [],
            "deleteColumns": ["removed_column"],
            "modifyColumns": [],
            "addIndexes": [],
            "deleteIndexes": [],
            "addForeignKeys": [],
            "deleteForeignKeys": [],
            "warnings": []
          }
        }
      ],
      "warnings": [],
      "migrationApiVersion": 1
    }
    ''';

    test('when deserializing then the migration should succeed.', () {
      var decoded = jsonDecode(jsonWithAlterTable) as Map<String, dynamic>;
      
      expect(
        () => DatabaseMigration.fromJson(decoded),
        returnsNormally,
      );
    });

    test('when deserializing then alterTable should have null renameColumns.', () {
      var decoded = jsonDecode(jsonWithAlterTable) as Map<String, dynamic>;
      var migration = DatabaseMigration.fromJson(decoded);
      
      expect(migration.actions, hasLength(1));
      var action = migration.actions.first;
      expect(action.type, DatabaseMigrationActionType.alterTable);
      expect(action.alterTable, isNotNull);
      expect(action.alterTable!.renameColumns, isNull);
    });
  });
}
