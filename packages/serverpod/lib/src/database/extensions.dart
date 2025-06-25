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

  /// Finds a table by its name, or returns null if no table with the given name.
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

  /// Finds a column by its name, or returns null if no column with the given name is found.
  ColumnDefinition? findColumnNamed(String columnName) {
    return columns.firstWhereOrNull((column) => column.name == columnName);
  }

  /// Finds an index by its name, or returns null if no index with the given name is found.
  IndexDefinition? findIndexNamed(String indexName, {bool ignoreCase = false}) {
    return indexes.firstWhereOrNull((index) => ignoreCase
        ? index.indexName.toLowerCase() == indexName.toLowerCase()
        : index.indexName == indexName);
  }

  /// Finds a foreign key by its name, or returns null if no key with the given name is found.
  ForeignKeyDefinition? findForeignKeyDefinitionNamed(
    String keyName, {
    bool ignoreCase = false,
  }) {
    return foreignKeys.firstWhereOrNull((key) => ignoreCase
        ? key.constraintName.toLowerCase() == keyName.toLowerCase()
        : key.constraintName == keyName);
  }

  /// Compares this table definition with [other], returning a list of mismatches.
  List<ComparisonWarning> like(TableDefinition other) {
    List<ComparisonWarning> mismatches = [];

    if (other.name != name) {
      mismatches.add(
        TableComparisonWarning(
          name: 'name',
          expected: name,
          found: other.name,
        ),
      );
    }

    if (other.tableSpace != tableSpace) {
      mismatches.add(
        TableComparisonWarning(
          name: 'tablespace',
          expected: tableSpace,
          found: other.tableSpace,
        ),
      );
    }

    if (managed != null && other.managed != null && managed != other.managed) {
      mismatches.add(
        TableComparisonWarning(
          name: 'managed property',
          expected: '$managed',
          found: '${other.managed}',
        ),
      );
    }

    for (var column in columns) {
      var otherColumn = other.findColumnNamed(column.name);
      if (otherColumn == null) {
        mismatches.add(
          ColumnComparisonWarning(
            name: column.name,
            expected: column.name,
            found: null,
          ),
        );
      } else {
        var columnMismatches = column.like(otherColumn);
        if (columnMismatches.isNotEmpty) {
          mismatches.add(ColumnComparisonWarning(
            name: column.name,
          ).addSubs(columnMismatches));
        }
      }
    }

    for (var index in indexes) {
      var otherIndex = other.findIndexNamed(index.indexName, ignoreCase: true);
      if (otherIndex == null) {
        mismatches.add(
          IndexComparisonWarning(
            name: index.indexName,
            expected: index.indexName,
            found: null,
          ),
        );
      } else {
        var indexMismatches = index.like(otherIndex, ignoreCase: true);
        if (indexMismatches.isNotEmpty) {
          mismatches.add(IndexComparisonWarning(
            name: index.indexName,
          ).addSubs(indexMismatches));
        }
      }
    }

    for (var foreignKey in foreignKeys) {
      var otherForeignKey = other.findForeignKeyDefinitionNamed(
        foreignKey.constraintName,
        ignoreCase: true,
      );
      if (otherForeignKey == null) {
        mismatches.add(
          ForeignKeyComparisonWarning(
            name: foreignKey.constraintName,
            expected: foreignKey.constraintName,
            found: null,
          ),
        );
      } else {
        var foreignKeyMismatches =
            foreignKey.like(otherForeignKey, ignoreCase: true);
        if (foreignKeyMismatches.isNotEmpty) {
          mismatches.add(
            ForeignKeyComparisonWarning(
              name: foreignKey.constraintName,
            ).addSubs(foreignKeyMismatches),
          );
        }
      }
    }

    return mismatches;
  }
}

/// Comparison methods for [ColumnDefinition].
extension ColumnComparisons on ColumnDefinition {
  /// Compares this column definition with [other], returning a list of mismatches.
  List<ColumnComparisonWarning> like(ColumnDefinition other) {
    List<ColumnComparisonWarning> mismatches = [];

    if (name != other.name) {
      mismatches.add(
        ColumnComparisonWarning(
          name: name,
          expected: name,
          found: other.name,
        ),
      );
    }

    if (!columnType.like(other.columnType)) {
      mismatches.add(
        ColumnComparisonWarning(
          name: 'type',
          expected: '$columnType',
          found: '${other.columnType}',
        ),
      );
    }

    if (isNullable != other.isNullable) {
      mismatches.add(
        ColumnComparisonWarning(
          name: 'isNullable',
          expected: '$isNullable',
          found: '${other.isNullable}',
        ),
      );
    }

    if (columnDefault != other.columnDefault) {
      mismatches.add(
        ColumnComparisonWarning(
          name: 'default value',
          expected: '$columnDefault',
          found: '${other.columnDefault}',
        ),
      );
    }

    if (vectorDimension != other.vectorDimension) {
      mismatches.add(
        ColumnComparisonWarning(
          name: 'vector dimension',
          expected: '$vectorDimension',
          found: '${other.vectorDimension}',
        ),
      );
    }

    return mismatches;
  }
}

