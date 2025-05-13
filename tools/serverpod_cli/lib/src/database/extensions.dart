import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

//
// Comparisons of database models
//
extension DatabaseComparisons on DatabaseDefinition {
  bool containsTableNamed(String tableName) {
    return (findTableNamed(tableName) != null);
  }

  TableDefinition? findTableNamed(String tableName) {
    for (var table in tables) {
      if (table.name == tableName) {
        return table;
      }
    }
    return null;
  }

  bool like(DatabaseDefinition other) {
    var diff = generateDatabaseMigration(
      databaseSource: this,
      databaseTarget: other,
    );
    return diff.isEmpty;
  }
}

extension TableComparisons on TableDefinition {
  bool containsColumnNamed(String columnName) {
    return findColumnNamed(columnName) != null;
  }

  bool containsIndexNamed(String indexName) {
    return findIndexNamed(indexName) != null;
  }

  bool containsForeignKeyNamed(String keyName) {
    return findForeignKeyDefinitionNamed(keyName) != null;
  }

  ColumnDefinition? findColumnNamed(String columnName) {
    for (var column in columns) {
      if (column.name == columnName) {
        return column;
      }
    }
    return null;
  }

  IndexDefinition? findIndexNamed(String indexName) {
    for (var index in indexes) {
      if (index.indexName == indexName) {
        return index;
      }
    }
    return null;
  }

  ForeignKeyDefinition? findForeignKeyDefinitionNamed(String keyName) {
    for (var key in foreignKeys) {
      if (key.constraintName == keyName) {
        return key;
      }
    }
    return null;
  }

  bool like(TableDefinition other) {
    var diff = generateTableMigration(this, other, []);
    return diff != null && diff.isEmpty && other.name == name;
  }
}

extension ColumnComparisons on ColumnDefinition {
  bool like(ColumnDefinition other) {
    if (other.dartType != null &&
        dartType != null &&
        other.dartType != dartType) {
      return false;
    }

    return (other.isNullable == isNullable &&
        other.columnType.like(columnType) &&
        other.name == name &&
        other.columnDefault == columnDefault);
  }

  bool canMigrateTo(ColumnDefinition other) {
    // It's ok to change column default or nullability.
    if (other.dartType != null &&
        dartType != null &&
        !_canMigrateType(dartType!, other.dartType!)) {
      return false;
    }

    return other.columnType == columnType && other.name == name;
  }

  bool get canBeCreatedInTableMigration {
    return (isNullable || columnDefault != null) &&
        name != defaultPrimaryKeyName;
  }
}

bool _canMigrateType(String src, String dst) {
  src = removeNullability(src);
  dst = removeNullability(dst);

  return src == dst;
}

String removeNullability(String type) {
  if (type.endsWith('?')) {
    return type.substring(0, type.length - 1);
  }
  return type;
}

extension IndexComparisons on IndexDefinition {
  bool like(IndexDefinition other) {
    return other.isPrimary == isPrimary &&
        other.isUnique == isUnique &&
        other.indexName == indexName &&
        other.predicate == predicate &&
        other.tableSpace == tableSpace &&
        other.type == type;
  }
}

extension ForeignKeyComparisons on ForeignKeyDefinition {
  bool like(ForeignKeyDefinition other) {
    // Columns
    if (other.columns.length != columns.length) {
      return false;
    }
    for (int i = 0; i < columns.length; i += 1) {
      if (other.columns[i] != columns[i]) {
        return false;
      }
    }

    // Reference columns
    if (other.referenceColumns.length != referenceColumns.length) {
      return false;
    }
    for (int i = 0; i < referenceColumns.length; i += 1) {
      if (other.referenceColumns[i] != referenceColumns[i]) {
        return false;
      }
    }
    // Default match type and action
    var dMT = ForeignKeyMatchType.simple;
    var dKA = ForeignKeyAction.noAction;

    // Other fields
    var cName = other.constraintName == constraintName;
    var cMatchType = (other.matchType ?? dMT) == (matchType ?? dMT);
    var cOnDelete = other.onDelete == onDelete;
    var cOnUpdate = (other.onUpdate ?? dKA) == (onUpdate ?? dKA);
    var cReferenceTable = other.referenceTable == referenceTable;

    return cName && cMatchType && cOnDelete && cOnUpdate && cReferenceTable;
  }
}

extension DatabaseDiffComparisons on DatabaseMigration {
  bool get isEmpty {
    return actions.isEmpty;
  }
}

extension TableDiffComparisons on TableMigration {
  bool get isEmpty {
    return addColumns.isEmpty &&
        deleteColumns.isEmpty &&
        modifyColumns.isEmpty &&
        addIndexes.isEmpty &&
        deleteIndexes.isEmpty &&
        addForeignKeys.isEmpty &&
        deleteForeignKeys.isEmpty;
  }
}

