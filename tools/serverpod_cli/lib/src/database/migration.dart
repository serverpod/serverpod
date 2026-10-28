import 'package:collection/collection.dart';
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

  var moves = _findMovedTables(
    sourceTables: sourceTables,
    targetTables: targetTables,
    databaseSource: databaseSource,
    databaseTarget: databaseTarget,
  );

  // Mark tables which do not exist in the target schema anymore for deletion
  var deleteTables = <String, TableDefinition>{};
  for (var srcTable in sourceTables) {
    if (moves.movedSources.contains(srcTable.qualifiedName)) continue;
    if (!_containsTable(databaseTarget.tables, srcTable)) {
      // For any table we delete, we also need to delete any other existing table that has and retains a foreign key pointing into this table
      var dependents = _findDependentTables(
        srcTable.qualifiedName,
        sourceTables: sourceTables,
        targetTables: targetTables,
      );
      deleteTables[srcTable.qualifiedName] = srcTable;
      for (var dependent in dependents) {
        deleteTables[dependent] = _findTableByQualifiedName(
          sourceTables,
          dependent,
        )!;
      }
    }
  }

  for (var table in deleteTables.values.toList().reversed) {
    var qualifiedName = table.qualifiedName;
    actions.add(
      DatabaseMigrationAction(
        type: DatabaseMigrationActionType.deleteTable,
        deleteTable: table.name,
        deleteTableSchema: _schemaOrNull(table.schema),
      ),
    );
    warnings.add(
      DatabaseMigrationWarning(
        type: DatabaseMigrationWarningType.tableDropped,
        message: moves.ambiguous.contains(qualifiedName)
            ? 'Table "$qualifiedName" will be dropped. Tables named '
                  '"${table.name}" exist in several schemas, so it cannot be '
                  'moved with SET SCHEMA.'
            : 'Table "$qualifiedName" will be dropped.',
        table: qualifiedName,
        destructive: true,
        columns: [],
      ),
    );
  }

  // Find added or modified tables
  for (var dstTable in targetTables) {
    var srcTable =
        moves.movedFrom[dstTable.qualifiedName] ??
        _findTableByQualifiedName(
          databaseSource.tables,
          dstTable.qualifiedName,
        );

    if (srcTable == null ||
        srcTable.managed == false ||
        deleteTables.containsKey(srcTable.qualifiedName)) {
      // Added table
      actions.add(
        DatabaseMigrationAction(
          type:
              srcTable == null ||
                  deleteTables.containsKey(srcTable.qualifiedName)
              ? DatabaseMigrationActionType.createTable
              : DatabaseMigrationActionType.createTableIfNotExists,
          createTable: dstTable,
        ),
      );
    } else {
      // Table exists in src and dst
      var diff = generateTableMigration(
        srcTable,
        dstTable,
        warnings,
        newSchema: moves.movedFrom.containsKey(dstTable.qualifiedName)
            ? dstTable.schema
            : null,
      );
      if (diff == null) {
        // Table was modified, but cannot be migrated. Recreate the table.
        actions.add(
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.deleteTable,
            deleteTable: srcTable.name,
            deleteTableSchema: _schemaOrNull(srcTable.schema),
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
                  .where((warning) => warning.table == srcTable.qualifiedName)
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

/// A table that only changes schema is moved instead of recreated, provided
/// its bare name is absent on the other side of both tables and has exactly
/// one candidate in each direction. Sources with several candidates are
/// [ambiguous]. [movedFrom] is keyed by target qualified name.
({
  Map<String, TableDefinition> movedFrom,
  Set<String> movedSources,
  Set<String> ambiguous,
})
_findMovedTables({
  required List<TableDefinition> sourceTables,
  required List<TableDefinition> targetTables,
  required DatabaseDefinition databaseSource,
  required DatabaseDefinition databaseTarget,
}) {
  var missingInTarget = sourceTables
      .where((table) => !_containsTable(databaseTarget.tables, table))
      .toList();
  var missingInSource = targetTables
      .where((table) => !_containsTable(databaseSource.tables, table))
      .toList();

  var movedFrom = <String, TableDefinition>{};
  var ambiguous = <String>{};
  for (var srcTable in missingInTarget) {
    var candidates = missingInSource.where((t) => t.name == srcTable.name);
    if (candidates.isEmpty) continue;

    var sources = missingInTarget.where((t) => t.name == srcTable.name);
    if (candidates.length == 1 && sources.length == 1) {
      movedFrom[candidates.single.qualifiedName] = srcTable;
    } else {
      ambiguous.add(srcTable.qualifiedName);
    }
  }

  return (
    movedFrom: movedFrom,
    movedSources: {for (var table in movedFrom.values) table.qualifiedName},
    ambiguous: ambiguous,
  );
}

bool _containsTable(Iterable<TableDefinition> tables, TableDefinition table) {
  return _findTableByQualifiedName(tables, table.qualifiedName) != null;
}

TableDefinition? _findTableByQualifiedName(
  Iterable<TableDefinition> tables,
  String qualifiedName,
) {
  return tables.firstWhereOrNull((t) => t.qualifiedName == qualifiedName);
}

/// The schema as stored on delete actions, where null means the default.
String? _schemaOrNull(String schema) => isDefaultSchema(schema) ? null : schema;

/// Returns the set of qualified table names for all tables which have any relation into the table mentioned by [tableName]
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
          foreignKey.qualifiedReferenceTable == tableName &&
          // Check whether the reference will also be upheld in the target table.
          // otherwise the target table will already be modified and does not need to have be fully dropped
          targetTables.any(
            (targetTable) =>
                targetTable.qualifiedName == sourceTable.qualifiedName &&
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
    if (dependentTables.contains(sourceTable.qualifiedName)) {
      continue;
    }

    if (hasCurrentAndFutureRelationToTable(sourceTable)) {
      dependentTables.add(sourceTable.qualifiedName);

      _findDependentTables(
        sourceTable.qualifiedName,
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

TableMigration? generateTableMigration(
  TableDefinition srcTable,
  TableDefinition dstTable,
  List<DatabaseMigrationWarning> warnings, {
  String? newSchema,
}) {
  var dstByFieldId = <String, ColumnDefinition>{
    for (var c in dstTable.columns) c.effectiveFieldName: c,
  };

  var renameColumns = <String, String>{};
  for (var srcColumn in srcTable.columns) {
    var dstColumn = dstByFieldId[srcColumn.effectiveFieldName];
    if (dstColumn == null) continue;
    if (srcColumn.name == dstColumn.name) continue;
    if (!srcColumn.canMigrateTo(dstColumn)) continue;
    renameColumns[srcColumn.name] = dstColumn.name;
  }

  var renameSources = renameColumns.keys.toSet();
  var renameTargets = renameColumns.values.toSet();

  // Find added columns
  var addColumns = <ColumnDefinition>[];
  for (var dstColumn in dstTable.columns) {
    if (!srcTable.containsColumnNamed(dstColumn.name)) {
      if (renameTargets.contains(dstColumn.name)) continue;
      addColumns.add(dstColumn);
    }
  }

  // Find deleted columns
  var deleteColumns = <String>[];
  for (var srcColumn in srcTable.columns) {
    if (!dstTable.containsColumnNamed(srcColumn.name)) {
      if (renameSources.contains(srcColumn.name)) continue;
      deleteColumns.add(srcColumn.name);
      warnings.add(
        DatabaseMigrationWarning(
          type: DatabaseMigrationWarningType.columnDropped,
          table: srcTable.qualifiedName,
          columns: [srcColumn.name],
          message:
              'Column "${srcColumn.name}" of table "${srcTable.qualifiedName}" '
              'will be dropped.',
          destructive: true,
        ),
      );
    }
  }

  var modifyColumns = <ColumnMigration>[];

  // Find modified columns
  for (var srcColumn in srcTable.columns) {
    var dstColumn = renameColumns.containsKey(srcColumn.name)
        ? dstTable.findColumnNamed(renameColumns[srcColumn.name]!)
        : dstTable.findColumnNamed(srcColumn.name);
    if (dstColumn == null) {
      continue;
    }
    // The column name must be the same for the like comparison.
    if (!srcColumn.like(dstColumn)) {
      if (srcColumn.canMigrateTo(dstColumn)) {
        // Column can be modified
        var addNullable = !srcColumn.isNullable && dstColumn.isNullable;
        var removeNullable = srcColumn.isNullable && !dstColumn.isNullable;
        var changeDefault = srcColumn.columnDefault != dstColumn.columnDefault;
        var newType = srcColumn.columnType != dstColumn.columnType
            ? dstColumn.columnType
            : null;

        // Id column can have its model type changed between non-nullable and
        // nullable, but the database type will remain the same. In this case,
        // we don't want to generate a migration.
        if (srcColumn.name == defaultPrimaryKeyName &&
            !addNullable &&
            !removeNullable &&
            !changeDefault &&
            newType == null) {
          continue;
        }

        modifyColumns.add(
          ColumnMigration(
            columnName: srcColumn.name,
            newColumnName: srcColumn.name != dstColumn.name
                ? dstColumn.name
                : null,
            addNullable: addNullable,
            removeNullable: removeNullable,
            changeDefault: changeDefault,
            newDefault: dstColumn.columnDefault,
            newType: newType,
          ),
        );

        if (removeNullable) {
          warnings.add(
            DatabaseMigrationWarning(
              type: DatabaseMigrationWarningType.notNullAdded,
              table: srcTable.qualifiedName,
              columns: [dstColumn.name],
              message:
                  'Column "${dstColumn.name}" of table "${srcTable.qualifiedName}" is '
                  'modified to be not null. If there are existing rows with '
                  'null values, this migration will fail.',
              destructive: false,
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
            table: srcTable.qualifiedName,
            columns: [srcColumn.name],
            message:
                'Column "${srcColumn.name}" of table "${srcTable.qualifiedName}" is '
                'modified in a way that it must be deleted and recreated.',
            destructive: true,
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
          table: srcTable.qualifiedName,
          columns: index.elements.map((e) => e.definition).toList(),
          message:
              'Unique index "${index.indexName}" is added to table '
              '"${srcTable.qualifiedName}". If there are existing rows with duplicate '
              'values, this migration will fail.',
          destructive: false,
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
          table: srcTable.qualifiedName,
          columns: [column.name],
          message:
              'One or more columns are added to table "${srcTable.qualifiedName}" which '
              'cannot be added in a table migration. The complete table will '
              'be deleted and recreated.',
          destructive: true,
        ),
      );
      return null;
    }
  }

  return TableMigration(
    name: srcTable.name,
    schema: srcTable.schema,
    newSchema: newSchema,
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

extension on ColumnDefinition {
  /// The field name will not be set for [ColumnDefinition] generated before
  /// the column rename feature was implemented. For those, the physical column
  /// name match the model field name.
  ///
  /// The only exception are projects that opted-in to use the experimental
  /// `column` override field in the `.spy.yaml` file to explicitly set
  /// the column name. Since the feature is experimental, there is no need
  /// to support this edge case.
  String get effectiveFieldName => fieldName ?? name;
}
