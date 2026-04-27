import 'package:serverpod_database/serverpod_database.dart';

// This is a temporary internal import since the normalize functions are not
// meant to be exported from the database package. It will be removed once the
// [SqliteSqlGenerator] gets moved to the database package.
// ignore: implementation_imports
import 'package:serverpod_database/src/adapters/sqlite/sqlite_default_value.dart';

import '../sql_generator.dart';

class SqliteSqlGenerator implements SqlGenerator {
  @override
  String generateDatabaseDefinitionSql(
    DatabaseDefinition databaseDefinition, {
    required List<DatabaseMigrationVersionModel> installedModules,
  }) {
    return databaseDefinition.toSqliteSql(
      installedModules: installedModules,
    );
  }

  @override
  String generateDatabaseMigrationSql(
    DatabaseMigration databaseMigration,
    DatabaseDefinition databaseDefinition, {
    required List<DatabaseMigrationVersionModel> installedModules,
    required List<DatabaseMigrationVersionModel> removedModules,
  }) {
    return databaseMigration.toSqliteSql(
      databaseDefinition: databaseDefinition,
      installedModules: installedModules,
      removedModules: removedModules,
    );
  }
}

const _sqliteSchemaTable = 'serverpod_sqlite_schema';

//
// SQL generation for SQLite
//
extension SqliteDatabaseDefinitionSqlGeneration on DatabaseDefinition {
  String toSqliteSql({
    required List<DatabaseMigrationVersionModel> installedModules,
  }) {
    String out = '';

    out += 'BEGIN;\n';
    out += '\n';

    for (var table in tables.where((table) => table.managed != false)) {
      out += '--\n';
      out += '-- Class ${table.dartName} as table ${table.name}\n';
      out += '--\n';
      out += table.tableCreationToSql();
      out += '\n';
    }

    out += _sqlStoreColumnTypesForMigrations(
      tables,
      installedModules.first,
    );

    if (installedModules.isNotEmpty) {
      out += '\n';
    }

    for (var module in installedModules) {
      out += _sqlStoreMigrationVersion(
        module: module.module,
        version: module.version,
      );
    }

    out += '\n';
    out += 'COMMIT;\n';

    return out;
  }
}

extension SqliteTableDefinitionSqlGeneration on TableDefinition {
  String tableCreationToSql({
    bool ifNotExists = false,
    String? tableNameOverride,
    bool skipIndexes = false,
  }) {
    final tableName = tableNameOverride ?? name;

    String out = '';

    // Table
    if (ifNotExists) {
      out += 'CREATE TABLE IF NOT EXISTS "$tableName" (\n';
    } else {
      out += 'CREATE TABLE "$tableName" (\n';
    }

    var definitions = <String>[];

    for (var column in columns) {
      definitions.add('    ${column.toSqlFragment()}');
    }

    // Inline Foreign Keys
    // In SQLite, we must define these inside the CREATE TABLE block.
    for (var key in foreignKeys) {
      definitions.add('    ${key.toInlineSql()}');
    }

    out += definitions.join(',\n');
    out += '\n) STRICT;\n';

    if (!skipIndexes) {
      // Indexes
      if (indexes.isNotEmpty) {
        out += '\n';
        out += '-- Indexes\n';
        for (var index in indexes) {
          out += index.toSql(
            tableName: tableName,
            ifNotExists: ifNotExists,
          );
        }
      }
    }

    out += '\n';

    return out;
  }
}

extension SqliteColumnDefinitionSqlGeneration on ColumnDefinition {
  bool addColumnNeedsRebuild(TableDefinition targetTable) {
    final isUnique = targetTable.indexes
        .where((index) => index.isUnique)
        .any((i) => i.elements.any((c) => c.definition == name));

    return isPrimary || isUnique || columnDefault != null;
  }

  String toSqlFragment() {
    String type;
    switch (columnType) {
      case ColumnType.bigint:
      case ColumnType.integer:
      case ColumnType.timestampWithoutTimeZone: // Stored as epoch milliseconds
      case ColumnType.boolean: // SQLite uses INTEGER (0/1) for booleans
        type = 'INTEGER';
      case ColumnType.doublePrecision:
        type = 'REAL';
      case ColumnType.uuid: // Storing UUIDs as BLOB for efficiency
      case ColumnType.bytea:
      case ColumnType.jsonb:
        type = 'BLOB';
      case ColumnType.text:
      case ColumnType.json:
      case ColumnType.vector:
      case ColumnType.halfvec:
      case ColumnType.sparsevec:
      case ColumnType.bit:
        type = 'TEXT';
      case ColumnType.unknown:
        throw const FormatException('Unknown column type');
    }

    var nullable = isNullable ? '' : ' NOT NULL';
    var defaultSql = columnType.getSqliteColumnDefault(columnDefault);

    var defaultValue = defaultSql != null ? ' DEFAULT ($defaultSql)' : '';

    // The id column is special.
    if (isPrimary) {
      if (isNullable) {
        throw const FormatException('The id column must be non-nullable');
      }
      // SQLite "INTEGER PRIMARY KEY" is an alias for ROWID.
      if (type == 'INTEGER') {
        defaultValue = '';
      }
      type = '$type PRIMARY KEY';
      nullable = '';
    }

    return '"$name" $type$nullable$defaultValue';
  }
}

