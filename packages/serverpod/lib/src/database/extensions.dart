import 'package:serverpod/database.dart';
import 'package:serverpod/protocol.dart';

/// Comparison methods for [DatabaseDefinition].
extension DatabaseComparisons on DatabaseDefinition {
  /// Returns true if the database contains a table with the given [tableName].
  bool containsTableNamed(String tableName) {
    return (findTableNamed(tableName) != null);
  }

  /// Finds a table by its name, or returns null if no table with the given
  /// name.
  TableDefinition? findTableNamed(String tableName) {
    for (var table in tables) {
      if (table.name == tableName) {
        return table;
      }
    }
    return null;
  }

  /// Returns true if the database structure is identical to the [other]
  /// database. Ignores comparisons of Dart types and names.
  bool like(DatabaseDefinition other) {
    if (other.tables.length != tables.length) {
      return false;
    }

    for (var table in tables) {
      var otherTable = other.findTableNamed(table.name);
      if (otherTable == null || !table.like(otherTable)) {
        return false;
      }
    }
    return true;
  }
}

/// Comparison methods for [TableDefinition].
extension TableComparisons on TableDefinition {
  /// Returns true if the table contains a column with the given [columnName].
  bool containsColumnNamed(String columnName) {
    return findColumnNamed(columnName) != null;
  }

  /// Returns true if the table contains an index with the given [indexName].
  bool containsIndexNamed(String indexName) {
    return findIndexNamed(indexName) != null;
  }

  /// Returns true if the table contains a foreign key with the given [keyName].
  bool containsForeignKeyNamed(String keyName) {
    return findForeignKeyDefinitionNamed(keyName) != null;
  }

  /// Finds a column by its name, or returns null if no column with the given
  /// name is found.
  ColumnDefinition? findColumnNamed(String columnName) {
    for (var column in columns) {
      if (column.name == columnName) {
        return column;
      }
    }
    return null;
  }

  /// Finds an index by its name, or returns null if no index with the given
  /// name is found.
  IndexDefinition? findIndexNamed(String indexName, {bool ignoreCase = false}) {
    for (var index in indexes) {
      if (ignoreCase) {
        if (index.indexName.toLowerCase() == indexName.toLowerCase()) {
          return index;
        }
      } else {
        if (index.indexName == indexName) {
          return index;
        }
      }
    }
    return null;
  }

  /// Finds a foreign key by its name, or returns null if no key with the
  /// given name is found.
  ForeignKeyDefinition? findForeignKeyDefinitionNamed(
    String keyName, {
    bool ignoreCase = false,
  }) {
    for (var key in foreignKeys) {
      if (ignoreCase) {
        if (key.constraintName.toLowerCase() == keyName.toLowerCase()) {
          return key;
        }
      } else {
        if (key.constraintName == keyName) {
          return key;
        }
      }
    }
    return null;
  }

  /// Returns true if the table structure is identical to the [other]. Ignores
  /// comparisons of Dart types and names.
  bool like(TableDefinition other) {
    // Columns
    if (other.columns.length != columns.length) {
      return false;
    }
    for (var column in columns) {
      var otherColumn = other.findColumnNamed(column.name);
      if (otherColumn == null || !column.like(otherColumn)) {
        return false;
      }
    }

    // Indexes
    if (other.indexes.length != indexes.length) {
      return false;
    }
    for (var index in indexes) {
      var otherIndex = other.findIndexNamed(
        index.indexName,
        ignoreCase: true,
      );
      if (otherIndex == null ||
          !index.like(
            otherIndex,
            ignoreCase: true,
          )) {
        return false;
      }
    }

    // Foreign keys
    if (other.foreignKeys.length != foreignKeys.length) {
      return false;
    }
    for (var key in foreignKeys) {
      var otherKey = other.findForeignKeyDefinitionNamed(
        key.constraintName,
        ignoreCase: true,
      );
      if (otherKey == null || !key.like(otherKey, ignoreCase: true)) {
        return false;
      }
    }

    // Other fields
    return other.name == name &&
        other.tableSpace == tableSpace &&
        other.schema == schema;
  }
}

