import 'package:recase/recase.dart';
import 'package:serverpod_database/serverpod_database.dart';
// This is a temporary internal import since the normalize functions are not
// meant to be exported from the database package. It will be removed once the
// [PostgresSqlGenerator] gets moved to the database package.
// ignore: implementation_imports
import 'package:serverpod_database/src/adapters/postgres/postgres_default_value.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart'
    show Geography;
import 'package:serverpod_shared/serverpod_shared.dart';
import '../extensions.dart'
    show
        ForeignKeyDefinitionExtension,
        TableDefinitionExtension,
        qualifiedTableName;
import '../sql_generator.dart';

/// A quoted identifier, schema-qualified outside the default schema.
String _pgIdentifier(String name, String schema) =>
    schema == DatabaseConstants.defaultSchema ? '"$name"' : '"$schema"."$name"';

String _sqlCreateSchemas(Iterable<String> schemas) {
  var names =
      schemas
          .where((s) => s != DatabaseConstants.defaultSchema)
          .toSet()
          .toList()
        ..sort();
  if (names.isEmpty) return '';

  var out = '--\n';
  out += '-- CREATE SCHEMA\n';
  out += '--\n';
  for (var name in names) {
    out += 'CREATE SCHEMA IF NOT EXISTS "$name";\n';
  }
  out += '\n';

  return out;
}

