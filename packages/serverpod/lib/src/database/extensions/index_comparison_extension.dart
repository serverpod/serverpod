import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';

/// Comparison methods for [IndexDefinition].
extension IndexComparisons on IndexDefinition {
  /// Compares this index definition with [other], returning a list of mismatches.
  List<IndexComparisonWarning> like(
    IndexDefinition other, {
    bool ignoreCase = false,
  }) {
    List<IndexComparisonWarning> mismatches = [];

    // Check if the name mismatch.
    var ignoreCaseMismatch =
        ignoreCase && indexName.toLowerCase() != other.indexName.toLowerCase();
    var caseSensitiveMismatch = !ignoreCase && indexName != other.indexName;

    if (ignoreCaseMismatch || caseSensitiveMismatch) {
      mismatches.add(IndexComparisonWarning.nameMismatch(this, other));
    }

    // Check if the type mismatch.
    if (type != other.type) {
      mismatches.add(IndexComparisonWarning.typeMismatch(this, other));
    }

    // Check if the isUnique mismatch.
    if (isUnique != other.isUnique) {
      mismatches.add(IndexComparisonWarning.isUniqueMismatch(this, other));
    }

    // Check if the isPrimary mismatch.
    if (isPrimary != other.isPrimary) {
      mismatches.add(IndexComparisonWarning.isPrimaryMismatch(this, other));
    }

    // Check if the predicate mismatch.
    if (predicate != other.predicate) {
      mismatches.add(IndexComparisonWarning.predicateMismatch(this, other));
    }

    // Check if the tableSpace mismatch.
    if (tableSpace != other.tableSpace) {
      mismatches.add(IndexComparisonWarning.tableSpaceMismatch(this, other));
    }

    // Check if the elements mismatch.
    if (elements.length != other.elements.length) {
      mismatches.add(IndexComparisonWarning.elementsMismatch(this, other));
    } else {
      for (int i = 0; i < elements.length; i++) {
        mismatches.addAll(elements[i].like(other.elements[i]));
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
      mismatches.add(IndexComparisonWarning.elementTypeMismatch(this, other));
    }

    if (definition != other.definition) {
      mismatches
          .add(IndexComparisonWarning.elementDefinitionMismatch(this, other));
    }

    return mismatches;
  }
}
