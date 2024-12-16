import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';

/// Comparison methods for [ColumnDefinition].
extension ColumnComparisons on ColumnDefinition {
  /// Compares this column definition with [other], returning a list of mismatches.
  List<ColumnComparisonWarning> like(ColumnDefinition other) {
    List<ColumnComparisonWarning> mismatches = [];

    // Check if the name mismatch.
    if (name != other.name) {
      mismatches.add(ColumnComparisonWarning.nameMismatch(this, other));
    }

    // Check if the type mismatch.
    if (!columnType.like(other.columnType)) {
      mismatches.add(ColumnComparisonWarning.typeMismatch(this, other));
    }

    // Check if the isNullable mismatch.
    if (isNullable != other.isNullable) {
      mismatches.add(ColumnComparisonWarning.isNullableMismatch(this, other));
    }

    // Check if the default value mismatch.
    if (columnDefault != other.columnDefault) {
      mismatches.add(ColumnComparisonWarning.defaultValueMismatch(this, other));
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
