import 'package:intl/intl.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../analyzer/models/utils/quote_utils.dart';
import '../../generator/types.dart';
import '../sql_generator.dart';

class PostgresSqlGenerator implements SqlGenerator {
  @override
  String generateDatabaseDefinitionSql(
    DatabaseDefinition databaseDefinition, {
    required List<DatabaseMigrationVersion> installedModules,
  }) {
    return databaseDefinition.toPgSql(
      installedModules: installedModules,
    );
  }

  @override
  String generateDatabaseMigrationSql(
    DatabaseMigration databaseMigration, {
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
  }) {
    return databaseMigration.toPgSql(
      installedModules: installedModules,
      removedModules: removedModules,
    );
  }

  @override
  String? getColumnDefault(
    TypeDefinition columnType,
    dynamic defaultValue,
    String tableName,
  ) {
    return columnType.getPgColumnDefault(
      defaultValue,
      tableName,
    );
  }
}

//
// SQL generation
//
extension PostgresDatabaseDefinitionPgSqlGeneration on DatabaseDefinition {
  String toPgSql({required List<DatabaseMigrationVersion> installedModules}) {
    String out = '';

    var tableCreation = '';
    var foreignRelations = '';
    for (var table in tables.where((table) => table.managed != false)) {
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

    // Must be declared before any table creation.
    if (tables.any((t) => t.columns.any((c) => c.isVectorColumn))) {
      out += _sqlCreateVectorExtensionIfAvailable();
      out += '\n';
    }

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

extension PostgresTableDefinitionPgSqlGeneration on TableDefinition {
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

extension PostgresColumnDefinitionPgSqlGeneration on ColumnDefinition {
  /// Whether the column is the default primary key column.
  bool get isIdColumn => name == defaultPrimaryKeyName;

  /// Whether the column is a primary key of type int serial.
  bool get isIntSerialIdColumn =>
      isIdColumn &&
      (columnType == ColumnType.integer || columnType == ColumnType.bigint) &&
      (columnDefault?.startsWith('nextval') ?? false);

  /// Whether the column is of a vector type.
  bool get isVectorColumn =>
      columnType == ColumnType.vector ||
      columnType == ColumnType.halfvec ||
      columnType == ColumnType.sparsevec ||
      columnType == ColumnType.bit;

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
      case ColumnType.vector:
        type = 'vector(${vectorDimension!})';
        break;
      case ColumnType.halfvec:
        type = 'halfvec(${vectorDimension!})';
        break;
      case ColumnType.sparsevec:
        type = 'sparsevec(${vectorDimension!})';
        break;
      case ColumnType.bit:
        type = 'bit(${vectorDimension!})';
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

extension PostgresIndexDefinitionPgSqlGeneration on IndexDefinition {
  String toPgSql({
    required String tableName,
    bool ifNotExists = false,
  }) {
    var out = '';

    var uniqueStr = isUnique ? ' UNIQUE' : '';
    var elementStrs = elements.map((e) => '"${e.definition}"');
    var ifNotExistsStr = ifNotExists ? ' IF NOT EXISTS' : '';

    String distanceStr = '';
    String pgvectorParams = '';

    if (type == 'hnsw' || type == 'ivfflat') {
      var prefix = vectorColumnType?.name;
      distanceStr = ' ${vectorDistanceFunction!.asDistanceFunction(prefix!)}';

      var paramStrings = parameters?.entries.map((e) => '${e.key}=${e.value}');
      pgvectorParams = (paramStrings?.isNotEmpty == true)
          ? ' WITH (${paramStrings!.join(', ')})'
          : '';
    }

    out +=
        'CREATE$uniqueStr INDEX$ifNotExistsStr "$indexName" ON "$tableName" '
        'USING $type (${elementStrs.join(', ')}$distanceStr)$pgvectorParams;\n';

    return out;
  }
}

extension PostgresForeignKeyDefinitionPgSqlGeneration on ForeignKeyDefinition {
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

extension PostgresDatabaseMigrationPgSqlGenerator on DatabaseMigration {
  String toPgSql({
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
  }) {
    var out = '';

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    // Must be declared before any table creation.
    if (actions.any(
      (e) =>
          (e.createTable != null &&
              e.createTable!.columns.any((c) => c.isVectorColumn)) ||
          (e.alterTable != null &&
              e.alterTable!.addColumns.any((c) => c.isVectorColumn)),
    )) {
      out += _sqlCreateVectorExtensionIfAvailable();
      out += '\n';
    }

    // Must be declared at the beginning for the function to be available.
    // Only add the function if it is used by any column on the migration.
    if (actions.any(
      (e) =>
          (e.createTable != null &&
              e.createTable!.columns.any(
                (c) => c.columnDefault == pgsqlFunctionRandomUuidV7,
              )) ||
          (e.alterTable != null &&
              (e.alterTable!.addColumns.any(
                    (c) => c.columnDefault == pgsqlFunctionRandomUuidV7,
                  ) ||
                  e.alterTable!.modifyColumns.any(
                    (c) => c.newDefault == pgsqlFunctionRandomUuidV7,
                  ))),
    )) {
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

extension PostgresMigrationActionPgSqlGeneration on DatabaseMigrationAction {
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

    var noForeignKeys =
        (createTable?.foreignKeys.isEmpty ?? true) &&
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

extension PostgresTableMigrationPgSqlGenerator on TableMigration {
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

extension PostgresColumnMigrationPgSqlGenerator on ColumnMigration {
  String toPgSql({
    required String tableName,
  }) {
    var out = '';
    if (addNullable) {
      out +=
          'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
          ' DROP NOT NULL;\n';
    } else if (removeNullable) {
      out +=
          'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
          ' SET NOT NULL;\n';
    }
    if (changeDefault) {
      if (newDefault == null) {
        out +=
            'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
            ' DROP DEFAULT;\n';
        return out;
      } else {
        out +=
            'ALTER TABLE "$tableName" ALTER COLUMN "$columnName"'
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
  out +=
      'INSERT INTO "serverpod_migrations" '
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

String _sqlCreateVectorExtensionIfAvailable() {
  return '--'
      '\n-- CREATE VECTOR EXTENSION IF AVAILABLE'
      '\n--'
      '\nDO \$\$'
      '\nBEGIN'
      "\n  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN"
      "\n    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';"
      '\n  ELSE'
      '\n    RAISE EXCEPTION \'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.\';'
      '\n  END IF;'
      '\nEND'
      '\n\$\$;'
      '\n';
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

extension PostgresVectorIndexDistanceFunction on VectorDistanceFunction {
  String asDistanceFunction([String vectorType = 'vector']) {
    var funcCode = (this == VectorDistanceFunction.innerProduct) ? 'ip' : name;
    return '${vectorType}_${funcCode}_ops';
  }
}

extension PostgresTypeDefinition on TypeDefinition {
  String? getPgColumnDefault(
    dynamic defaultValue,
    String tableName,
  ) {
    var defaultValueType = this.defaultValueType;
    if ((defaultValue == null) || (defaultValueType == null)) return null;

    switch (defaultValueType) {
      case DefaultValueAllowedType.dateTime:
        if (defaultValue is! String) {
          throw StateError('Invalid DateTime default value: $defaultValue');
        }

        if (defaultValue == defaultDateTimeValueNow) {
          return 'CURRENT_TIMESTAMP';
        }

        DateTime? dateTime = DateTime.parse(defaultValue);
        return '\'${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}\'::timestamp without time zone';
      case DefaultValueAllowedType.bool:
        return defaultValue;
      case DefaultValueAllowedType.int:
        if (defaultValue == defaultIntSerial) {
          return "nextval('${tableName}_id_seq'::regclass)";
        }
        return '$defaultValue';
      case DefaultValueAllowedType.double:
        return '$defaultValue';
      case DefaultValueAllowedType.string:
        return '${escapeSqlString(defaultValue)}::text';
      case DefaultValueAllowedType.uuidValue:
        if (defaultUuidValueRandom == defaultValue) {
          return 'gen_random_uuid()';
        }
        if (defaultUuidValueRandomV7 == defaultValue) {
          return 'gen_random_uuid_v7()';
        }
        return '${escapeSqlString(defaultValue)}::uuid';
      case DefaultValueAllowedType.uri:
        return '${escapeSqlString(defaultValue)}::text';
      case DefaultValueAllowedType.bigInt:
        var parsedBigInt = BigInt.parse(defaultValue);
        return "'${parsedBigInt.toString()}'::text";
      case DefaultValueAllowedType.duration:
        Duration parsedDuration = parseDuration(defaultValue);
        return '${parsedDuration.toJson()}';
      case DefaultValueAllowedType.isEnum:
        var enumDefinition = this.enumDefinition;
        if (enumDefinition == null) return null;
        var values = enumDefinition.values;
        return switch (enumDefinition.serialized) {
          EnumSerialization.byIndex =>
            '${values.indexWhere((e) => e.name == defaultValue)}',
          EnumSerialization.byName => '\'$defaultValue\'::text',
        };
    }
  }
}
