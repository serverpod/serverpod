import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:collection/collection.dart';

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

  /// Compares this table definition with [other], returning a list of mismatches.
  /// The comparison checks columns, indexes, foreign keys, and general table properties.
  /// Returns an empty list if the tables are identical.
  List<String> like(TableDefinition other) {
    List<String> mismatches = [];

    // Compare table name
    if (other.name != name) {
      mismatches
          .add('Table name mismatch: Expected "$name", found "${other.name}".');
    }

    // Compare table space
    if (other.tableSpace != tableSpace) {
      mismatches.add(
          'Tablespace mismatch: Expected "$tableSpace", found "${other.tableSpace}".');
    }

    // Compare table schema
    if (other.schema != schema) {
      mismatches
          .add('Schema mismatch: Expected "$schema", found "${other.schema}".');
    }

    // Columns
    for (var column in columns) {
      var otherColumn = other.findColumnNamed(column.name);
      if (otherColumn == null) {
        mismatches
            .add('Column "${column.name}" is missing in the target schema.');
      } else {
        var columnMismatches = column.like(otherColumn);
        if (columnMismatches.isNotEmpty) {
          mismatches.add(
              'Column "${column.name}" mismatch: ${columnMismatches.join(', ')}');
        }
      }
    }

    for (var otherColumn in other.columns) {
      var column = findColumnNamed(otherColumn.name);
      if (column == null) {
        mismatches.add(
            'Extra column "${otherColumn.name}" found in the target schema.');
      }
    }

    // Indexes
    for (var index in indexes) {
      var otherIndex = other.findIndexNamed(index.indexName, ignoreCase: true);
      if (otherIndex == null) {
        mismatches
            .add('Index "${index.indexName}" is missing in the target schema.');
      } else {
        var indexMismatches = index.like(otherIndex, ignoreCase: true);
        if (indexMismatches.isNotEmpty) {
          mismatches.add(
              'Index "${index.indexName}" mismatch: ${indexMismatches.join(', ')}');
        }
      }
    }

    for (var otherIndex in other.indexes) {
      var index = findIndexNamed(otherIndex.indexName, ignoreCase: true);
      if (index == null) {
        mismatches.add(
            'Extra index "${otherIndex.indexName}" found in the target schema.');
      }
    }

    // Foreign keys
    for (var key in foreignKeys) {
      var otherKey = other.findForeignKeyDefinitionNamed(key.constraintName,
          ignoreCase: true);
      if (otherKey == null) {
        mismatches.add(
            'Foreign key "${key.constraintName}" is missing in the target schema.');
      } else {
        var keyMismatches = key.like(otherKey, ignoreCase: true);
        if (keyMismatches.isNotEmpty) {
          mismatches.add(
              'Foreign key "${key.constraintName}" mismatch: ${keyMismatches.join(', ')}');
        }
      }
    }

    for (var otherKey in other.foreignKeys) {
      var key = findForeignKeyDefinitionNamed(otherKey.constraintName,
          ignoreCase: true);
      if (key == null) {
        mismatches.add(
            'Extra foreign key "${otherKey.constraintName}" found in the target schema.');
      }
    }

    return mismatches;
  }
}

/// Comparison methods for [ColumnDefinition].
extension ColumnComparisons on ColumnDefinition {
  /// Compares this column definition with [other], returning a list of mismatches.
  /// Returns an empty list if the columns are identical.
  List<String> like(ColumnDefinition other) {
    List<String> mismatches = [];

    if (name != other.name) {
      mismatches.add('Name mismatch: Expected "$name", found "${other.name}".');
    }

    if (!columnType.like(other.columnType)) {
      mismatches.add(
          'Type mismatch: Expected "$columnType", found "${other.columnType}".');
    }

    if (isNullable != other.isNullable) {
      mismatches.add(
          'Nullability mismatch: Expected "$isNullable", found "${other.isNullable}".');
    }

    if (columnDefault != other.columnDefault) {
      mismatches.add(
          'Default value mismatch: Expected "$columnDefault", found "${other.columnDefault}".');
    }
    return mismatches;
  }
}

