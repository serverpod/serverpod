import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'extensions.dart';

DatabaseMigration generateDatabaseMigration({
  required DatabaseDefinition databaseSource,
  required DatabaseDefinition databaseTarget,
}) {
  var warnings = <DatabaseMigrationWarning>[];
  var actions = <DatabaseMigrationAction>[];

  // Find deleted tables
  var deleteTables = <String>[];
  var sourceTables = databaseSource.tables
      .where((table) => table.isManaged)
      .where((table) => table.name != 'serverpod_migrations');
  var targetTables = databaseTarget.tables
      .where((table) => table.isManaged)
      .where((table) => table.name != 'serverpod_migrations');

  for (var srcTable in sourceTables) {
    if (!databaseTarget.containsTableNamed(srcTable.name)) {
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
    warnings.add(
      DatabaseMigrationWarning(
        type: DatabaseMigrationWarningType.tableDropped,
        message: 'Table "$tableName" will be dropped.',
        table: tableName,
        destrucive: true,
        columns: [],
      ),
    );
  }

  // Find added or modified tables
  for (var dstTable in targetTables) {
    var srcTable = databaseSource.tables.cast<TableDefinition?>().firstWhere(
        (table) => table?.name == dstTable.name,
        orElse: () => null);

    if (srcTable == null || srcTable.managed == false) {
      // Added table

      actions.add(
        DatabaseMigrationAction(
          type: srcTable == null
              ? DatabaseMigrationActionType.createTable
              : DatabaseMigrationActionType.createTableIfNotExists,
          createTable: dstTable,
        ),
      );
    } else {
      // Table exists in src and dst
      var diff = generateTableMigration(srcTable, dstTable, warnings);
      if (diff == null) {
        // Table was modified, but cannot be migrated. Recreate the table.
        actions.add(
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.deleteTable,
            deleteTable: dstTable.name,
          ),
        );
        actions.add(
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.createTable,
            createTable: dstTable,
          ),
        );
      } else if (!diff.isEmpty) {
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
    warnings: warnings,
    migrationApiVersion: DatabaseConstants.migrationApiVersion,
  );
}

TableMigration? generateTableMigration(
  TableDefinition srcTable,
  TableDefinition dstTable,
  List<DatabaseMigrationWarning> warnings,
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
      warnings.add(
        DatabaseMigrationWarning(
          type: DatabaseMigrationWarningType.columnDropped,
          table: srcTable.name,
          columns: [srcColumn.name],
          message: 'Column "${srcColumn.name}" of table "${srcTable.name}" '
              'will be dropped.',
          destrucive: true,
        ),
      );
    }
  }

  var modifyColumns = <ColumnMigration>[];

  // Find modified columns
  for (var srcColumn in srcTable.columns) {
    var dstColumn = dstTable.findColumnNamed(srcColumn.name);
    if (dstColumn == null) {
      continue;
    }
    if (!srcColumn.like(dstColumn)) {
      if (srcColumn.canMigrateTo(dstColumn)) {
        // Column can be modified
        var addNullable = !srcColumn.isNullable && dstColumn.isNullable;
        var removeNullable = srcColumn.isNullable && !dstColumn.isNullable;
        var changeDefault = srcColumn.columnDefault != dstColumn.columnDefault;

        modifyColumns.add(
          ColumnMigration(
            columnName: srcColumn.name,
            addNullable: addNullable,
            removeNullable: removeNullable,
            changeDefault: changeDefault,
            newDefault: dstColumn.columnDefault,
          ),
        );

        if (removeNullable) {
          warnings.add(
            DatabaseMigrationWarning(
              type: DatabaseMigrationWarningType.notNullAdded,
              table: srcTable.name,
              columns: [srcColumn.name],
              message: 'Column ${srcColumn.name} of table ${srcTable.name} is '
                  'modified to be not null. If there are existing rows with '
                  'null values, this migration will fail.',
              destrucive: false,
            ),
          );
        }
      } else {
        // Column must be deleted and recreated
        deleteColumns.add(srcColumn.name);
        addColumns.add(dstColumn);
        warnings.add(
          DatabaseMigrationWarning(
            type: DatabaseMigrationWarningType.columnDropped,
            table: srcTable.name,
            columns: [srcColumn.name],
            message: 'Column ${srcColumn.name} of table ${srcTable.name} is '
                'modified in a way that it must be deleted and recreated.',
            destrucive: true,
          ),
        );
      }
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

  for (var index in addIndexes) {
    if (index.isUnique) {
      warnings.add(
        DatabaseMigrationWarning(
          type: DatabaseMigrationWarningType.uniqueIndexCreated,
          table: srcTable.name,
          columns: index.elements.map((e) => e.definition).toList(),
          message: 'Unique index "${index.indexName}" is added to table '
              '"${srcTable.name}". If there are existing rows with duplicate '
              'values, this migration will fail.',
          destrucive: false,
        ),
      );
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

  // Check that all added columns can be created in a modfication of the table
  for (var column in addColumns) {
    if (!column.canBeCreatedInTableMigration) {
      warnings.add(
        DatabaseMigrationWarning(
          type: DatabaseMigrationWarningType.tableDropped,
          table: srcTable.name,
          columns: [column.name],
          message:
              'One or more columns are added to table "${srcTable.name}" which '
              'cannot be added in a table migration. The complete table will '
              'be deleted and recreated.',
          destrucive: true,
        ),
      );
      return null;
    }
  }

  return TableMigration(
    name: srcTable.name,
    schema: srcTable.schema,
    deleteColumns: deleteColumns,
    addColumns: addColumns,
    modifyColumns: modifyColumns,
    deleteIndexes: deleteIndexes,
    addIndexes: addIndexes,
    deleteForeignKeys: deleteForeignKeys,
    addForeignKeys: addForeignKeys,
    warnings: warnings,
  );
}
