import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:collection/collection.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';

/// Comparison methods for [DatabaseDefinition].
extension DatabaseComparisons on DatabaseDefinition {
  /// Returns true if the database contains a table with the given [tableName].
  bool containsTableNamed(String tableName) {
    return (findTableNamed(tableName) != null);
  }

  /// Finds a table by its name, or returns null if no table with the given
  /// name.
  TableDefinition? findTableNamed(String tableName) {
    return tables.firstWhereOrNull((table) => table.name == tableName);
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
    return columns.firstWhereOrNull((column) => column.name == columnName);
  }

  /// Finds an index by its name, or returns null if no index with the given
  /// name is found.
  IndexDefinition? findIndexNamed(String indexName, {bool ignoreCase = false}) {
    return indexes.firstWhereOrNull((index) => ignoreCase
        ? index.indexName.toLowerCase() == indexName.toLowerCase()
        : index.indexName == indexName);
  }

  /// Finds a foreign key by its name, or returns null if no key with the
  /// given name is found.
  ForeignKeyDefinition? findForeignKeyDefinitionNamed(
    String keyName, {
    bool ignoreCase = false,
  }) {
    return foreignKeys.firstWhereOrNull((key) => ignoreCase
        ? key.constraintName.toLowerCase() == keyName.toLowerCase()
        : key.constraintName == keyName);
  }

  /// Compares this table definition with [other], returning a list of mismatches.
  /// The comparison checks columns, indexes, foreign keys, and general table properties.
  /// Returns an empty list if the tables are identical.
  List<ComparisonWarning> like(TableDefinition other) {
    List<ComparisonWarning> mismatches = [];

    // Compare table name
    if (other.name != name) {
      mismatches.add(
        TableComparisonWarning(
          mismatch: 'name',
          expected: name,
          found: other.name,
        ),
      );
    }

    // Compare table space
    if (other.tableSpace != tableSpace) {
      mismatches.add(
        TableComparisonWarning(
          mismatch: 'tablespace',
          expected: tableSpace,
          found: other.tableSpace,
        ),
      );
    }

    // Compare table schema
    if (other.schema != schema) {
      mismatches.add(
        TableComparisonWarning(
          mismatch: 'schema',
          expected: schema,
          found: other.schema,
        ),
      );
    }

    // Compare table managed property
    if (managed != null && other.managed != null && managed != other.managed) {
      mismatches.add(
        TableComparisonWarning(
          mismatch: 'managed property',
          expected: '$managed',
          found: '${other.managed}',
        ),
      );
    }

    // Compare columns
    for (var column in columns) {
      var otherColumn = other.findColumnNamed(column.name);
      if (otherColumn == null) {
        mismatches.add(
          ColumnComparisonWarning(
            mismatch: 'missing',
            expected: column.name,
            found: 'none',
          ),
        );
      } else {
        var columnMismatches = column.like(otherColumn);
        if (columnMismatches.isNotEmpty) {
          mismatches.add(
            ColumnComparisonWarning().addSubs(columnMismatches),
          );
        }
      }
    }

    // Compare indexes
    for (var index in indexes) {
      var otherIndex = other.findIndexNamed(index.indexName, ignoreCase: true);
      if (otherIndex == null) {
        mismatches.add(
          IndexComparisonWarning(
            mismatch: 'missing index',
            expected: index.indexName,
            found: 'none',
          ),
        );
      } else {
        var indexMismatches = index.like(otherIndex, ignoreCase: true);
        if (indexMismatches.isNotEmpty) {
          mismatches.add(
            IndexComparisonWarning().addSubs(indexMismatches),
          );
        }
      }
    }

    for (var otherIndex in other.indexes) {
      if (findIndexNamed(otherIndex.indexName, ignoreCase: true) == null) {
        mismatches.add(
          IndexComparisonWarning(
            mismatch: 'extra index',
            expected: 'none',
            found: otherIndex.indexName,
          ),
        );
      }
    }

    // Compare foreign keys
    for (var key in foreignKeys) {
      var otherKey = other.findForeignKeyDefinitionNamed(key.constraintName,
          ignoreCase: true);
      if (otherKey == null) {
        mismatches.add(
          ForeignKeyComparisonWarning(
            mismatch: 'missing',
            expected: key.constraintName,
            found: 'none',
          ),
        );
      } else {
        var keyMismatches = key.like(otherKey, ignoreCase: true);
        if (keyMismatches.isNotEmpty) {
          mismatches.add(
            ForeignKeyComparisonWarning().addSubs(keyMismatches),
          );
        }
      }
    }

    for (var otherKey in other.foreignKeys) {
      if (findForeignKeyDefinitionNamed(otherKey.constraintName,
              ignoreCase: true) ==
          null) {
        mismatches.add(
          ForeignKeyComparisonWarning(
            mismatch: 'extra foreign key',
            expected: 'none',
            found: otherKey.constraintName,
          ),
        );
      }
    }

    return mismatches;
  }
}

