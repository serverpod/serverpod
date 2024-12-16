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

    if (referenceTableSchema != other.referenceTableSchema) {
      mismatches.add(
        ForeignKeyComparisonWarning(
          name: 'reference schema',
          expected: referenceTableSchema,
          found: other.referenceTableSchema,
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