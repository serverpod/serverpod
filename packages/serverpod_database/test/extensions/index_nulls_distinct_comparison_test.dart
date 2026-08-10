import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  final baseIndex = IndexDefinition(
    indexName: 'product_unique_idx',
    elements: [
      IndexElementDefinition(
        type: IndexElementDefinitionType.column,
        definition: 'archivedAt',
      ),
    ],
    type: 'btree',
    isUnique: true,
    isPrimary: false,
    nullsDistinct: null,
  );

  test(
    'Given indexes using implicit and explicit default null handling, '
    'when comparing their definitions, '
    'then they are equivalent.',
    () {
      var implicitDefault = baseIndex.copyWith(nullsDistinct: null);
      var explicitDefault = baseIndex.copyWith(nullsDistinct: true);

      var mismatches = implicitDefault.like(explicitDefault);

      expect(mismatches, isEmpty);
    },
  );

  test(
    'Given indexes with different effective null handling, '
    'when comparing their definitions, '
    'then the null handling mismatch is reported.',
    () {
      var nullsDistinct = baseIndex.copyWith(nullsDistinct: true);
      var nullsNotDistinct = baseIndex.copyWith(nullsDistinct: false);

      var mismatches = nullsDistinct.like(nullsNotDistinct);

      expect(
        mismatches.map((mismatch) => mismatch.name),
        contains('nullsDistinct'),
      );
    },
  );
}
