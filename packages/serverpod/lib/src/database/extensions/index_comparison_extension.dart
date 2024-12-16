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