extension TableDefinitionExtension on TableDefinition {
  bool get isManaged => managed != false;
}

//
// SQL generation
//
extension DatabaseDefinitionPgSqlGeneration on DatabaseDefinition {
  String toPgSql({required List<DatabaseMigrationVersion> installedModules}) {
    String out = '';

    var tableCreation = '';
    var foreignRelations = '';
    for (var table in tables.where((table) => table.isManaged)) {
      tableCreation += '--\n';
      tableCreation += '-- Class ${table.dartName} as table ${table.name}\n';
      tableCreation += '--\n';
      tableCreation += table.tableCreationToPgsql();
      if (table.foreignKeys.isNotEmpty) {
        foreignRelations += '--\n';
        foreignRelations += '-- Foreign relations for "${table.name}" table\n';
        foreignRelations += '--\n';
        foreignRelations += table.foreignRelationToPgsql();
      }
    }

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    // Must be declared at the beginning for the function to be available.
    if (tables.any(
      (t) => t.columns.any((c) => c.columnDefault == pgsqlFunctionRandomUuidV7),
    )) {
      out += _sqlUuidGenerateV7FunctionDeclaration();
      out += '\n';
    }

    // Create tables
    out += tableCreation;

    // Create foreign relations
    out += foreignRelations;

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

extension TableDefinitionPgSqlGeneration on TableDefinition {
  String tableCreationToPgsql({bool ifNotExists = false}) {
    String out = '';

    // Table
    if (ifNotExists) {
      out += 'CREATE TABLE IF NOT EXISTS "$name" (\n';
    } else {
      out += 'CREATE TABLE "$name" (\n';
    }

    var columnsPgSql = <String>[];
    for (var column in columns) {
      columnsPgSql.add('    ${column.toPgSqlFragment()}');
    }
    out += columnsPgSql.join(',\n');

    out += '\n);\n';

    // Indexes
    var indexesExceptId = <IndexDefinition>[];
    for (var index in indexes) {
      if (index.elements.length == 1 &&
          index.elements.first.definition == 'id') {
        continue;
      }
      indexesExceptId.add(index);
    }

    if (indexesExceptId.isNotEmpty) {
      out += '\n';
      out += '-- Indexes\n';
      for (var index in indexesExceptId) {
        out += index.toPgSql(tableName: name, ifNotExists: ifNotExists);
      }
    }

    out += '\n';

    return out;
  }

  String foreignRelationToPgsql() {
    var out = '';

    if (foreignKeys.isEmpty) return out;

    // Foreign keys
    for (var key in foreignKeys) {
      out += key.toPgSql(tableName: name);
    }

    out += '\n';

    return out;
  }
}

extension ColumnDefinitionPgSqlGeneration on ColumnDefinition {
  /// Whether the column is the default primary key column.
  bool get isIdColumn => name == defaultPrimaryKeyName;

  /// Whether the column is a primary key of type int serial.
  bool get isIntSerialIdColumn =>
      isIdColumn &&
      (columnType == ColumnType.integer || columnType == ColumnType.bigint) &&
      (columnDefault?.startsWith('nextval') ?? false);

  String toPgSqlFragment() {
    String type;
    switch (columnType) {
      case ColumnType.bigint:
        type = 'bigint';
        break;
      case ColumnType.boolean:
        type = 'boolean';
        break;
      case ColumnType.bytea:
        type = 'bytea';
        break;
      case ColumnType.doublePrecision:
        type = 'double precision';
        break;
      case ColumnType.integer:
        type = 'integer';
        break;
      case ColumnType.json:
        type = 'json';
        break;
      case ColumnType.text:
        type = 'text';
        break;
      case ColumnType.timestampWithoutTimeZone:
        type = 'timestamp without time zone';
        break;
      case ColumnType.uuid:
        type = 'uuid';
        break;
      case ColumnType.unknown:
        throw (const FormatException('Unknown column type'));
    }

    var nullable = isNullable ? '' : ' NOT NULL';
    var defaultValue = columnDefault != null ? ' DEFAULT $columnDefault' : '';

    // The id column is special.
    if (isIdColumn) {
      if (isNullable) {
        throw const FormatException('The id column must be non-nullable');
      }

      if (isIntSerialIdColumn) {
        type = 'bigserial';
        defaultValue = '';
      }

      type = '$type PRIMARY KEY';
      nullable = '';
    }

    return '"$name" $type$nullable$defaultValue';
  }
}

extension IndexDefinitionPgSqlGeneration on IndexDefinition {
  String toPgSql({
    required String tableName,
    bool ifNotExists = false,
  }) {
    var out = '';

    var uniqueStr = isUnique ? ' UNIQUE' : '';
    var elementStrs = elements.map((e) => '"${e.definition}"');
    var ifNotExistsStr = ifNotExists ? ' IF NOT EXISTS' : '';

    out +=
        'CREATE$uniqueStr INDEX$ifNotExistsStr "$indexName" ON "$tableName" USING $type'
        ' (${elementStrs.join(', ')});\n';

    return out;
  }
}

extension ForeignKeyDefinitionPgSqlGeneration on ForeignKeyDefinition {
  String toPgSql({
    required String tableName,
  }) {
    var out = '';

    var refColumnsFmt = referenceColumns.map((e) => '"$e"');

    out += 'ALTER TABLE ONLY "$tableName"\n';
    out += '    ADD CONSTRAINT "$constraintName"\n';
    out += '    FOREIGN KEY("${columns.join(', ')}")\n';
    out += '    REFERENCES "$referenceTable"(${refColumnsFmt.join(', ')})';

    String? delete = onDelete?.toPgSqlAction();
    if (delete != null) {
      out += '\n';
      out += '    ON DELETE $delete';
    }

    String? update = onUpdate?.toPgSqlAction();
    if (update != null) {
      out += '\n';
      out += '    ON UPDATE $update';
    }

    out += ';\n';

    return out;
  }
}

extension on ForeignKeyAction {
  String toPgSqlAction() {
    switch (this) {
      case ForeignKeyAction.noAction:
        return 'NO ACTION';
      case ForeignKeyAction.restrict:
        return 'RESTRICT';
      case ForeignKeyAction.cascade:
        return 'CASCADE';
      case ForeignKeyAction.setNull:
        return 'SET NULL';
      case ForeignKeyAction.setDefault:
        return 'SET DEFAULT';
    }
  }
}

extension DatabaseMigrationPgSqlGenerator on DatabaseMigration {
  String toPgSql({
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
  }) {
    var out = '';

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    // Must be declared at the beginning for the function to be available.
    // Only add the function if it is used by any column on the migration.
    if (actions.any((e) =>
        (e.createTable != null &&
            e.createTable!.columns
                .any((c) => c.columnDefault == pgsqlFunctionRandomUuidV7)) ||
        (e.alterTable != null &&
            (e.alterTable!.addColumns
                    .any((c) => c.columnDefault == pgsqlFunctionRandomUuidV7) ||
                e.alterTable!.modifyColumns
                    .any((c) => c.newDefault == pgsqlFunctionRandomUuidV7))))) {
      out += _sqlUuidGenerateV7FunctionDeclaration();
      out += '\n';
    }

    var foreignKeyActions = '';
    for (var action in actions) {
      out += action.toPgSql();
      foreignKeyActions += action.foreignRelationToSql();
    }

    // Append all foreign key operations at the end
    out += foreignKeyActions;

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

extension MigrationActionPgSqlGeneration on DatabaseMigrationAction {
  String toPgSql() {
    var out = '';

    switch (type) {
      case DatabaseMigrationActionType.deleteTable:
        out += '--\n';
        out += '-- ACTION DROP TABLE\n';
        out += '--\n';
        out += 'DROP TABLE "$deleteTable" CASCADE;\n';
        out += '\n';
        break;
      case DatabaseMigrationActionType.createTable:
        out += '--\n';
        out += '-- ACTION CREATE TABLE\n';
        out += '--\n';
        out += createTable!.tableCreationToPgsql();
        break;
      case DatabaseMigrationActionType.createTableIfNotExists:
        out += '--\n';
        out += '-- ACTION CREATE TABLE IF NOT EXISTS\n';
        out += '--\n';
        out += createTable!.tableCreationToPgsql(ifNotExists: true);
        break;
      case DatabaseMigrationActionType.alterTable:
        out += '--\n';
        out += '-- ACTION ALTER TABLE\n';
        out += '--\n';
        out += alterTable!.toPgSql();
        break;
    }

    return out;
  }

  String foreignRelationToSql() {
    var out = '';

    var noForeignKeys = (createTable?.foreignKeys.isEmpty ?? true) &&
        (alterTable?.addForeignKeys.isEmpty ?? true);

    if (noForeignKeys) return out;

    out += '--\n';
    out += '-- ACTION CREATE FOREIGN KEY\n';
    out += '--\n';

    out += createTable?.foreignRelationToPgsql() ?? '';
    out += alterTable?.foreignRelationToSql() ?? '';

    return out;
  }
}

extension TableMigrationPgSqlGenerator on TableMigration {
  String toPgSql() {
    var out = '';

    // Drop indexes
    for (var deleteIndex in deleteIndexes) {
      out += 'DROP INDEX "$deleteIndex";\n';
    }

    // Drop foreign keys
    for (var deleteKey in deleteForeignKeys) {
      out += 'ALTER TABLE "$name" DROP CONSTRAINT "$deleteKey";\n';
    }

    // Drop columns
    for (var deleteColumn in deleteColumns) {
      out += 'ALTER TABLE "$name" DROP COLUMN "$deleteColumn";\n';
    }

    // Add columns
    for (var addColumn in addColumns) {
      out += 'ALTER TABLE "$name" ADD COLUMN ${addColumn.toPgSqlFragment()};\n';
    }

    // Modify columns
    for (var alterColumn in modifyColumns) {
      out += alterColumn.toPgSql(tableName: name);
    }

    // Add indexes
    for (var addIndex in addIndexes) {
      out += addIndex.toPgSql(tableName: name);
    }

    return out;
  }

  String foreignRelationToSql() {
    var out = '';

    if (addForeignKeys.isEmpty) return out;

    for (var addKey in addForeignKeys) {
      out += addKey.toPgSql(tableName: name);
    }

    return out;
  }
}

extension ColumnMigrationPgSqlGenerator on ColumnMigration {
  String toPgSql({
    required String tableName,
  }) {
    var out = '';
    if (addNullable) {
      out += 'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
          ' DROP NOT NULL;\n';
    } else if (removeNullable) {
      out += 'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
          ' SET NOT NULL;\n';
    }
    if (changeDefault) {
      if (newDefault == null) {
        out += 'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
            ' DROP DEFAULT;\n';
        return out;
      } else {
        out += 'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
            ' SET DEFAULT $newDefault;\n';
      }
    }

    return out;
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
  out += 'INSERT INTO "serverpod_migrations" '
      '("module", "version", "timestamp")\n';
  out += '    VALUES (\'$module\', \'$version\', now())\n';
  out += '    ON CONFLICT ("module")\n';
  out += '    DO UPDATE SET "version" = \'$version\', "timestamp" = now();\n';
  out += '\n';

  return out;
}

String _sqlRemoveMigrationVersion(List<DatabaseMigrationVersion> modules) {
  var moduleNames = modules.map((e) => "'${e.module}'").toList().join(', ');
  String out = '';
  out += '--\n';
  out += '-- MIGRATION VERSION FOR $moduleNames\n';
  out += '--\n';
  out += 'DELETE FROM "serverpod_migrations"';
  out += 'WHERE "module" IN ($moduleNames);';
  out += '\n';

  return out;
}

const pgsqlFunctionRandomUuidV7 = 'gen_random_uuid_v7()';

/// Add a function to generate v7 UUIDs in the database. The function name was
/// chosen close to the current `gen_random_uuid()` function in Postgres. The
/// function is implemented according to the RFC 9562 and uses only Postgres
/// native functions (no need for extensions).
///
String _sqlUuidGenerateV7FunctionDeclaration() {
  /*
   * This function is licensed under the MIT License.
   * Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
   *
   * The scope of the below license ("Software") is limited to the function
   * `gen_random_uuid_v7` implementation, which is a derivative work of the
   * original `uuid_generate_v7` function. The license does not apply to any
   * other part of the codebase.
   *
   * Copyright 2023 Kyle Hubert <kjmph@users.noreply.github.com>
   *
   * Permission is hereby granted, free of charge, to any person
   * obtaining a copy of this software and associated documentation files
   * (the "Software"), to deal in the Software without restriction,
   * including without limitation the rights to use, copy, modify, merge,
   * publish, distribute, sublicense, and/or sell copies of the Software,
   * and to permit persons to whom the Software is furnished to do so,
   * subject to the following conditions:
   *
   * The above copyright notice and this permission notice shall be
   * included in all copies or substantial portions of the Software.
   *
   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   */
  return '--'
      '\n-- Function: $pgsqlFunctionRandomUuidV7'
      '\n-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74'
      '\n-- License: MIT (copyright notice included on the generator source code).'
      '\n--'
      '\ncreate or replace function $pgsqlFunctionRandomUuidV7'
      '\nreturns uuid'
      '\nas \$\$'
      '\nbegin'
      '\n  -- use random v4 uuid as starting point (which has the same variant we need)'
      '\n  -- then overlay timestamp'
      '\n  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string'
      '\n  return encode('
      '\n    set_bit('
      '\n      set_bit('
      '\n        overlay(uuid_send(gen_random_uuid())'
      '\n                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)'
      '\n                from 1 for 6'
      '\n        ),'
      '\n        52, 1'
      '\n      ),'
      '\n      53, 1'
      '\n    ),'
      "\n    'hex')::uuid;"
      '\nend'
      '\n\$\$'
      '\nlanguage plpgsql'
      '\nvolatile;'
      '\n';
}

extension ColumnTypeComparison on ColumnType {
  bool like(ColumnType other) {
    // Integer and bigint are considered the same type.
    if (this == ColumnType.integer || this == ColumnType.bigint) {
      return other == ColumnType.integer || other == ColumnType.bigint;
    }

    return this == other;
  }
}
