import 'package:collection/collection.dart' show ListEquality;
import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';

/// Comparison methods for [ForeignKeyDefinition].
extension ForeignKeyComparisons on ForeignKeyDefinition {
  /// Compares this foreign key definition with [other], returning a list of mismatches.
  List<ForeignKeyComparisonWarning> like(
    ForeignKeyDefinition other, {
    bool ignoreCase = false,
  }) {
    List<ForeignKeyComparisonWarning> mismatches = [];

    // Check if the name mismatch.
    var ignoreCaseMismatch = ignoreCase &&
        constraintName.toLowerCase() != other.constraintName.toLowerCase();

    var caseSensitiveMismatch =
        !ignoreCase && constraintName != other.constraintName;

    if (ignoreCaseMismatch || caseSensitiveMismatch) {
      mismatches.add(ForeignKeyComparisonWarning.nameMismatch(this, other));
    }

    // Check if the columns mismatch.
    var columnsMatch = const ListEquality().equals(columns, other.columns);
    if (!columnsMatch) {
      mismatches.add(ForeignKeyComparisonWarning.columnsMismatch(this, other));
    }

    // Check if the reference table mismatch.
    if (referenceTable != other.referenceTable) {
      mismatches
          .add(ForeignKeyComparisonWarning.referenceTableMismatch(this, other));
    }

    // Check if the reference table schema mismatch.
    if (referenceTableSchema != other.referenceTableSchema) {
      mismatches.add(
        ForeignKeyComparisonWarning.referenceTableSchemaMismatch(this, other),
      );
    }

    // Check if the reference columns mismatch.
    var referenceColumnsMatch =
        const ListEquality().equals(referenceColumns, other.referenceColumns);

    if (!referenceColumnsMatch) {
      mismatches.add(
        ForeignKeyComparisonWarning.referenceColumnsMismatch(this, other),
      );
    }

    // Check if the onUpdate mismatch.
    if (onUpdate != other.onUpdate) {
      mismatches.add(ForeignKeyComparisonWarning.onUpdateMismatch(this, other));
    }

    // Check if the onDelete mismatch.
    if (onDelete != other.onDelete) {
      mismatches.add(ForeignKeyComparisonWarning.onDeleteMismatch(this, other));
    }

    // Check if the matchType mismatch.
    var matchTypeMismatch = matchType != null &&
        other.matchType != null &&
        matchType != other.matchType;

    if (matchTypeMismatch) {
      mismatches
          .add(ForeignKeyComparisonWarning.matchTypeMismatch(this, other));
    }

    return mismatches;
  }
}
