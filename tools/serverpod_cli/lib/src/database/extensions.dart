import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

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
    var diff = generateDatabaseMigration(this, other);
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
    var diff = generateTableMigration(this, other);
    return diff.isEmpty && other.name == name && other.schema == schema;
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

    // Other fields
    return other.constraintName == constraintName &&
        other.matchType == matchType &&
        other.onDelete == onDelete &&
        other.onUpdate == onUpdate &&
        other.referenceTable == referenceTable &&
        other.referenceTableSchema == referenceTableSchema;
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
        addIndexes.isEmpty &&
        deleteIndexes.isEmpty &&
        addForeignKeys.isEmpty &&
        deleteForeignKeys.isEmpty;
  }
}

extension DatabaseDefinitionPgSqlGeneration on DatabaseDefinition {
  String toPgSql() {
    String out = '';

    // TODO: Take dependencies into account
    tables.sort((a, b) => a.name.compareTo(b.name));

    for (var table in tables) {
      out += '--\n';
      out += '-- Class ${table.dartName} as table ${table.name}\n';
      out += '--\n';
      out += table.toPgSql();
      out += '\n';
    }

    return out;
  }
}

extension TableDefinitionPgSqlGeneration on TableDefinition {
  String toPgSql() {
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

    // Foreign keys
    if (foreignKeys.isNotEmpty) {
      out += '\n';
      out += '-- Foreign keys\n';
      for (var key in foreignKeys) {
        out += key.toPgSql(tableName: name);
      }
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
    out += '    REFERENCES "$referenceTable"(${refColumsFmt.join(', ')})\n';
    out += '    ON DELETE CASCADE;\n';

    return out;
  }
}

extension DatabaseMigrationPgSqlGenerator on DatabaseMigration {
  String toPgSql() {
    var out = '';

    for (var action in actions) {
      out += action.toPgSql();
    }

    return out;
  }
}

extension MigrationActionPgSqlGeneration on DatabaseMigrationAction {
  String toPgSql() {
    var out = '';

    switch (type) {
      case DatabaseMigrationActionType.deleteTable:
        out += '-- ACTION DELETE TABLE\n';
        out += 'DELETE TABLE "$deleteTable"\n';
        out += '\n';
        break;
      case DatabaseMigrationActionType.createTable:
        out += createTable!.toPgSql();
        break;
      case DatabaseMigrationActionType.alterTable:
        out += alterTable!.toPgSql();
        break;
    }

    return out;
  }
}

extension TableMigrationPgSqlGenerator on TableMigration {
  String toPgSql() {
    return '';
  }
}