/// Comparison methods for [ColumnDefinition].
extension ColumnComparisons on ColumnDefinition {
  /// Returns true if the column structure is identical to the [other]. Ignores
  /// comparisons of Dart types and names.
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

/// Comparison methods for [IndexDefinition].
extension IndexComparisons on IndexDefinition {
  /// Returns true if the index structure is identical to the [other]. Ignores
  /// comparisons of Dart types and names.
  bool like(
    IndexDefinition other, {
    bool ignoreCase = false,
  }) {
    if (ignoreCase) {
      if (other.indexName.toLowerCase() != indexName.toLowerCase()) {
        return false;
      }
    } else {
      if (other.indexName != indexName) {
        return false;
      }
    }

    return other.isPrimary == isPrimary &&
        other.isUnique == isUnique &&
        other.predicate == predicate &&
        other.tableSpace == tableSpace &&
        other.type == type;
  }
}

/// Comparison methods for [ForeignKeyDefinition].
extension ForeignKeyComparisons on ForeignKeyDefinition {
  /// Returns true if the foreign key structure is identical to the [other].
  /// Ignores comparisons of Dart types and names.
  bool like(
    ForeignKeyDefinition other, {
    bool ignoreCase = false,
  }) {
    if (ignoreCase) {
      if (other.constraintName.toLowerCase() != constraintName.toLowerCase()) {
        return false;
      }
    } else {
      if (other.constraintName != constraintName) {
        return false;
      }
    }

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
    // TODO: Correctly compare matchType and onUpdate. Null should represent
    // NO ACTION. It's possibly that the analyzer or generator need to be
    // updated to support too.
    return other.onDelete == onDelete &&
        // other.matchType == matchType &&
        // other.onUpdate == onUpdate &&
        other.referenceTable == referenceTable &&
        other.referenceTableSchema == referenceTableSchema;
  }
}

/// SQL code generation methods for [Filter].
extension FilterGenerator on Filter {
  /// Generates a SQL WHERE clause from the filter.
  String toQuery(TableDefinition tableDefinition) {
    var expressions = <String>[];
    for (var constraint in constraints) {
      var columnDefinition = tableDefinition.findColumnNamed(constraint.column);
      if (columnDefinition == null) {
        throw Exception(
          'Column "${constraint.column}" not found in table '
          '"${tableDefinition.name}".',
        );
      }

      var expression = constraint.toQuery(columnDefinition);
      expressions.add('($expression)');
    }

    return expressions.join(' AND ');
  }
}

/// SQL code generation methods for [FilterConstraint].
extension FilterConstraintGenerator on FilterConstraint {
  /// Generates a SQL WHERE clause from the filter constraint.
  String toQuery(ColumnDefinition columnDefinition) {
    assert(columnDefinition.name == column);

    var columnType = columnDefinition.columnType;
    String formattedValue;
    if (columnType == ColumnType.integer ||
        columnType == ColumnType.bigint ||
        columnType == ColumnType.doublePrecision ||
        columnType == ColumnType.boolean) {
      formattedValue = value;
    } else if (columnType == ColumnType.text) {
      formattedValue = DatabasePoolManager.encoder.convert(value);
    } else if (columnType == ColumnType.timestampWithoutTimeZone) {
      var dateTime = DateTime.tryParse(value);
      if (dateTime != null) {
        formattedValue = DatabasePoolManager.encoder.convert(dateTime);
      } else {
        formattedValue = 'NULL';
      }
    } else {
      throw Exception(
        'Unsupported column type ${columnDefinition.columnType} for column '
        '"${columnDefinition.name}".',
      );
    }

    if (type == FilterConstraintType.equals) {
      return '"$column" = $formattedValue';
    } else if (type == FilterConstraintType.notEquals) {
      return '"$column" != $formattedValue';
    } else if (type == FilterConstraintType.greaterThan) {
      return '"$column" > $formattedValue';
    } else if (type == FilterConstraintType.greaterThanOrEquals) {
      return '"$column" >= $formattedValue';
    } else if (type == FilterConstraintType.lessThan) {
      return '"$column" < $formattedValue';
    } else if (type == FilterConstraintType.lessThanOrEquals) {
      return '"$column" <= $formattedValue';
    } else if (type == FilterConstraintType.between) {
      return '"$column" BETWEEN $formattedValue AND $value2';
    } else if (type == FilterConstraintType.isNull) {
      return '"$column" IS NULL';
    } else if (type == FilterConstraintType.isNotNull) {
      return '"$column" IS NOT NULL';
    }
    throw Exception('Unsupported constraint type $type for column "$column."');
  }
}