/// Comparison methods for [IndexDefinition].
extension IndexComparisons on IndexDefinition {
  /// Compares this index definition with [other], returning a list of mismatches.
  List<IndexComparisonWarning> like(
    IndexDefinition other, {
    bool ignoreCase = false,
  }) {
    List<IndexComparisonWarning> mismatches = [];

    if (ignoreCase &&
            indexName.toLowerCase() != other.indexName.toLowerCase() ||
        !ignoreCase && indexName != other.indexName) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'name',
          expected: indexName,
          found: other.indexName,
        ),
      );
    }

    if (type != other.type) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'type',
          expected: type,
          found: other.type,
        ),
      );
    }

    if (isUnique != other.isUnique) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'isUnique',
          expected: '$isUnique',
          found: '${other.isUnique}',
        ),
      );
    }

    if (isPrimary != other.isPrimary) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'isPrimary',
          expected: '$isPrimary',
          found: '${other.isPrimary}',
        ),
      );
    }

    if (predicate != other.predicate) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'predicate',
          expected: predicate,
          found: other.predicate,
        ),
      );
    }

    if (tableSpace != other.tableSpace) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'tableSpace',
          expected: tableSpace,
          found: other.tableSpace,
        ),
      );
    }

    if (vectorDistanceFunction != other.vectorDistanceFunction) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'vector distance function',
          expected: vectorDistanceFunction?.name,
          found: other.vectorDistanceFunction?.name,
        ),
      );
    }

    if (vectorColumnType != other.vectorColumnType) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'vector column type',
          expected: vectorColumnType?.name,
          found: other.vectorColumnType?.name,
        ),
      );
    }

    // New parameters missing on other (or if other is null)
    parameters?.entries.forEach((entry) {
      if (other.parameters?[entry.key] != entry.value) {
        mismatches.add(
          IndexComparisonWarning(
            name: 'parameter ${entry.key}',
            expected: entry.value,
            found: other.parameters?[entry.key],
          ),
        );
      }
    });

    // Other parameters missing on this (or if this is null)
    other.parameters?.entries.forEach((otherEntry) {
      if (parameters?[otherEntry.key] == null) {
        mismatches.add(
          IndexComparisonWarning(
            name: 'parameter ${otherEntry.key}',
            expected: null,
            found: otherEntry.value,
          ),
        );
      }
    });

    if (elements.length != other.elements.length) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'elements',
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
  List<IndexComparisonWarning> like(IndexElementDefinition other) {
    List<IndexComparisonWarning> mismatches = [];

    if (type != other.type) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'element type',
          expected: '$type',
          found: '${other.type}',
        ),
      );
    }

    if (definition != other.definition) {
      mismatches.add(
        IndexComparisonWarning(
          name: 'element definition',
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
  List<ForeignKeyComparisonWarning> like(
    ForeignKeyDefinition other, {
    bool ignoreCase = false,
  }) {
    List<ForeignKeyComparisonWarning> mismatches = [];

    if (ignoreCase &&
            constraintName.toLowerCase() !=
                other.constraintName.toLowerCase() ||
        !ignoreCase && constraintName != other.constraintName) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'name',
          expected: constraintName,
          found: other.constraintName,
        ),
      );
    }

    if (!const ListEquality().equals(columns, other.columns)) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'columns',
          expected: '$columns',
          found: '${other.columns}',
        ),
      );
    }

    if (referenceTable != other.referenceTable) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'reference table',
          expected: referenceTable,
          found: other.referenceTable,
        ),
      );
    }

    if (!const ListEquality()
        .equals(referenceColumns, other.referenceColumns)) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'reference columns',
          expected: '$referenceColumns',
          found: '${other.referenceColumns}',
        ),
      );
    }

    if (onUpdate != other.onUpdate) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'onUpdate action',
          expected: '$onUpdate',
          found: '${other.onUpdate}',
        ),
      );
    }

    if (onDelete != other.onDelete) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'onDelete action',
          expected: '$onDelete',
          found: '${other.onDelete}',
        ),
      );
    }

    if (matchType != null &&
        other.matchType != null &&
        matchType != other.matchType) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'match type',
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
            'Column "${constraint.column}" not found in table "${tableDefinition.name}".');
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
          'Unsupported column type ${columnDefinition.columnType} for column "${columnDefinition.name}".');
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