class PostgresSqlGenerator implements SqlGenerator {
  @override
  String generateDatabaseDefinitionSql(
    DatabaseDefinition databaseDefinition, {
    required List<DatabaseMigrationVersionModel> installedModules,
  }) {
    return databaseDefinition.toPgSql(
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
    return databaseMigration.toPgSql(
      databaseDefinition: databaseDefinition,
      installedModules: installedModules,
      removedModules: removedModules,
    );
  }
}

//
// SQL generation
//
extension PostgresDatabaseDefinitionPgSqlGeneration on DatabaseDefinition {
  String toPgSql({
    required List<DatabaseMigrationVersionModel> installedModules,
  }) {
    String out = '';

    var tableCreation = '';
    var foreignRelations = '';
    var managedTables = tables.where((table) => table.managed != false);
    for (var table in managedTables) {
      tableCreation += '--\n';
      tableCreation +=
          '-- Class ${table.dartName} as table ${table.qualifiedName}\n';
      tableCreation += '--\n';
      tableCreation += table.tableCreationToPgsql();
      if (table.foreignKeys.isNotEmpty) {
        foreignRelations += '--\n';
        foreignRelations +=
            '-- Foreign relations for "${table.qualifiedName}" table\n';
        foreignRelations += '--\n';
        foreignRelations += table.foreignRelationToPgsql();
      }
    }

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    out += _sqlCreateSchemas(managedTables.map((table) => table.schema));

    // Must be declared before any table creation.
    if (tables.any((t) => t.columns.any((c) => c.isVectorColumn))) {
      out += _sqlCreateVectorExtensionIfAvailable();
      out += '\n';
    }

    if (tables.any((t) => t.columns.any((c) => c.isGeographyColumn))) {
      out += _sqlCreatePostgisExtension();
      out += '\n';
    }

    // Must be declared at the beginning for the function to be available.
    if (tables.any(
      (t) => t.columns.any(
        (c) =>
            c.columnDefault == pgsqlFunctionRandomUuidV7 ||
            c.columnDefault == defaultUuidValueRandomV7,
      ),
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
    var table = _pgIdentifier(name, schema);
    if (ifNotExists) {
      out += 'CREATE TABLE IF NOT EXISTS $table (\n';
    } else {
      out += 'CREATE TABLE $table (\n';
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
        out += index.toPgSql(
          tableName: name,
          schema: schema,
          ifNotExists: ifNotExists,
        );
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
      out += key.toPgSql(tableName: name, schema: schema);
    }

    out += '\n';

    return out;
  }
}

extension PostgresColumnDefinitionPgSqlGeneration on ColumnDefinition {
  /// Whether the column uses a serial auto-increment default.
  bool get isIntSerialColumn =>
      (columnType == ColumnType.integer || columnType == ColumnType.bigint) &&
      columnDefault == defaultIntSerial;

  /// Whether the column is of a vector type.
  bool get isVectorColumn =>
      columnType == ColumnType.vector ||
      columnType == ColumnType.halfvec ||
      columnType == ColumnType.sparsevec ||
      columnType == ColumnType.bit;

  /// Whether the column is of a geography type.
  bool get isGeographyColumn =>
      columnType == ColumnType.geography ||
      columnType == ColumnType.geographyLineString ||
      columnType == ColumnType.geographyPolygon ||
      columnType == ColumnType.geographyGeometryCollection;

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
      case ColumnType.jsonb:
        type = 'jsonb';
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
      case ColumnType.geography:
        type = 'geography(Point,${Geography.defaultSrid})';
        break;
      case ColumnType.geographyLineString:
        type = 'geography(LineString,${Geography.defaultSrid})';
        break;
      case ColumnType.geographyPolygon:
        type = 'geography(Polygon,${Geography.defaultSrid})';
        break;
      case ColumnType.geographyGeometryCollection:
        type = 'geography(GeometryCollection,${Geography.defaultSrid})';
        break;
      case ColumnType.unknown:
        throw (const FormatException('Unknown column type'));
    }

    var nullable = isNullable ? '' : ' NOT NULL';
    var defaultSql = columnType.getPgColumnDefault(columnDefault);

    var defaultValue = defaultSql != null ? ' DEFAULT $defaultSql' : '';

    if (isIntSerialColumn) {
      type = columnType == ColumnType.bigint || isPrimary
          ? 'bigserial'
          : 'serial';
      defaultValue = '';
      nullable = ' NOT NULL';
    }

    // The id column is special.
    if (isPrimary) {
      if (isNullable) {
        throw const FormatException('The id column must be non-nullable');
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
    String schema = DatabaseConstants.defaultSchema,
    bool ifNotExists = false,
  }) {
    var out = '';

    var table = _pgIdentifier(tableName, schema);
    var uniqueStr = isUnique ? ' UNIQUE' : '';
    var nullsDistinctStr = switch (nullsDistinct) {
      true => ' NULLS DISTINCT',
      false => ' NULLS NOT DISTINCT',
      null => '',
    };
    var elementStrs = elements.map((e) => '"${e.definition}"');
    var ifNotExistsStr = ifNotExists ? ' IF NOT EXISTS' : '';

    String ginOperatorClassStr = '';

    if (type == 'gin' && ginOperatorClass != null) {
      ginOperatorClassStr = ' ${ginOperatorClass!.asOperator()}';
    }

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
        'CREATE$uniqueStr INDEX$ifNotExistsStr "$indexName" ON $table '
        'USING $type (${elementStrs.join(', ')}$ginOperatorClassStr$distanceStr)$nullsDistinctStr$pgvectorParams;\n';

    return out;
  }
}

extension GinIndexOperatorClass on GinOperatorClass {
  String asOperator() {
    return name.snakeCase;
  }
}

extension PostgresForeignKeyDefinitionPgSqlGeneration on ForeignKeyDefinition {
  String toPgSql({
    required String tableName,
    String schema = DatabaseConstants.defaultSchema,
  }) {
    var out = '';

    var refColumnsFmt = referenceColumns.map((e) => '"$e"');
    var reference = _pgIdentifier(referenceTable, referenceTableSchema);

    out += 'ALTER TABLE ONLY ${_pgIdentifier(tableName, schema)}\n';
    out += '    ADD CONSTRAINT "$constraintName"\n';
    out += '    FOREIGN KEY("${columns.join(', ')}")\n';
    out += '    REFERENCES $reference(${refColumnsFmt.join(', ')})';

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

    var deferrableClause = deferrable?.toPgSqlClause();
    if (deferrableClause != null) {
      out += '\n    $deferrableClause';
    }

    out += ';\n';

    return out;
  }
}

extension on DeferrableConstraint {
  String toPgSqlClause() {
    switch (this) {
      case DeferrableConstraint.initiallyImmediate:
        return 'DEFERRABLE INITIALLY IMMEDIATE';
      case DeferrableConstraint.initiallyDeferred:
        return 'DEFERRABLE INITIALLY DEFERRED';
    }
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
    required DatabaseDefinition databaseDefinition,
    required List<DatabaseMigrationVersionModel> installedModules,
    required List<DatabaseMigrationVersionModel> removedModules,
  }) {
    var out = '';

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    out += _sqlCreateSchemas([
      for (var action in actions) ...[
        ?action.createTable?.schema,
        ?action.alterTable?.newSchema,
      ],
    ]);

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

    if (actions.any(
      (e) =>
          (e.createTable != null &&
              e.createTable!.columns.any((c) => c.isGeographyColumn)) ||
          (e.alterTable != null &&
              e.alterTable!.addColumns.any((c) => c.isGeographyColumn)),
    )) {
      out += _sqlCreatePostgisExtension();
      out += '\n';
    }

    // Must be declared at the beginning for the function to be available.
    // Only add the function if it is used by any column on the migration.
    if (actions.any(
      (e) =>
          (e.createTable != null &&
              e.createTable!.columns.any(
                (c) =>
                    c.columnDefault == pgsqlFunctionRandomUuidV7 ||
                    c.columnDefault == defaultUuidValueRandomV7,
              )) ||
          (e.alterTable != null &&
              (e.alterTable!.addColumns.any(
                    (c) =>
                        c.columnDefault == pgsqlFunctionRandomUuidV7 ||
                        c.columnDefault == defaultUuidValueRandomV7,
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
      out += action.toPgSql(databaseDefinition);
      foreignKeyActions += action.foreignRelationToSql();
    }

    foreignKeyActions += _sqlRestoreInboundForeignKeys(
      actions,
      databaseDefinition,
    );

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
  String toPgSql(DatabaseDefinition databaseDefinition) {
    var out = '';

    switch (type) {
      case DatabaseMigrationActionType.deleteTable:
        out += '--\n';
        out += '-- ACTION DROP TABLE\n';
        out += '--\n';
        out +=
            'DROP TABLE ${_pgIdentifier(deleteTable!, deleteTableSchema ?? DatabaseConstants.defaultSchema)} CASCADE;\n';
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
        out += alterTable!.toPgSql(
          databaseDefinition
              .findTableNamed(
                alterTable!.name,
                schema: alterTable!.newSchema ?? alterTable!.schema,
              )!
              .columns,
        );
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
  /// The schema the table is in once this migration has run.
  String get targetSchema => newSchema ?? schema;

  String toPgSql(List<ColumnDefinition> targetColumns) {
    var out = '';

    // Move the table first, every statement below addresses the new name.
    if (newSchema case var newSchema?) {
      out +=
          'ALTER TABLE ${_pgIdentifier(name, schema)} SET SCHEMA "$newSchema";\n';
    }
    var table = _pgIdentifier(name, targetSchema);

    // Drop indexes
    for (var deleteIndex in deleteIndexes) {
      out += 'DROP INDEX ${_pgIdentifier(deleteIndex, targetSchema)};\n';
    }

    // Drop foreign keys. Uses IF EXISTS to avoid a hard failure for constraints
    // of dropped tables or columns.
    for (var deleteKey in deleteForeignKeys) {
      out += 'ALTER TABLE $table DROP CONSTRAINT IF EXISTS "$deleteKey";\n';
    }

    // Drop columns
    for (var deleteColumn in deleteColumns) {
      out += 'ALTER TABLE $table DROP COLUMN "$deleteColumn";\n';
    }

    // Rename columns (must happen before add/modify to avoid naming conflicts)
    for (var modifiedColumn in modifyColumns) {
      var fromName = modifiedColumn.columnName;
      var toName = modifiedColumn.newColumnName;
      if (toName != null && toName != fromName) {
        out += 'ALTER TABLE $table RENAME COLUMN "$fromName" TO "$toName";\n';
      }
    }

    // Add columns
    for (var addColumn in addColumns) {
      out += 'ALTER TABLE $table ADD COLUMN ${addColumn.toPgSqlFragment()};\n';
    }

    // Modify columns
    for (var alterColumn in modifyColumns) {
      out += alterColumn.toPgSql(
        tableName: name,
        schema: targetSchema,
        columnDefinition: targetColumns.firstWhere(
          (c) => c.name == alterColumn.physicalName,
        ),
      );
    }

    // Add indexes
    for (var addIndex in addIndexes) {
      out += addIndex.toPgSql(tableName: name, schema: targetSchema);
    }

    return out;
  }

  String foreignRelationToSql() {
    var out = '';

    if (addForeignKeys.isEmpty) return out;

    for (var addKey in addForeignKeys) {
      out += addKey.toPgSql(tableName: name, schema: targetSchema);
    }

    return out;
  }
}

extension PostgresColumnMigrationPgSqlGenerator on ColumnMigration {
  /// The physical name of the column to be used in the SQL statements, taking
  /// renames into consideration. Ensure that any using statement happen after
  /// the rename statements.
  String get physicalName => newColumnName ?? columnName;

  String toPgSql({
    required String tableName,
    String schema = DatabaseConstants.defaultSchema,
    required ColumnDefinition columnDefinition,
  }) {
    var out = '';
    var table = _pgIdentifier(tableName, schema);
    if (addNullable) {
      out +=
          'ALTER TABLE $table ALTER COLUMN "$physicalName"'
          ' DROP NOT NULL;\n';
    } else if (removeNullable) {
      out +=
          'ALTER TABLE $table ALTER COLUMN "$physicalName"'
          ' SET NOT NULL;\n';
    }
    if (changeDefault) {
      if (newDefault == null) {
        out +=
            'ALTER TABLE $table ALTER COLUMN "$physicalName"'
            ' DROP DEFAULT;\n';
        return out;
      } else if (newDefault == defaultIntSerial) {
        // Adding a serial default requires creating a sequence via the serial
        // pseudo-type on column (re)create. SET DEFAULT cannot express this.
        throw StateError(
          'Cannot SET DEFAULT "$defaultIntSerial" on column "$physicalName" '
          'of table "$tableName". Auto-increment defaults must be applied by '
          'recreating the column with the serial type.',
        );
      } else {
        var newDefaultSql = columnDefinition.columnType.getPgColumnDefault(
          newDefault,
        );
        out +=
            'ALTER TABLE $table ALTER COLUMN "$physicalName"'
            ' SET DEFAULT $newDefaultSql;\n';
      }
    }

    if (newType != null) {
      var typeName = newType!.name;
      out +=
          'ALTER TABLE $table ALTER COLUMN "$columnName"'
          ' SET DATA TYPE $typeName USING "$columnName"::$typeName;\n';
    }

    return out;
  }
}

/// Returns the SQL that restores foreign key constraints which other tables
/// declare against a table that is dropped and recreated by this migration.
///
/// `DROP TABLE ... CASCADE` also drops the foreign key constraints that other
/// tables have into the dropped table. The recreated table only brings back its
/// own outbound foreign keys, so the inbound ones have to be re-added
/// explicitly, or the database would silently diverge from the definition.
///
/// A constraint is skipped when its table is (re)created by this migration, or
/// when an alter table action already adds it back, since those actions emit it
/// themselves.
String _sqlRestoreInboundForeignKeys(
  List<DatabaseMigrationAction> actions,
  DatabaseDefinition databaseDefinition,
) {
  var createdTables = <String>{
    for (var action in actions)
      if (action.createTable case var table?) table.qualifiedName,
  };
  var recreatedTables = <String>{
    for (var action in actions)
      if (action.deleteTable case var name?)
        qualifiedTableName(
          name,
          action.deleteTableSchema ?? DatabaseConstants.defaultSchema,
        ),
  }.intersection(createdTables);
  if (recreatedTables.isEmpty) return '';

  var alteredForeignKeys = <String>{
    for (var action in actions)
      if (action.alterTable case var table?)
        for (var key in table.addForeignKeys)
          '${qualifiedTableName(table.name, table.targetSchema)}.${key.constraintName}',
  };

  var out = '';
  for (var table in databaseDefinition.tables) {
    if (table.managed == false) continue;
    // Tables created by this migration already declare all their foreign keys.
    if (createdTables.contains(table.qualifiedName)) continue;

    for (var foreignKey in table.foreignKeys) {
      if (!recreatedTables.contains(foreignKey.qualifiedReferenceTable)) {
        continue;
      }
      // The constraint is already re-added by an alter table action.
      var key = '${table.qualifiedName}.${foreignKey.constraintName}';
      if (alteredForeignKeys.contains(key)) continue;

      out += foreignKey.toPgSql(tableName: table.name, schema: table.schema);
    }
  }

  if (out.isEmpty) return out;

  return '--\n'
      '-- ACTION RESTORE FOREIGN KEY\n'
      '--\n'
      '$out';
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

String _sqlRemoveMigrationVersion(List<DatabaseMigrationVersionModel> modules) {
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

String _sqlCreatePostgisExtension() {
  return '--'
      '\n-- CREATE POSTGIS EXTENSION IF AVAILABLE'
      '\n--'
      '\nDO \$\$'
      '\nBEGIN'
      "\n  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'postgis') THEN"
      "\n    EXECUTE 'CREATE EXTENSION IF NOT EXISTS postgis';"
      '\n  ELSE'
      '\n    RAISE EXCEPTION \'Required extension "postgis" is not available on this instance. Please install PostGIS. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-postgis.\';'
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
