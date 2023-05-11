import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'extensions.dart';

DatabaseMigration generateDatabaseMigration(
  DatabaseDefinition srcDatabase,
  DatabaseDefinition dstDatabase,
) {
  var actions = <DatabaseMigrationAction>[];

  // Find deleted tables
  var deleteTables = <String>[];
  for (var srcTable in srcDatabase.tables) {
    if (!dstDatabase.containsTableNamed(srcTable.name)) {
      deleteTables.add(srcTable.name);
    }
  }
  for (var tableName in deleteTables.reversed) {
    actions.add(
      DatabaseMigrationAction(
        type: DatabaseMigrationActionType.deleteTable,
        deleteTable: tableName,
      ),
    );
  }

  // Find added or modified tables
  for (var dstTable in dstDatabase.tables) {
    var srcTable = srcDatabase.findTableNamed(dstTable.name);
    if (srcTable == null) {
      // Added table
      actions.add(
        DatabaseMigrationAction(
          type: DatabaseMigrationActionType.createTable,
          createTable: dstTable,
        ),
      );
    } else {
      // Table exists in src and dst
      var diff = generateTableMigration(srcTable, dstTable);
      if (!diff.isEmpty) {
        // Table was modified
        // TODO: Check if table can be modified
        actions.add(
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
            alterTable: diff,
          ),
        );
      }
    }
  }

  return DatabaseMigration(
    actions: actions,
  );
}

TableMigration generateTableMigration(
  TableDefinition srcTable,
  TableDefinition dstTable,
) {
  // Find added columns
  var addColumns = <ColumnDefinition>[];
  for (var dstColumn in dstTable.columns) {
    if (!srcTable.containsColumnNamed(dstColumn.name)) {
      addColumns.add(dstColumn);
    }
  }

  // Find deleted columns
  var deleteColumns = <String>[];
  for (var srcColumn in srcTable.columns) {
    if (!dstTable.containsColumnNamed(srcColumn.name)) {
      deleteColumns.add(srcColumn.name);
    }
  }

  // Find modified columns
  for (var srcColumn in srcTable.columns) {
    var dstColumn = dstTable.findColumnNamed(srcColumn.name);
    if (dstColumn == null) {
      continue;
    }
    if (!srcColumn.like(dstColumn)) {
      deleteColumns.add(srcColumn.name);
      addColumns.add(dstColumn);
    }
  }

  // Find added indexes
  var addIndexes = <IndexDefinition>[];
  for (var dstIndex in dstTable.indexes) {
    if (!srcTable.containsIndexNamed(dstIndex.indexName)) {
      addIndexes.add(dstIndex);
    }
  }

  // Find deleted indexes
  var deleteIndexes = <String>[];
  for (var srcIndex in srcTable.indexes) {
    if (!dstTable.containsIndexNamed(srcIndex.indexName)) {
      deleteIndexes.add(srcIndex.indexName);
    }
  }

  // Find modified indexes
  for (var srcIndex in srcTable.indexes) {
    var dstIndex = dstTable.findIndexNamed(srcIndex.indexName);
    if (dstIndex == null) {
      continue;
    }
    if (!srcIndex.like(dstIndex)) {
      deleteIndexes.add(srcIndex.indexName);
      addIndexes.add(dstIndex);
    }
  }

  // Find added foreign keys
  var addForeignKeys = <ForeignKeyDefinition>[];
  for (var dstKey in dstTable.foreignKeys) {
    if (!srcTable.containsForeignKeyNamed(dstKey.constraintName)) {
      addForeignKeys.add(dstKey);
    }
  }

  // Find deleted foreign keys
  var deleteForeignKeys = <String>[];
  for (var srcKey in srcTable.foreignKeys) {
    if (!dstTable.containsForeignKeyNamed(srcKey.constraintName)) {
      deleteForeignKeys.add(srcKey.constraintName);
    }
  }

  // Find modified foreign keys
  for (var srcKey in srcTable.foreignKeys) {
    var dstKey = dstTable.findForeignKeyDefinitionNamed(srcKey.constraintName);
    if (dstKey == null) {
      continue;
    }
    if (!srcKey.like(dstKey)) {
      deleteForeignKeys.add(srcKey.constraintName);
      addForeignKeys.add(dstKey);
    }
  }

  return TableMigration(
    name: srcTable.name,
    schema: srcTable.schema,
    deleteColumns: deleteColumns,
    addColumns: addColumns,
    deleteIndexes: deleteIndexes,
    addIndexes: addIndexes,
    deleteForeignKeys: deleteForeignKeys,
    addForeignKeys: addForeignKeys,
  );
}
