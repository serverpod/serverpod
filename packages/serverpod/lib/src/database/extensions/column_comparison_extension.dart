import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';

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

    return mismatches;
  }
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
