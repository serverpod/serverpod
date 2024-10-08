import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';

void main() {
  group('ComparisonWarning toString output', () {
    test(
      'Given a column with no subs when toString is called then the correct output is returned',
      () {
        var warning = ColumnComparisonWarning(
          name: 'age',
          expected: 'age',
          found: null,
        );

        expect(
          warning.toString(),
          equals(
            '''Missing Column "age".''',
          ),
        );
      },
    );

    test(
      'Given a column with one sub when toString is called then the correct output is returned',
      () {
        var subWarning = ColumnComparisonWarning(
          name: 'firstname',
          expected: 'integer',
          found: 'text',
        );

        var warning =
            ColumnComparisonWarning(name: 'firstname').addSub(subWarning);

        expect(
          warning.toString(),
          equals(
            '''Column "firstname" mismatch: 
   - expected firstname "integer", found "text".''',
          ),
        );
      },
    );

    test(
      'Given a column with multiple subs when toString is called then the correct output is returned',
      () {
        var subWarning1 = ColumnComparisonWarning(
          name: 'firstname',
          expected: 'integer',
          found: 'text',
        );

        var subWarning2 = ColumnComparisonWarning(
          name: 'nullability',
          expected: 'false',
          found: 'true',
        );

        var warning = ColumnComparisonWarning(name: 'firstname')
            .addSubs([subWarning1, subWarning2]);

        expect(
          warning.toString(),
          equals(
            '''Column "firstname" mismatch: 
   - expected firstname "integer", found "text".
   - expected nullability "false", found "true".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with no subs when toString is called then the correct output is returned',
      () {
        var warning = ForeignKeyComparisonWarning(
          name: 'fk_user',
          expected: 'fk_user',
          found: null,
        );

        expect(
          warning.toString(),
          equals(
            '''Missing Foreign key "fk_user".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with one sub when toString is called then the correct output is returned',
      () {
        var subWarning = ForeignKeyComparisonWarning(
          name: 'onUpdate',
          expected: 'noAction',
          found: 'cascade',
        );

        var warning =
            ForeignKeyComparisonWarning(name: 'fk_user').addSub(subWarning);

        expect(
          warning.toString(),
          equals(
            '''Foreign key "fk_user" mismatch: 
   - expected onUpdate "noAction", found "cascade".''',
          ),
        );
      },
    );

    test(
      'Given a foreign key with multiple subs when toString is called then the correct output is returned',
      () {
        var subWarning1 = ForeignKeyComparisonWarning(
          name: 'onUpdate',
          expected: 'noAction',
          found: 'cascade',
        );

        var subWarning2 = ForeignKeyComparisonWarning(
          name: 'onDelete',
          expected: 'noAction',
          found: 'restrict',
        );

        var warning = ForeignKeyComparisonWarning(name: 'fk_user')
            .addSubs([subWarning1, subWarning2]);

        expect(
          warning.toString(),
          equals(
            '''Foreign key "fk_user" mismatch: 
   - expected onUpdate "noAction", found "cascade".
   - expected onDelete "noAction", found "restrict".''',
          ),
        );
      },
    );
  });
}
