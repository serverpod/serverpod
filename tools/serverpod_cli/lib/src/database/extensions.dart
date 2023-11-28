import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

//
// Comparisons of database entities
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
      priority: -1,
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
    return diff != null &&
        diff.isEmpty &&
        other.name == name &&
        other.schema == schema;
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
        other.columnType == columnType &&
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
    return isNullable || columnDefault != null;
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
    var cReferenceSchema = other.referenceTableSchema == referenceTableSchema;

    return cName &&
        cMatchType &&
        cOnDelete &&
        cOnUpdate &&
        cReferenceTable &&
        cReferenceSchema;
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

//
// SQL generation
//

extension DatabaseDefinitionPgSqlGeneration on DatabaseDefinition {
  String toPgSql({
    required String version,
    required String module,
  }) {
    String out = '';

    var tableCreation = '';
    var foreignRelations = '';
    for (var table in tables) {
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

    // Create tables
    out += tableCreation;

    // Create foreign relations
    out += foreignRelations;

    out += _sqlStoreMigrationVersion(
      module: module,
      version: version,
    );

    out += '\n';
    out += 'COMMIT;\n';

    return out;
  }
}

extension TableDefinitionPgSqlGeneration on TableDefinition {
  String tableCreationToPgsql() {
    String out = '';

    // Table
    out += 'CREATE TABLE "$name" (\n';

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
        out += index.toPgSql(tableName: name);
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
  String toPgSqlFragment() {
    String out = '';

    if (name == 'id') {
      // The id column is special.
      assert(isNullable == false);
      assert(
        columnType == ColumnType.integer || columnType == ColumnType.bigint,
      );
      // TODO: Migrate to bigserial / bigint
      return '"id" serial PRIMARY KEY';
    }

    var nullable = isNullable ? '' : ' NOT NULL';
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

    out += '"$name" $type$nullable';
    return out;
  }
}

extension IndexDefinitionPgSqlGeneration on IndexDefinition {
  String toPgSql({
    required String tableName,
  }) {
    var out = '';

    var uniqueStr = isUnique ? ' UNIQUE' : '';
    var elementStrs = elements.map((e) => '"${e.definition}"');

    out += 'CREATE$uniqueStr INDEX "$indexName" ON "$tableName" USING $type'
        ' (${elementStrs.join(', ')});\n';

    return out;
  }
}

extension ForeignKeyDefinitionPgSqlGeneration on ForeignKeyDefinition {
  String toPgSql({
    required String tableName,
  }) {
    var out = '';

    var refColumsFmt = referenceColumns.map((e) => '"$e"');

    out += 'ALTER TABLE ONLY "$tableName"\n';
    out += '    ADD CONSTRAINT "$constraintName"\n';
    out += '    FOREIGN KEY("${columns.join(', ')}")\n';
    out += '    REFERENCES "$referenceTable"(${refColumsFmt.join(', ')})';

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
    required Map<String, String> versions,
  }) {
    var out = '';

    // Start transaction
    out += 'BEGIN;\n';
    out += '\n';

    var foreignKeyActions = '';
    for (var action in actions) {
      out += action.toPgSql();
      foreignKeyActions += action.foreignRelationToSql();
    }

    // Append all foreign key operations at the end
    out += foreignKeyActions;

    if (versions.isNotEmpty) {
      out += '\n';
    }

    for (var module in versions.keys) {
      var version = versions[module]!;
      out += _sqlStoreMigrationVersion(
        module: module,
        version: version,
      );
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

    if (createTable == null) return out;

    if (createTable!.foreignKeys.isEmpty) return out;

    out += '--\n';
    out += '-- ACTION CREATE FOREIGN KEY\n';
    out += '--\n';
    out += createTable!.foreignRelationToPgsql();

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

    // Add foreign keys
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
