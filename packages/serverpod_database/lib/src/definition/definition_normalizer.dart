import '../../serverpod_database.dart';
import '../adapters/postgres/postgres_default_value.dart';

/// Idempotently normalizes v1 (database-specific) definitions to v2 (abstract).
/// - Converts database-specific SQL defaults to abstract defaults.
/// - Removes PK index from list.
DatabaseDefinition normalizeDefinitionToV2(DatabaseDefinition def) {
  if (def.schemaVersion >= 2) return def;

  return DatabaseDefinition(
    schemaVersion: 2,
    name: def.name,
    moduleName: def.moduleName,
    tables: def.tables.map(_normalizeTable).toList(),
    installedModules: def.installedModules,
    migrationApiVersion: def.migrationApiVersion,
  );
}

/// Idempotently normalizes v1 (database-specific) migrations to v2 (abstract).
DatabaseMigration normalizeMigrationToV2(
  DatabaseMigration migration,
  DatabaseDefinition targetDefinition,
) {
  return DatabaseMigration(
    actions: migration.actions
        .map((action) => _normalizeMigrationAction(action, targetDefinition))
        .toList(),
    warnings: migration.warnings,
    migrationApiVersion: migration.migrationApiVersion,
  );
}

TableDefinition _normalizeTable(TableDefinition table) {
  return TableDefinition(
    name: table.name,
    dartName: table.dartName,
    module: table.module,
    schema: table.schema,
    tableSpace: table.tableSpace,
    columns: table.columns.map(_normalizeColumn).toList(),
    foreignKeys: table.foreignKeys,
    indexes: table.indexes.where((idx) => !idx.isPrimary).toList(),
    managed: table.managed,
  );
}

ColumnDefinition _normalizeColumn(ColumnDefinition col) {
  return col.copyWith(
    columnDefault: pgSqlToAbstractDefault(
      col.columnDefault,
      col.columnType,
    ),
  );
}

DatabaseMigrationAction _normalizeMigrationAction(
  DatabaseMigrationAction action,
  DatabaseDefinition targetDefinition,
) {
  final alterTable = action.alterTable;
  if (alterTable == null ||
      alterTable.modifyColumns.isEmpty ||
      alterTable.modifyColumns.every((col) => !col.changeDefault)) {
    return action;
  }

  return action.copyWith(
    alterTable: alterTable.copyWith(
      modifyColumns: alterTable.modifyColumns.map((col) {
        if (!col.changeDefault) return col;

        final targetColumn = targetDefinition
            .findTableNamed(alterTable.name)!
            .findColumnNamed(col.columnName)!;

        return col.copyWith(
          newDefault: pgSqlToAbstractDefault(
            col.newDefault,
            targetColumn.columnType,
          ),
        );
      }).toList(),
    ),
  );
}