/// Comparison methods for [ColumnDefinition].
extension ColumnComparisons on ColumnDefinition {
  /// Compares this column definition with [other], returning a list of mismatches.
  /// Returns an empty list if the columns are identical.
  List<ColumnComparisonWarning> like(ColumnDefinition other) {
    List<ColumnComparisonWarning> mismatches = [];

    if (name != other.name) {
      mismatches.add(
        ColumnComparisonWarning.sub(
          mismatch: 'name',
          expected: name,
          found: other.name,
        ),
      );
    }

    if (!columnType.like(other.columnType)) {
      mismatches.add(
        ColumnComparisonWarning.sub(
          mismatch: 'type',
          expected: '$columnType',
          found: '${other.columnType}',
        ),
      );
    }

    if (isNullable != other.isNullable) {
      mismatches.add(
        ColumnComparisonWarning.sub(
          mismatch: 'nullability',
          expected: '$isNullable',
          found: '${other.isNullable}',
        ),
      );
    }

    if (columnDefault != other.columnDefault) {
      mismatches.add(
        ColumnComparisonWarning.sub(
          mismatch: 'default value',
          expected: '$columnDefault',
          found: '${other.columnDefault}',
        ),
      );
    }

    return mismatches;
  }
}

/// Comparison methods for [IndexDefinition].
extension IndexComparisons on IndexDefinition {
  /// Compares this index definition with [other], returning a list of mismatches.
  /// Returns an empty list if the indexes are identical.
  List<IndexComparisonWarning> like(
    IndexDefinition other, {
    bool ignoreCase = false,
  }) {
    List<IndexComparisonWarning> mismatches = [];

    if (ignoreCase) {
      if (indexName.toLowerCase() != other.indexName.toLowerCase()) {
        mismatches.add(
          IndexComparisonWarning.sub(
            mismatch: 'name',
            expected: indexName,
            found: other.indexName,
          ),
        );
      }
    } else {
      if (indexName != other.indexName) {
        mismatches.add(
          IndexComparisonWarning.sub(
            mismatch: 'name',
            expected: indexName,
            found: other.indexName,
          ),
        );
      }
    }

    if (type != other.type) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'type',
          expected: type,
          found: other.type,
        ),
      );
    }

    if (isUnique != other.isUnique) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'uniqueness',
          expected: '$isUnique',
          found: '${other.isUnique}',
        ),
      );
    }

    if (isPrimary != other.isPrimary) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'primary key',
          expected: '$isPrimary',
          found: '${other.isPrimary}',
        ),
      );
    }

    if (predicate != other.predicate) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'predicate',
          expected: predicate ?? 'none',
          found: other.predicate ?? 'none',
        ),
      );
    }

    if (tableSpace != other.tableSpace) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'tablespace',
          expected: tableSpace ?? 'none',
          found: other.tableSpace ?? 'none',
        ),
      );
    }

    if (elements.length != other.elements.length) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'element count',
          expected: '${elements.length}',
          found: '${other.elements.length}',
        ),
      );
    } else {
      for (int i = 0; i < elements.length; i++) {
        var elementMismatches = elements[i].like(other.elements[i]);
        if (elementMismatches.isNotEmpty) {
          mismatches.addAll(elementMismatches);
        }
      }
    }

    return mismatches;
  }
}

/// Comparison methods for [IndexElementDefinition].
extension IndexElementDefinitionComparison on IndexElementDefinition {
  /// Compares this index element with [other], returning a list of mismatches.
  /// Returns an empty list if the elements are identical.
  List<IndexComparisonWarning> like(
    IndexElementDefinition other,
  ) {
    List<IndexComparisonWarning> mismatches = [];

    if (type != other.type) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'element type',
          expected: '$type',
          found: '${other.type}',
        ),
      );
    }

    if (definition != other.definition) {
      mismatches.add(
        IndexComparisonWarning.sub(
          mismatch: 'element definition',
          expected: definition,
          found: other.definition,
        ),
      );
    }

    return mismatches;
  }
}

