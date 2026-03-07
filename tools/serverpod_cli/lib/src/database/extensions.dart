import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'sql_generator.dart';

// Export underlying dialect implementations.
export 'dialects/postgres.dart';

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
        other.columnDefault == columnDefault &&
        other.vectorDimension == vectorDimension);
  }

  bool canMigrateTo(ColumnDefinition other) {
    // It's ok to change column default or nullability.
    if (other.dartType != null &&
        dartType != null &&
        !_canMigrateType(dartType!, other.dartType!)) {
      return false;
    }

    // Vector dimension changes require dropping and recreating the column.
    if (vectorDimension != other.vectorDimension) {
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
        other.type == type &&
        other.vectorDistanceFunction == vectorDistanceFunction &&
        other.vectorColumnType == vectorColumnType &&
        _parametersMapEquals(other.parameters);
  }

  bool _parametersMapEquals(Map<String, String>? other) {
    final parameters = this.parameters;
    if (parameters == null && other == null) return true;
    if (parameters == null || other == null) return false;
    if (parameters.length != other.length) return false;

    for (var key in {...parameters.keys, ...other.keys}) {
      if (parameters[key] != other[key]) return false;
    }
    return true;
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

extension ColumnTypeComparison on ColumnType {
  bool like(ColumnType other) {
    // Integer and bigint are considered the same type.
    if (this == ColumnType.integer || this == ColumnType.bigint) {
      return other == ColumnType.integer || other == ColumnType.bigint;
    }

    return this == other;
  }
}

extension DatabaseDefinitionSqlGeneration on DatabaseDefinition {
  String toSql({
    required List<DatabaseMigrationVersion> installedModules,
    required DatabaseDialect dialect,
  }) {
    return SqlGenerator.forDialect(dialect).generateDatabaseDefinitionSql(
      this,
      installedModules: installedModules,
    );
  }
}

extension DatabaseMigrationSqlGeneration on DatabaseMigration {
  String toSql({
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
    required DatabaseDialect dialect,
  }) {
    return SqlGenerator.forDialect(dialect).generateDatabaseMigrationSql(
      this,
      installedModules: installedModules,
      removedModules: removedModules,
    );
  }
}
