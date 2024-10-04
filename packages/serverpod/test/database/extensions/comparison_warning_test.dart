import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';

void main() {
  group('ComparisonWarning toString output', () {
    test(
      'Given a column with no subs when toString is called then the correct output is returned',
      () {
        var warning = ColumnComparisonWarning(
          mismatch: 'missing column',
          expected: 'age',
          found: 'none',
        );

        expect(
          warning.toString(),
          equals(
            '''Column missing column mismatch:
 - expected "age", found "none".''',
          ),
        );
      },
    );

    test(
      'Given a column with one sub when toString is called then the correct output is returned',
      () {
        var subWarning = ColumnComparisonWarning(
          mismatch: 'type',
          expected: 'integer',
          found: 'text',
        );

        var warning = ColumnComparisonWarning().addSub(subWarning);

        expect(
          warning.toString(),
          equals(
            '''Column mismatch:
   - type mismatch:
     - expected "integer", found "text".''',
          ),
        );
      },
    );

    test(
      'Given a column with multiple subs when toString is called then the correct output is returned',
      () {
        var subWarning1 = ColumnComparisonWarning(
          mismatch: 'type',
          expected: 'integer',
          found: 'text',
        );

        var subWarning2 = ColumnComparisonWarning(
          mismatch: 'nullability',
          expected: 'false',
          found: 'true',
        );

        var warning =
            ColumnComparisonWarning().addSubs([subWarning1, subWarning2]);

        expect(
          warning.toString(),
          equals(
            '''Column mismatch:
   - type mismatch:
     - expected "integer", found "text".
   - nullability mismatch:
     - expected "false", found "true".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with no subs when toString is called then the correct output is returned',
      () {
        var warning = ForeignKeyComparisonWarning(
          mismatch: 'missing foreign key',
          expected: 'fk_user',
          found: 'none',
        );

        expect(
          warning.toString(),
          equals(
            '''Foreign Key missing foreign key mismatch:
 - expected "fk_user", found "none".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with one sub when toString is called then the correct output is returned',
      () {
        var subWarning = ForeignKeyComparisonWarning(
          mismatch: 'onUpdate action',
          expected: 'noAction',
          found: 'cascade',
        );

        var warning = ForeignKeyComparisonWarning().addSub(subWarning);

        expect(
          warning.toString(),
          equals(
            '''Foreign Key mismatch:
   - onUpdate action mismatch:
     - expected "noAction", found "cascade".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with multiple subs when toString is called then the correct output is returned',
      () {
        var subWarning1 = ForeignKeyComparisonWarning(
          mismatch: 'onUpdate action',
          expected: 'noAction',
          found: 'cascade',
        );

        var subWarning2 = ForeignKeyComparisonWarning(
          mismatch: 'onDelete action',
          expected: 'noAction',
          found: 'restrict',
        );

        var warning =
            ForeignKeyComparisonWarning().addSubs([subWarning1, subWarning2]);

        expect(
          warning.toString(),
          equals(
            '''Foreign Key mismatch:
   - onUpdate action mismatch:
     - expected "noAction", found "cascade".
   - onDelete action mismatch:
     - expected "noAction", found "restrict".''',
          ),
        );
      },
    );
  });
}
