import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'extensions.dart';

DatabaseMigration generateDatabaseMigration({
  required DatabaseDefinition databaseSource,
  required DatabaseDefinition databaseTarget,
}) {
  var warnings = <DatabaseMigrationWarning>[];
  var actions = <DatabaseMigrationAction>[];

  var sourceTables = databaseSource.tables
      .where((table) => table.isManaged)
      .toList();
  var targetTables = databaseTarget.tables
      .where((table) => table.isManaged)
      .toList();
  var deleteTables = <String>{};

  // Mark tables which do not exist in the target schema anymore for deletion
  for (var srcTable in sourceTables) {
    if (!databaseTarget.containsTableNamed(srcTable.name)) {
      deleteTables.addAll([
        srcTable.name,
        // For any table we delete, we also need to delete any other existing table that has and retains a foreign key pointing into this table
        ..._findDependentTables(
          srcTable.name,
          sourceTables: sourceTables,
          targetTables: targetTables,
        ),
      ]);
    }
  }

  for (var tableName in deleteTables.toList().reversed) {
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
      orElse: () => null,
    );

    if (srcTable == null ||
        srcTable.managed == false ||
        deleteTables.contains(srcTable.name)) {
      // Added table
      actions.add(
        DatabaseMigrationAction(
          type: srcTable == null || deleteTables.contains(srcTable.name)
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
        actions.add(
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
            alterTable: diff.copyWith(
              warnings: warnings
                  .where((warning) => warning.table == dstTable.name)
                  .toList(),
            ),
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

/// Returns the set of table names for all tables which have any relation into the table mentioned by [tableName]
Set<String> _findDependentTables(
  String tableName, {
  required List<TableDefinition> sourceTables,
  required List<TableDefinition> targetTables,
  Set<String>? dependentTables,
}) {
  dependentTables ??= {};

  /// Returns whether the [sourceTable] has a current and future relation to [tableName]
  bool hasCurrentAndFutureRelationToTable(TableDefinition sourceTable) {
    return sourceTable.foreignKeys.any(
      (foreignKey) =>
          foreignKey.referenceTable == tableName &&
          // Check whether the reference will also be upheld in the target table.
          // otherwise the target table will already be modified and does not need to have be fully dropped
          targetTables.any(
            (targetTable) =>
                targetTable.name == sourceTable.name &&
                targetTable.foreignKeys.any(
                  (targetForeignKey) =>
                      targetForeignKey.constraintName ==
                          foreignKey.constraintName &&
                      // Check if it's the same FK (by comparing columns).
                      // This handles two scenarios:
                      // 1. FK still references the deleted table (original case)
                      // 2. FK references a different table but uses same columns (rename case)
                      // If columns are different, it's a different FK reusing the name (renumbering case)
                      _sameColumns(
                        targetForeignKey.columns,
                        foreignKey.columns,
                      ),
                ),
          ),
    );
  }

  for (var sourceTable in sourceTables) {
    if (dependentTables.contains(sourceTable.name)) {
      continue;
    }

    if (hasCurrentAndFutureRelationToTable(sourceTable)) {
      dependentTables.add(sourceTable.name);

      _findDependentTables(
        sourceTable.name,
        sourceTables: sourceTables,
        targetTables: targetTables,
        dependentTables: dependentTables,
      );
    }
  }

  return dependentTables;
}

/// Compares two lists of column names for equality.
bool _sameColumns(List<String> columns1, List<String> columns2) {
  if (columns1.length != columns2.length) return false;
  for (var i = 0; i < columns1.length; i++) {
    if (columns1[i] != columns2[i]) return false;
  }
  return true;
}

/// Detects column renames by matching deleted columns with added columns that
/// have compatible types.
///
/// This function identifies columns that appear to be renamed by comparing
/// deleted columns from the source table with added columns in the target table.
/// A column is considered renamed if:
/// - Same column type (e.g., both are text, integer, etc.)
/// - Same Dart type representation
/// - Same vector dimension (for vector columns)
///
/// When a rename is detected, the columns are removed from the [deleteColumns]
/// and [addColumns] lists and added to the returned rename map.
///
/// Returns a map where keys are old column names and values are new column names.
Map<String, String> _detectColumnRenames({
  required TableDefinition srcTable,
  required List<String> deleteColumns,
  required List<ColumnDefinition> addColumns,
}) {
  var renameColumns = <String, String>{};
  var deleteColumnsCopy = List<String>.from(deleteColumns);
  var addColumnsCopy = List<ColumnDefinition>.from(addColumns);

  for (var deleteColumnName in deleteColumnsCopy) {
    var srcColumn = srcTable.findColumnNamed(deleteColumnName);
    if (srcColumn == null) continue;

    for (var addColumn in addColumnsCopy) {
      if (srcColumn.columnType == addColumn.columnType &&
          srcColumn.dartType == addColumn.dartType &&
          srcColumn.vectorDimension == addColumn.vectorDimension) {
        // Found a matching column - treat as rename
        renameColumns[deleteColumnName] = addColumn.name;
        deleteColumns.remove(deleteColumnName);
        addColumns.remove(addColumn);
        break;
      }
    }
  }

  return renameColumns;
}

/// Processes column modifications for both regular and renamed columns.
///
/// This function examines columns that exist in both source and target tables
/// (including renamed columns) to detect changes in nullability, default values,
/// or column types. For renamed columns, it uses special comparison logic that
/// ignores the column name difference.
///
/// The function populates:
/// - [modifyColumns]: Columns with nullability or default changes
/// - [deleteColumns]: Columns that must be dropped due to incompatible changes
/// - [addColumns]: New column definitions for dropped columns
/// - [warnings]: Warnings about destructive or risky changes
void _processColumnModifications({
  required TableDefinition srcTable,
  required TableDefinition dstTable,
  required Map<String, String> renameColumns,
  required List<ColumnMigration> modifyColumns,
  required List<String> deleteColumns,
  required List<ColumnDefinition> addColumns,
  required List<DatabaseMigrationWarning> warnings,
}) {
  for (var srcColumn in srcTable.columns) {
    var renamedTo = renameColumns[srcColumn.name];
    var dstColumn = renamedTo != null
        ? dstTable.findColumnNamed(renamedTo)
        : dstTable.findColumnNamed(srcColumn.name);

    if (dstColumn == null) {
      continue;
    }

    bool columnsAreDifferent;
    if (renamedTo != null) {
      // For renamed columns, compare properties excluding name
      columnsAreDifferent =
          srcColumn.isNullable != dstColumn.isNullable ||
          srcColumn.columnDefault != dstColumn.columnDefault ||
          srcColumn.columnType != dstColumn.columnType ||
          srcColumn.dartType != dstColumn.dartType ||
          srcColumn.vectorDimension != dstColumn.vectorDimension;
    } else {
      // For non-renamed columns, use standard comparison
      columnsAreDifferent = !srcColumn.like(dstColumn);
    }

    if (columnsAreDifferent) {
      bool canMigrate;
      if (renamedTo != null) {
        // For renamed columns, check type compatibility ignoring name
        canMigrate =
            srcColumn.columnType == dstColumn.columnType &&
            (srcColumn.dartType == null ||
                dstColumn.dartType == null ||
                srcColumn.dartType == dstColumn.dartType) &&
            srcColumn.vectorDimension == dstColumn.vectorDimension;
      } else {
        canMigrate = srcColumn.canMigrateTo(dstColumn);
      }

      if (canMigrate) {
        var addNullable = !srcColumn.isNullable && dstColumn.isNullable;
        var removeNullable = srcColumn.isNullable && !dstColumn.isNullable;
        var changeDefault = srcColumn.columnDefault != dstColumn.columnDefault;

        if (srcColumn.name == defaultPrimaryKeyName &&
            !addNullable &&
            !removeNullable &&
            !changeDefault) {
          continue;
        }

        modifyColumns.add(
          ColumnMigration(
            columnName: renamedTo ?? srcColumn.name,
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
              columns: [dstColumn.name],
              message:
                  'Column "${dstColumn.name}" of table "${srcTable.name}" is '
                  'modified to be not null. If there are existing rows with '
                  'null values, this migration will fail.',
              destrucive: false,
            ),
          );
        }
      } else {
        // Column must be deleted and recreated
        if (renamedTo == null) {
          deleteColumns.add(srcColumn.name);
          addColumns.add(dstColumn);
          warnings.add(
            DatabaseMigrationWarning(
              type: DatabaseMigrationWarningType.columnDropped,
              table: srcTable.name,
              columns: [srcColumn.name],
              message:
                  'Column "${srcColumn.name}" of table "${srcTable.name}" is '
                  'modified in a way that it must be deleted and recreated.',
              destrucive: true,
            ),
          );
        }
      }
    }
  }
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
    }
  }

  // Detect column renames
  var renameColumns = _detectColumnRenames(
    srcTable: srcTable,
    deleteColumns: deleteColumns,
    addColumns: addColumns,
  );

  // Add warnings for columns that will actually be dropped (not renamed)
  for (var deleteColumnName in deleteColumns) {
    warnings.add(
      DatabaseMigrationWarning(
        type: DatabaseMigrationWarningType.columnDropped,
        table: srcTable.name,
        columns: [deleteColumnName],
        message:
            'Column "$deleteColumnName" of table "${srcTable.name}" '
            'will be dropped.',
        destrucive: true,
      ),
    );
  }

  var modifyColumns = <ColumnMigration>[];

  // Process column modifications for both regular and renamed columns
  _processColumnModifications(
    srcTable: srcTable,
    dstTable: dstTable,
    renameColumns: renameColumns,
    modifyColumns: modifyColumns,
    deleteColumns: deleteColumns,
    addColumns: addColumns,
    warnings: warnings,
  );

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
          message:
              'Unique index "${index.indexName}" is added to table '
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

  // Check that all added columns can be created in a modification of the table
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
    renameColumns: renameColumns,
    deleteIndexes: deleteIndexes,
    addIndexes: addIndexes,
    deleteForeignKeys: deleteForeignKeys,
    addForeignKeys: addForeignKeys,
    warnings: warnings,
  );
}