extension SqliteIndexDefinitionSqlGeneration on IndexDefinition {
  String toSql({
    required String tableName,
    bool ifNotExists = false,
  }) {
    // No need to log a warning here since unsupported indexes will be filtered
    // out by the migration manager.
    if (type != 'btree') {
      return '';
    }

    var uniqueStr = isUnique ? ' UNIQUE' : '';
    var elementStrs = elements.map((e) => '"${e.definition}"');
    var ifNotExistsStr = ifNotExists ? ' IF NOT EXISTS' : '';

    return 'CREATE$uniqueStr INDEX$ifNotExistsStr "$indexName" ON "$tableName" '
        '(${elementStrs.join(', ')});\n';
  }
}

extension SqliteForeignKeyDefinitionSqlGeneration on ForeignKeyDefinition {
  /// SQLite requires inline constraints for "CREATE TABLE".
  /// It does NOT support "ALTER TABLE ADD CONSTRAINT".
  String toInlineSql() {
    var refColumnsFmt = referenceColumns.map((e) => '"$e"');

    var out =
        'CONSTRAINT "$constraintName" '
        'FOREIGN KEY ("${columns.join(', ')}") '
        'REFERENCES "$referenceTable" (${refColumnsFmt.join(', ')})';

    if (onDelete != null) {
      out += ' ON DELETE ${onDelete!.toSqlAction()}';
    }

    if (onUpdate != null) {
      out += ' ON UPDATE ${onUpdate!.toSqlAction()}';
    }

    return out;
  }
}

extension on ForeignKeyAction {
  String toSqlAction() => switch (this) {
    ForeignKeyAction.noAction => 'NO ACTION',
    ForeignKeyAction.restrict => 'RESTRICT',
    ForeignKeyAction.cascade => 'CASCADE',
    ForeignKeyAction.setNull => 'SET NULL',
    ForeignKeyAction.setDefault => 'SET DEFAULT',
  };
}

extension SqliteDatabaseMigrationSqlGeneration on DatabaseMigration {
  String toSqliteSql({
    required DatabaseDefinition databaseDefinition,
    required List<DatabaseMigrationVersionModel> installedModules,
    required List<DatabaseMigrationVersionModel> removedModules,
  }) {
    var out = '';

    out += 'BEGIN;\n';
    out += '\n';

    for (var action in actions) {
      out += action.toSqliteSql(databaseDefinition: databaseDefinition);
    }

    out += _sqlStoreColumnTypesForMigrations(
      databaseDefinition.tables,
      installedModules.first,
    );

    if (installedModules.isNotEmpty) {
      out += '\n';
    }

    for (var module in installedModules) {
      out += _sqlStoreMigrationVersion(
        module: module.module,
        version: module.version,
      );
    }

    if (removedModules.isNotEmpty) {
      out += '\n';
      out += _sqlRemoveMigrationVersion(removedModules);
    }

    out += '\n';
    out += 'COMMIT;\n';

    return out;
  }
}

extension SqliteMigrationActionSqlGeneration on DatabaseMigrationAction {
  String toSqliteSql({required DatabaseDefinition databaseDefinition}) {
    var out = '';

    switch (type) {
      case DatabaseMigrationActionType.deleteTable:
        out += '--\n';
        out += '-- ACTION DROP TABLE\n';
        out += '--\n';
        // SQLite doesn't support CASCADE in DROP TABLE. It's ignored if FKs
        // are off (default for migrations) or enforced if on.
        out += 'DROP TABLE "$deleteTable";\n';
        out += '\n';
        break;
      case DatabaseMigrationActionType.createTable:
        out += '--\n';
        out += '-- ACTION CREATE TABLE\n';
        out += '--\n';
        out += createTable!.tableCreationToSql();
        break;
      case DatabaseMigrationActionType.createTableIfNotExists:
        out += '--\n';
        out += '-- ACTION CREATE TABLE IF NOT EXISTS\n';
        out += '--\n';
        out += createTable!.tableCreationToSql(ifNotExists: true);
        break;
      case DatabaseMigrationActionType.alterTable:
        out += '--\n';
        out += '-- ACTION ALTER TABLE\n';
        out += '--\n';
        out += alterTable!.toSql(databaseDefinition);
        break;
    }

    return out;
  }
}