/// Comparison methods for [ForeignKeyDefinition].
extension ForeignKeyComparisons on ForeignKeyDefinition {
  /// Compares this foreign key definition with [other], returning a list of mismatches.
  /// Returns an empty list if the foreign keys are identical.
  List<ForeignKeyComparisonWarning> like(
    ForeignKeyDefinition other, {
    bool ignoreCase = false,
  }) {
    List<ForeignKeyComparisonWarning> mismatches = [];

    if (ignoreCase) {
      if (constraintName.toLowerCase() != other.constraintName.toLowerCase()) {
        mismatches.add(
          ForeignKeyComparisonWarning.sub(
            mismatch: 'constraint name',
            expected: constraintName,
            found: other.constraintName,
          ),
        );
      }
    } else {
      if (constraintName != other.constraintName) {
        mismatches.add(
          ForeignKeyComparisonWarning.sub(
            mismatch: 'constraint name',
            expected: constraintName,
            found: other.constraintName,
          ),
        );
      }
    }

    if (!const ListEquality().equals(columns, other.columns)) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'columns',
          expected: '$columns',
          found: '${other.columns}',
        ),
      );
    }

    if (referenceTable != other.referenceTable) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'reference table',
          expected: referenceTable,
          found: other.referenceTable,
        ),
      );
    }

    if (referenceTableSchema != other.referenceTableSchema) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'reference schema',
          expected: referenceTableSchema,
          found: other.referenceTableSchema,
        ),
      );
    }

    if (!const ListEquality()
        .equals(referenceColumns, other.referenceColumns)) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'reference columns',
          expected: '$referenceColumns',
          found: '${other.referenceColumns}',
        ),
      );
    }

    if (onUpdate != other.onUpdate) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'onUpdate action',
          expected: '$onUpdate',
          found: '${other.onUpdate}',
        ),
      );
    }

    if (onDelete != other.onDelete) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'onDelete action',
          expected: '$onDelete',
          found: '${other.onDelete}',
        ),
      );
    }

    if (matchType != null &&
        other.matchType != null &&
        matchType != other.matchType) {
      mismatches.add(
        ForeignKeyComparisonWarning.sub(
          mismatch: 'match type',
          expected: '$matchType',
          found: '${other.matchType}',
        ),
      );
    }

    return mismatches;
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
      if (type == FilterConstraintType.inThePast) {
        formattedValue = _microsecondsToInterval(int.parse(value));
      } else {
        var dateTime = DateTime.tryParse(value);
        if (dateTime != null) {
          formattedValue = DatabasePoolManager.encoder.convert(dateTime);
        } else {
          formattedValue = 'NULL';
        }
      }
    } else {
      throw Exception(
        'Unsupported column type ${columnDefinition.columnType} for column '
        '"${columnDefinition.name}".',
      );
    }

    switch (type) {
      case FilterConstraintType.equals:
        return '"$column" = $formattedValue';
      case FilterConstraintType.notEquals:
        return '"$column" != $formattedValue';
      case FilterConstraintType.greaterThan:
        return '"$column" > $formattedValue';
      case FilterConstraintType.greaterThanOrEquals:
        return '"$column" >= $formattedValue';
      case FilterConstraintType.lessThan:
        return '"$column" < $formattedValue';
      case FilterConstraintType.lessThanOrEquals:
        return '"$column" <= $formattedValue';
      case FilterConstraintType.like:
        return '"$column" LIKE $formattedValue';
      case FilterConstraintType.notLike:
        return '"$column" NOT LIKE $formattedValue';
      case FilterConstraintType.iLike:
        return '"$column" ILIKE $formattedValue';
      case FilterConstraintType.notILike:
        return '"$column" NOT ILIKE $formattedValue';
      case FilterConstraintType.between:
        return '"$column" BETWEEN $formattedValue AND $value2';
      case FilterConstraintType.inThePast:
        return '"$column" > (NOW() - $formattedValue)';
      case FilterConstraintType.isNull:
        return '"$column" IS NULL';
      case FilterConstraintType.isNotNull:
        return '"$column" IS NOT NULL';
    }
  }
}

String _microsecondsToInterval(int microseconds) {
  var duration = Duration(microseconds: microseconds);
  return 'INTERVAL \'${duration.inDays} days ${duration.inHours.remainder(24)} hours ${duration.inMinutes.remainder(60)} minutes ${duration.inSeconds.remainder(60)} seconds\'';
}

extension _ColumnTypeComparison on ColumnType {
  bool like(ColumnType other) {
    const integerEquivalentTypes = {
      ColumnType.integer,
      ColumnType.bigint,
    };

    // If this type is in the integerEquivalentTypes set,
    // check if the other type is also in it.
    if (integerEquivalentTypes.contains(this)) {
      return integerEquivalentTypes.contains(other);
    }

    // Direct comparison for other types.
    return this == other;
  }
}