/// Comparison methods for [IndexDefinition].
extension IndexComparisons on IndexDefinition {
  /// Compares this index definition with [other], returning a list of mismatches.
  /// Returns an empty list if the indexes are identical.
  List<String> like(IndexDefinition other, {bool ignoreCase = false}) {
    List<String> mismatches = [];

    if (ignoreCase) {
      if (indexName.toLowerCase() != other.indexName.toLowerCase()) {
        mismatches.add(
            'Index name mismatch: Expected "$indexName", found "${other.indexName}".');
      }
    } else {
      if (indexName != other.indexName) {
        mismatches.add(
            'Index name mismatch: Expected "$indexName", found "${other.indexName}".');
      }
    }

    if (type != other.type) {
      mismatches
          .add('Index type mismatch: Expected "$type", found "${other.type}".');
    }

    if (isUnique != other.isUnique) {
      mismatches.add(
          'Index uniqueness mismatch: Expected "$isUnique", found "${other.isUnique}".');
    }

    if (isPrimary != other.isPrimary) {
      mismatches.add(
          'Index primary key mismatch: Expected "$isPrimary", found "${other.isPrimary}".');
    }

    if (predicate != other.predicate) {
      mismatches.add(
          'Index predicate mismatch: Expected "$predicate", found "${other.predicate}".');
    }

    if (tableSpace != other.tableSpace) {
      mismatches.add(
          'Index tablespace mismatch: Expected "$tableSpace", found "${other.tableSpace}".');
    }

    // Compare elements
    if (elements.length != other.elements.length) {
      mismatches.add(
          'Index element count mismatch: Expected ${elements.length}, found ${other.elements.length}.');
    } else {
      for (int i = 0; i < elements.length; i++) {
        var elementMismatches = elements[i].like(other.elements[i]);
        if (elementMismatches.isNotEmpty) {
          mismatches.add(
              'Index element mismatch at position $i: ${elementMismatches.join(', ')}');
        }
      }
    }

    return mismatches;
  }
}

/// Comparison methods for [IndexElementDefinitionComparison].
extension IndexElementDefinitionComparison on IndexElementDefinition {
  /// Compares this index element with [other], returning a list of mismatches.
  /// Returns an empty list if the elements are identical.
  List<String> like(IndexElementDefinition other) {
    List<String> mismatches = [];

    if (type != other.type) {
      mismatches.add(
          'Element type mismatch: Expected "$type", found "${other.type}".');
    }

    if (definition != other.definition) {
      mismatches.add(
          'Element definition mismatch: Expected "$definition", found "${other.definition}".');
    }

    return mismatches;
  }
}

/// Comparison methods for [ForeignKeyDefinition].
extension ForeignKeyComparisons on ForeignKeyDefinition {
  /// Compares this foreign key definition with [other], returning a list of mismatches.
  /// Returns an empty list if the foreign keys are identical.
  List<String> like(ForeignKeyDefinition other, {bool ignoreCase = false}) {
    List<String> mismatches = [];

    if (ignoreCase) {
      if (constraintName.toLowerCase() != other.constraintName.toLowerCase()) {
        mismatches.add(
            'Constraint name mismatch: Expected "$constraintName", found "${other.constraintName}".');
      }
    } else {
      if (constraintName != other.constraintName) {
        mismatches.add(
            'Constraint name mismatch: Expected "$constraintName", found "${other.constraintName}".');
      }
    }

    if (!const ListEquality().equals(columns, other.columns)) {
      mismatches.add(
          'Columns mismatch: Expected "$columns", found "${other.columns}".');
    }

    if (referenceTable != other.referenceTable) {
      mismatches.add(
          'Reference table mismatch: Expected "$referenceTable", found "${other.referenceTable}".');
    }

    if (referenceTableSchema != other.referenceTableSchema) {
      mismatches.add(
          'Reference schema mismatch: Expected "$referenceTableSchema", found "${other.referenceTableSchema}".');
    }

    if (!const ListEquality()
        .equals(referenceColumns, other.referenceColumns)) {
      mismatches.add(
          'Reference columns mismatch: Expected "$referenceColumns", found "${other.referenceColumns}".');
    }

    if (onUpdate != other.onUpdate) {
      mismatches.add(
          'OnUpdate action mismatch: Expected "$onUpdate", found "${other.onUpdate}".');
    }

    if (onDelete != other.onDelete) {
      mismatches.add(
          'OnDelete action mismatch: Expected "$onDelete", found "${other.onDelete}".');
    }

    if (matchType != null &&
        other.matchType != null &&
        matchType != other.matchType) {
      mismatches.add(
          'Match type mismatch: Expected "$matchType", found "${other.matchType}".');
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
  String interval = '${duration.inDays} days '
      '${duration.inHours.remainder(24)} hours '
      '${duration.inMinutes.remainder(60)} minutes '
      '${duration.inSeconds.remainder(60)} seconds '
      '${duration.inMilliseconds.remainder(1000)} milliseconds '
      '${duration.inMicroseconds.remainder(1000)} microseconds';
  return 'INTERVAL \'$interval\'';
}

extension _ColumnTypeComparison on ColumnType {
  bool like(ColumnType other) {
    // Integer and bigint are considered the same type.
    if ((this == ColumnType.integer && other == ColumnType.bigint) ||
        (this == ColumnType.bigint && other == ColumnType.integer)) {
      return true;
    }

    return this == other;
  }
}