extension SqliteTableMigrationSqlGeneration on TableMigration {
  String toSql(DatabaseDefinition targetDefinition) {
    final targetTable = targetDefinition.tables.firstWhere(
      (t) => t.name == name,
      orElse: () => throw StateError(
        'SQLite table migration for "$name" requires target table definition.',
      ),
    );

    final needsRebuild =
        modifyColumns.hasColumnMigrationThatRequiresRebuild ||
        deleteForeignKeys.isNotEmpty ||
        addForeignKeys.isNotEmpty ||
        addColumns.any((c) => c.addColumnNeedsRebuild(targetTable));
    if (needsRebuild) {
      return toSqliteRebuildSql(targetTable);
    }

    var out = '';

    // Drop indexes
    for (var deleteIndex in deleteIndexes) {
      out += 'DROP INDEX "$deleteIndex";\n';
    }

    // Drop columns
    for (var deleteColumn in deleteColumns) {
      out += 'ALTER TABLE "$name" DROP COLUMN "$deleteColumn";\n';
    }

    // Rename columns (must happen before add to avoid name collisions)
    for (var modifiedColumn in modifyColumns) {
      var fromName = modifiedColumn.columnName;
      var toName = modifiedColumn.newColumnName;
      if (toName != null && toName != fromName) {
        out += 'ALTER TABLE "$name" RENAME COLUMN "$fromName" TO "$toName";\n';
      }
    }

    // Add columns
    for (var addColumn in addColumns) {
      // Note: SQLite ADD COLUMN cannot support PRIMARY KEY or UNIQUE constraints.
      // These will be handled by the table rebuild.
      out += 'ALTER TABLE "$name" ADD COLUMN ${addColumn.toSqlFragment()};\n';
    }

    // Add indexes
    for (var addIndex in addIndexes) {
      out += addIndex.toSql(tableName: name);
    }

    out += '\n';
    return out;
  }

  /// Returns SQL for a full table rebuild when this migration requires it
  /// (column type/nullability changes or FK add/drop).
  ///
  /// Implements SQLite's "Making Other Kinds Of Table Schema Changes" procedure.
  /// https://www.sqlite.org/lang_altertable.html#makingotherkindsofchanges
  String toSqliteRebuildSql(TableDefinition targetTable) {
    const newTablePrefix = 'new_';
    final newTableName = newTablePrefix + name;

    var out = '';

    // 1. Disable foreign key constraints (handled by the migration runner).
    // 2. Ensure the migration runs in a transaction (handled by the migration runner).
    // 3. No need to store indexes/triggers/views since we have the target definition.
    // 4. Create the new_<table_name> table in the target table format.
    out += targetTable.tableCreationToSql(
      tableNameOverride: newTableName,
      skipIndexes: true,
    );

    // 5. Transfer content from <table_name> into new_<table_name>.
    // Copy every target column that already existed on the old table: new
    // columns from this migration are omitted so SQLite fills them via DEFAULT
    // (or NULL) per INSERT rules.
    final addColumnNames = addColumns.map((c) => c.name).toSet();
    final copyColumns = targetTable.columns
        .where((c) => !addColumnNames.contains(c.name))
        .toList();
    if (copyColumns.isNotEmpty) {
      final colListNew = copyColumns.map((c) => '"${c.name}"').join(', ');
      final selectList = copyColumns
          .map((c) {
            final columnMigration = _getColumnMigrationByName(c.name);
            final sourceName = columnMigration?.columnName ?? c.name;

            return switch (columnMigration?.newType) {
              ColumnType.jsonb => 'jsonb("$sourceName")',
              ColumnType.json => 'json("$sourceName")',
              _ => '"$sourceName"',
            };
          })
          .join(', ');
      out +=
          'INSERT INTO "$newTableName" ($colListNew) '
          'SELECT $selectList FROM "$name";\n';
    }

    // 6. Drop the old table.
    out += 'DROP TABLE "$name";\n';

    // 7. Rename new_<table_name> to <table_name>.
    out += 'ALTER TABLE "$newTableName" RENAME TO "$name";\n';

    // 8. Recreate indexes from the target table definition. Triggers and views
    // are user-defined and must be handled by the user manually.
    for (var index in targetTable.indexes) {
      out += '\n';
      out += '-- Indexes\n';
      out += index.toSql(tableName: name);
    }

    // 9. Serverpod does not manager views, so no need to update related views.
    // 10. Verify foreign key constraints (handled by the migration runner).
    // 11. Commit the transaction (handled by the migration runner).
    // 12. Re-enable foreign keys. (handled by the migration runner)
    out += '\n';

    return out;
  }

