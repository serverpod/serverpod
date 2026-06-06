import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

import '../test_util/many_relation_builder.dart';
import '../test_util/table_relation_builder.dart';

// Regression tests for https://github.com/serverpod/serverpod/issues/5294
// Negating (~) a many-relation filter (none/any/count/every) must wrap the
// already subquery-resolved predicate, NOT re-emit the raw inner expression
// (which references the relation alias only defined inside the CTE).
//
// All outer-query assertions are anchored on `FROM "citizen" WHERE NOT (` so
// they target the OUTER query (the CTE body uses `FROM "citizen" LEFT JOIN`,
// never `FROM "citizen" WHERE`). They intentionally avoid a naive substring
// search for the junction alias `citizen_company_company`, which legitimately
// appears both inside the CTE body and in the CTE's own alias.
void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  var citizenTable = Table<int?>(tableName: 'citizen');
  var companyTable = Table<int?>(tableName: 'company');
  var relationTable = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(citizenTable, 'company'),
  ]).build();
  var manyRelation = ManyRelationBuilder(relationTable).build();

  // The buggy output referenced the junction alias directly in the outer
  // query, e.g. `FROM "citizen" WHERE NOT "citizen_company_company"."id" ...`.
  var brokenOuterSignature =
      'FROM "citizen" WHERE NOT "citizen_company_company"';

  group('Given SelectQueryBuilder with a NOT wrapped many relation filter', () {
    test('when filtering on NOT none() then the outer query negates the '
        'subquery membership instead of referencing the relation alias', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(~manyRelation.none()).build();

      expect(
        query,
        contains('FROM "citizen" WHERE NOT ("citizen"."id" NOT IN (SELECT'),
      );
      expect(query, isNot(contains(brokenOuterSignature)));
    });

    test('when filtering on NOT any() then the outer query negates the IN '
        'subquery membership', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(~manyRelation.any()).build();

      expect(
        query,
        contains('FROM "citizen" WHERE NOT ("citizen"."id" IN (SELECT'),
      );
      expect(query, isNot(contains(brokenOuterSignature)));
    });

    test(
      'when filtering on NOT count() > 3 then the aggregate stays in the '
      'CTE HAVING and the outer query negates the IN subquery membership',
      () {
        var query = SelectQueryBuilder(
          table: citizenTable,
        ).withWhere(~(manyRelation.count() > 3)).build();

        expect(
          query,
          contains('FROM "citizen" WHERE NOT ("citizen"."id" IN (SELECT'),
        );
        // The aggregate must remain confined to the CTE's HAVING clause.
        expect(query, contains('HAVING COUNT('));
        // ...and must never leak into the outer WHERE (no aggregate-in-WHERE).
        var outerWhere = query.substring(query.indexOf('FROM "citizen" WHERE'));
        expect(outerWhere, isNot(contains('COUNT(')));
        expect(query, isNot(contains(brokenOuterSignature)));
      },
    );

    test('when filtering on NOT every() then the outer query negates the NOT '
        'IN subquery membership', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(~manyRelation.every((t) => t.id.equals(1))).build();

      expect(
        query,
        contains('FROM "citizen" WHERE NOT ("citizen"."id" NOT IN (SELECT'),
      );
      expect(query, isNot(contains(brokenOuterSignature)));
    });

    test('when filtering on NOT of a combined scalar AND none() then the outer '
        'NOT wraps the whole De Morgan group', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(~(citizenTable.id.equals(1) & manyRelation.none())).build();

      expect(
        query,
        contains(
          'FROM "citizen" WHERE NOT (("citizen"."id" = 1 AND '
          '"citizen"."id" NOT IN (SELECT',
        ),
      );
      expect(query, isNot(contains(brokenOuterSignature)));
    });

    test('when double negating none() then both NOT layers resolve and the '
        'inner subquery membership is still referenced', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(~~manyRelation.none()).build();

      expect(
        query,
        contains(
          'FROM "citizen" WHERE NOT (NOT ("citizen"."id" NOT IN (SELECT',
        ),
      );
      expect(query, isNot(contains(brokenOuterSignature)));
    });

    test('when negating an outer filter that contains an inner NOT inside the '
        'relation filter then the inner NOT stays inside the CTE', () {
      var query = SelectQueryBuilder(
        table: citizenTable,
      ).withWhere(manyRelation.none((t) => ~t.id.equals(5))).build();

      // The inner ~ is emitted inside the CTE, where the relation alias is in
      // scope, so referencing the alias there is correct (not a leak).
      expect(query, contains('NOT ("citizen_company_company"."id" = 5)'));
      // The outer query (no outer NOT here) still uses the plain NOT IN form.
      expect(
        query,
        contains('FROM "citizen" WHERE "citizen"."id" NOT IN (SELECT'),
      );
    });
  });
}
