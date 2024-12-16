import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:collection/collection.dart';
import 'package:serverpod/src/database/extensions/column_comparison_extension.dart';
import 'package:serverpod/src/database/extensions/foreign_key_comparison_extension.dart';
import 'package:serverpod/src/database/extensions/index_comparison_extension.dart';
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

    if (other.schema != schema) {
      mismatches.add(
        TableComparisonWarning(
          name: 'schema',
          expected: schema,
          found: other.schema,
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