  /// Returns the [ColumnMigration] for [targetColumnName].
  ///
  /// Prefer a rename whose destination is [targetColumnName] over an in-place
  /// change on a column that kept that name, so the copy uses the correct
  /// source column name when both could match.
  ColumnMigration? _getColumnMigrationByName(String targetColumnName) {
    // Find column migrations for renamed columns.
    for (final columnMigration in modifyColumns) {
      if (columnMigration.newColumnName == targetColumnName) {
        return columnMigration;
      }
    }
    // Find column migrations for in-place changes.
    for (final columnMigration in modifyColumns) {
      if (columnMigration.newColumnName == null &&
          columnMigration.columnName == targetColumnName) {
        return columnMigration;
      }
    }
    return null;
  }
}

String _sqlStoreMigrationVersion({
  required String module,
  required String version,
}) {
  String out = '';
  out += '--\n';
  out += '-- MIGRATION VERSION FOR $module\n';
  out += '--\n';
  out +=
      'INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")\n';
  out +=
      '    VALUES (\'$module\', \'$version\', (unixepoch(\'now\', \'subsecond\') * 1000))\n';
  out += '    ON CONFLICT ("module")\n';
  out +=
      '    DO UPDATE SET "version" = \'$version\', "timestamp" = (unixepoch(\'now\', \'subsecond\') * 1000);\n';
  out += '\n';

  return out;
}

/// Stores non-basic column types on a table to be able to compare schema changes
/// in migrations. This is required since column types on SQLite are simpler
/// and comparing only the actual column types would be too permissive and
/// generate deserialization errors in case the dart type being stored changes
/// between migrations.
String _sqlStoreColumnTypesForMigrations(
  List<TableDefinition> tables,
  DatabaseMigrationVersionModel currentModule,
) {
  String out = '';
  out += '--\n';
  out += '-- STORE COLUMN TYPES FOR MIGRATIONS\n';
  out += '--\n';
  out += 'DROP TABLE IF EXISTS "$_sqliteSchemaTable";\n';
  out += '\n';
  out += 'CREATE TABLE "$_sqliteSchemaTable" (\n';
  out += '    "table_name" TEXT NOT NULL,\n';
  out += '    "column_name" TEXT NOT NULL,\n';
  out += '    "column_type" TEXT NOT NULL,\n';
  out += '    "column_vector_dimension" INTEGER,\n';
  out += '    PRIMARY KEY ("table_name", "column_name")\n';
  out += ');\n';
  out += '\n';
  out += 'INSERT INTO "$_sqliteSchemaTable" VALUES\n';
  for (var t in tables) {
    for (var c in t.columns) {
      if (c.columnType.isBasicSqliteType) continue;
      out += '    (';
      out += "'${t.name}', ";
      out += "'${c.name}', ";
      out += "'${c.columnType.name}', ";
      out += "${c.vectorDimension ?? 'NULL'}";
      out += ')';
      out += (t == tables.last && c == t.columns.last) ? ';\n' : ',\n';
    }
  }
  return out;
}

extension on ColumnType {
  bool get isBasicSqliteType => switch (this) {
    ColumnType.integer => true,
    // Integer and bigint are the same type on SQLite, and the migration system
    // already skips migrations between them, so it is safe to skip bigint. It
    // is also the type with most columns (all ID columns are bigint).
    ColumnType.bigint => true,
    ColumnType.doublePrecision => true,
    ColumnType.bytea => true,
    ColumnType.text => true,
    _ => false,
  };
}

extension on List<ColumnMigration> {
  /// Whether any of the column migrations require a table rebuild. The only
  /// operation that does not require a table rebuild is a column rename.
  bool get hasColumnMigrationThatRequiresRebuild => any(
    (m) =>
        m.addNullable ||
        m.removeNullable ||
        m.changeDefault ||
        m.newType != null,
  );
}

String _sqlRemoveMigrationVersion(List<DatabaseMigrationVersionModel> modules) {
  var moduleNames = modules.map((e) => "'${e.module}'").toList().join(', ');
  String out = '';
  out += '--\n';
  out += '-- MIGRATION VERSION FOR $moduleNames\n';
  out += '--\n';
  out += 'DELETE FROM "serverpod_migrations" ';
  out += 'WHERE "module" IN ($moduleNames);';
  out += '\n';

  return out;
}
