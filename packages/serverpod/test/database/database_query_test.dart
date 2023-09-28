import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

void main() {
  group('Given SelectQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = SelectQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT * FROM "citizen"');
    });

    test('when query with specific fields is built then output selects fields.',
        () {
      var fields = [
        ColumnString('id', queryPrefix: 'citizen'),
        ColumnString('name', queryPrefix: 'citizen'),
        ColumnString('age', queryPrefix: 'citizen'),
      ];
      var query =
          SelectQueryBuilder(table: 'citizen').withSelectFields(fields).build();

      expect(query,
          'SELECT citizen."id" AS "citizen.id", citizen."name" AS "citizen.name", citizen."age" AS "citizen.age" FROM "citizen"');
    });

    test(
        'when query with simple where expression is built then output is a WHERE query.',
        () {
      var query = SelectQueryBuilder(table: 'citizen')
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query, 'SELECT * FROM "citizen" WHERE "test"=@test');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var expression1 = const Expression('TRUE = TRUE');
      var expression2 = const Expression('FALSE = FALSE');
      var combinedExpression = expression1 & expression2;

      var query = SelectQueryBuilder(table: 'citizen')
          .withWhere(combinedExpression)
          .build();

      expect(query,
          'SELECT * FROM "citizen" WHERE (TRUE = TRUE AND FALSE = FALSE)');
    });

    test(
        'when query with single order by is built then output is single order by query.',
        () {
      var table = 'citizen';
      Order order = Order(
        column: ColumnString('id', queryPrefix: table),
        orderDescending: false,
      );

      var query = SelectQueryBuilder(table: table).withOrderBy([order]).build();

      expect(query, 'SELECT * FROM "citizen" ORDER BY citizen."id"');
    });

    test(
        'when query with multiple order by is built then output is query with multiple order by requirements.',
        () {
      var table = 'citizen';
      var orders = [
        Order(
          column: ColumnString('id', queryPrefix: table),
          orderDescending: false,
        ),
        Order(
          column: ColumnString('name', queryPrefix: table),
          orderDescending: true,
        ),
        Order(
          column: ColumnString('age', queryPrefix: table),
          orderDescending: false,
        )
      ];

      var query =
          SelectQueryBuilder(table: 'citizen').withOrderBy(orders).build();

      expect(query,
          'SELECT * FROM "citizen" ORDER BY citizen."id", citizen."name" DESC, citizen."age"');
    });

    test('when query with limit is built then output is query with limit.', () {
      var query = SelectQueryBuilder(table: 'citizen').withLimit(10).build();

      expect(query, 'SELECT * FROM "citizen" LIMIT 10');
    });

    test('when query with offset is built then output is query with offset.',
        () {
      var query = SelectQueryBuilder(table: 'citizen').withOffset(10).build();

      expect(query, 'SELECT * FROM "citizen" OFFSET 10');
    });

    test(
        'when where expression depends on relations then output includes joins according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = SelectQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForColumn,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                )
              ]).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT * FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForTable = 'citizen_company_company';
      var queryPrefixForNested = 'citizen_company_company_ceo_';
      var queryPrefixForNestedTable = 'citizen_company_company_ceo_citizen';
      var query = SelectQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForNestedTable,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                ),
                TableRelation.foreign(
                  foreignTableName: 'citizen',
                  column: ColumnInt('ceoId', queryPrefix: queryPrefixForTable),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefixForNested,
                ),
              ]).equals('Alex'))
          .build();

      expect(query,
          'SELECT * FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN "citizen" AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test(
        'when ordering by an aggregate column then output joins and orders by aggregated column.',
        () {
      var innerWhere = Constant.bool(true);
      var table = 'company';
      var queryPrefix = '${table}_employees_';
      var queryPrefixForColumn = '${queryPrefix}citizen';
      var query = SelectQueryBuilder(table: table).withSelectFields(
          [ColumnString('name', queryPrefix: table)]).withOrderBy([
        Order(
            column: ColumnCountAggregate(
          'companyId',
          queryPrefix: queryPrefixForColumn,
          tableRelations: [
            TableRelation.foreign(
              foreignTableName: 'citizen',
              column: ColumnInt('id', queryPrefix: table),
              foreignColumnName: 'companyId',
              relationQueryPrefix: queryPrefix,
            )
          ],
          innerWhere: innerWhere,
        ))
      ]).build();

      expect(query,
          'SELECT company."name" AS "company.name" FROM "company" LEFT JOIN "citizen" AS company_employees_citizen ON company."id" = company_employees_citizen."companyId" GROUP BY "company.name" ORDER BY COUNT(company_employees_citizen."companyId")');
    });

    test(
        'when where expression is aggregate column then output includes HAVING and GROUP BY in query.',
        () {
      var innerWhere = Constant.bool(true);
      var table = 'company';
      var queryPrefix = '${table}_employees_';
      var queryPrefixForColumn = '${queryPrefix}citizen';
      var query = SelectQueryBuilder(table: table)
          .withSelectFields([ColumnString('name', queryPrefix: table)])
          .withWhere(ColumnCountAggregate(
            'companyId',
            queryPrefix: queryPrefixForColumn,
            innerWhere: innerWhere,
            tableRelations: [
              TableRelation.foreign(
                foreignTableName: 'citizen',
                column: ColumnInt('id', queryPrefix: table),
                foreignColumnName: 'companyId',
                relationQueryPrefix: queryPrefix,
              )
            ],
          ).equals(10))
          .build();

      expect(query,
          'SELECT company."name" AS "company.name" FROM "company" LEFT JOIN "citizen" AS company_employees_citizen ON company."id" = company_employees_citizen."companyId" WHERE TRUE GROUP BY "company.name" HAVING COUNT(company_employees_citizen."companyId") = 10');
    });

    test('when all properties configured is built then output is valid SQL.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var innerWhere = Constant.bool(true);
      var query = SelectQueryBuilder(table: table)
          .withSelectFields([
            ColumnString('id', queryPrefix: table),
            ColumnString('name', queryPrefix: table),
            ColumnString('age', queryPrefix: table),
          ])
          .withWhere(
            ColumnString('name',
                    queryPrefix: queryPrefixForColumn,
                    tableRelations: [
                      TableRelation.foreign(
                        foreignTableName: 'company',
                        column: ColumnInt('companyId', queryPrefix: table),
                        foreignColumnName: 'id',
                        relationQueryPrefix: queryPrefix,
                      )
                    ]).equals('Serverpod') &
                ColumnCountAggregate(
                  'citizenId',
                  queryPrefix: queryPrefixForColumn,
                  innerWhere: innerWhere,
                  tableRelations: [
                    TableRelation.foreign(
                      foreignTableName: 'company',
                      column: ColumnInt('companyId', queryPrefix: table),
                      foreignColumnName: 'id',
                      relationQueryPrefix: queryPrefix,
                    )
                  ],
                ).equals(10),
          )
          .withOrderBy([
            Order(
                column: ColumnString('id', queryPrefix: table),
                orderDescending: true)
          ])
          .withLimit(10)
          .withOffset(5)
          .build();

      expect(query,
          'SELECT citizen."id" AS "citizen.id", citizen."name" AS "citizen.name", citizen."age" AS "citizen.age" FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE (citizen_company_company."name" = \'Serverpod\' AND TRUE) GROUP BY "citizen.id", "citizen.name", "citizen.age" HAVING COUNT(citizen_company_company."citizenId") = 10 ORDER BY citizen."id" DESC LIMIT 10 OFFSET 5');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var queryBuilder = SelectQueryBuilder(table: table).withWhere(
          ColumnString('name', queryPrefix: differentTable)
              .equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."name".'),
          )));
    });

    test('when order by has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var queryBuilder = SelectQueryBuilder(table: table).withOrderBy(
          [Order(column: ColumnString('name', queryPrefix: differentTable))]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"orderBy" expression referencing column company."name".'),
          )));
    });

    test(
        'when where expression is aggregate column with different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = const Expression('test');
      var queryBuilder = SelectQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('employees',
                  queryPrefix: differentTable, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column COUNT(company."employees").'),
          )));
    });

    test(
        'when where expression is aggregate column with inner where referencing other table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = ColumnBool('active', queryPrefix: differentTable).equals(
        false,
      );
      var queryBuilder = SelectQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('vehicles',
                  queryPrefix: table, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."active".'),
          )));
    });

    test(
        'when order by aggregate column that has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = const Expression('test');
      var queryBuilder = SelectQueryBuilder(table: table).withOrderBy([
        Order(
            column: ColumnCountAggregate('employees',
                queryPrefix: differentTable, innerWhere: innerWhere))
      ]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"orderBy" expression referencing column COUNT(company."employees").'),
          )));
    });

    test(
        'when order by aggregate column with inner where that has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = ColumnBool('active', queryPrefix: differentTable).equals(
        false,
      );
      var queryBuilder = SelectQueryBuilder(table: table).withOrderBy([
        Order(
            column: ColumnCountAggregate('vehicles',
                queryPrefix: table, innerWhere: innerWhere))
      ]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"orderBy" expression referencing column company."active".'),
          )));
    });
  });

  group('Given CountQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = CountQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT COUNT(citizen."id") FROM "citizen"');
    });
    test('when query with alias is built then count result has defined alias.',
        () {
      var query =
          CountQueryBuilder(table: 'citizen').withCountAlias('c').build();

      expect(query, 'SELECT COUNT(citizen."id") AS c FROM "citizen"');
    });

    test('when query with field is built then count is based on that field.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withField('age').build();

      expect(query, 'SELECT COUNT(citizen."age") FROM "citizen"');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = CountQueryBuilder(table: 'citizen')
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query,
          'SELECT COUNT(citizen."id") FROM "citizen" WHERE "test"=@test');
    });

    test('when query with limit is built then output is a query with limit.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withLimit(10).build();

      expect(query, 'SELECT COUNT(citizen."id") FROM "citizen" LIMIT 10');
    });

    test(
        'when where expression depends on relations then output includes joins according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = CountQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForColumn,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                )
              ]).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT COUNT(citizen."id") FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForTable = 'citizen_company_company';
      var queryPrefixForNested = 'citizen_company_company_ceo_';
      var queryPrefixForNestedTable = 'citizen_company_company_ceo_citizen';
      var query = CountQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForNestedTable,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                ),
                TableRelation.foreign(
                  foreignTableName: 'citizen',
                  column: ColumnInt('ceoId', queryPrefix: queryPrefixForTable),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefixForNested,
                ),
              ]).equals('Alex'))
          .build();

      expect(query,
          'SELECT COUNT(citizen."id") FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN "citizen" AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test(
        'when where expression is aggregate column then output includes HAVING and GROUP BY in query.',
        () {
      var innerWhere = Constant.bool(true);
      var table = 'company';
      var queryPrefix = '${table}_employees_';
      var queryPrefixForColumn = '${queryPrefix}citizen';
      var query = CountQueryBuilder(table: table)
          .withWhere(ColumnCountAggregate(
            'companyId',
            queryPrefix: queryPrefixForColumn,
            innerWhere: innerWhere,
            tableRelations: [
              TableRelation.foreign(
                foreignTableName: 'citizen',
                column: ColumnInt('id', queryPrefix: table),
                foreignColumnName: 'companyId',
                relationQueryPrefix: queryPrefix,
              )
            ],
          ).equals(10))
          .build();

      expect(query,
          'SELECT COUNT(company."id") FROM "company" LEFT JOIN "citizen" AS company_employees_citizen ON company."id" = company_employees_citizen."companyId" WHERE TRUE GROUP BY company."id" HAVING COUNT(company_employees_citizen."companyId") = 10');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var innerWhere = Constant.bool(true);
      var query = CountQueryBuilder(table: table)
          .withCountAlias('c')
          .withField('id')
          .withWhere(ColumnString('name',
                  queryPrefix: queryPrefixForColumn,
                  tableRelations: [
                    TableRelation.foreign(
                      foreignTableName: 'company',
                      column: ColumnInt('companyId', queryPrefix: table),
                      foreignColumnName: 'id',
                      relationQueryPrefix: queryPrefix,
                    )
                  ]).equals('Serverpod') &
              ColumnCountAggregate(
                'companyId',
                queryPrefix: queryPrefixForColumn,
                innerWhere: innerWhere,
                tableRelations: [
                  TableRelation.foreign(
                    foreignTableName: 'citizen',
                    column: ColumnInt('id', queryPrefix: table),
                    foreignColumnName: 'companyId',
                    relationQueryPrefix: queryPrefix,
                  )
                ],
              ).equals(10))
          .withLimit(10)
          .build();

      expect(query,
          'SELECT COUNT(citizen."id") AS c FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN "citizen" AS citizen_company_citizen ON citizen."id" = citizen_company_citizen."companyId" WHERE (citizen_company_company."name" = \'Serverpod\' AND TRUE) GROUP BY citizen."id" HAVING COUNT(citizen_company_company."companyId") = 10 LIMIT 10');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var queryBuilder = CountQueryBuilder(table: table).withWhere(
          ColumnString('name', queryPrefix: differentTable)
              .equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."name".'),
          )));
    });

    test(
        'when where expression is aggregate column with different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = const Expression('test');
      var queryBuilder = CountQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('employees',
                  queryPrefix: differentTable, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column COUNT(company."employees").'),
          )));
    });

    test(
        'when where expression is aggregate column with inner where referencing other table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = ColumnBool('active', queryPrefix: differentTable).equals(
        false,
      );
      var queryBuilder = CountQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('vehicles',
                  queryPrefix: table, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."active".'),
          )));
    });
  });

  group('Given DeleteQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = DeleteQueryBuilder(table: 'citizen').build();

      expect(query, 'DELETE FROM "citizen"');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = DeleteQueryBuilder(table: 'citizen')
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query, 'DELETE FROM "citizen" WHERE "test"=@test');
    });

    test('when query returning all is built then output is a return all query.',
        () {
      var query = DeleteQueryBuilder(table: 'citizen').withReturnAll().build();

      expect(query, 'DELETE FROM "citizen" RETURNING *');
    });

    test(
        'when where expression depends on relations then output includes using according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = DeleteQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForColumn,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                )
              ]).equals('Serverpod'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id"');
    });

    test(
        'when where expression depends on nested relations then output includes using according to table relations.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForTable = 'citizen_company_company';
      var queryPrefixForNested = 'citizen_company_company_ceo_';
      var queryPrefixForNestedTable = 'citizen_company_company_ceo_citizen';
      var query = DeleteQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForNestedTable,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                ),
                TableRelation.foreign(
                  foreignTableName: 'citizen',
                  column: ColumnInt('ceoId', queryPrefix: queryPrefixForTable),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefixForNested,
                ),
              ]).equals('Alex'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company, "citizen" AS citizen_company_company_ceo_citizen WHERE citizen_company_company_ceo_citizen."name" = \'Alex\' AND citizen."companyId" = citizen_company_company."id" AND citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id"');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = DeleteQueryBuilder(table: table)
          .withWhere(ColumnString('name',
              queryPrefix: queryPrefixForColumn,
              tableRelations: [
                TableRelation.foreign(
                  foreignTableName: 'company',
                  column: ColumnInt('companyId', queryPrefix: table),
                  foreignColumnName: 'id',
                  relationQueryPrefix: queryPrefix,
                )
              ]).equals('Serverpod'))
          .withReturnAll()
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id" RETURNING *');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var queryBuilder = DeleteQueryBuilder(table: table).withWhere(
          ColumnString('name', queryPrefix: differentTable)
              .equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."name".'),
          )));
    });

    test(
        'when where expression is aggregate column with different table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = const Expression('test');
      var queryBuilder = DeleteQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('employees',
                  queryPrefix: differentTable, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column COUNT(company."employees").'),
          )));
    });

    test(
        'when where expression is aggregate column with inner where referencing other table as base then exception is thrown.',
        () {
      var table = 'citizen';
      var differentTable = 'company';
      var innerWhere = ColumnBool('active', queryPrefix: differentTable).equals(
        false,
      );
      var queryBuilder = DeleteQueryBuilder(table: table).withWhere(
          ColumnCountAggregate('vehicles',
                  queryPrefix: table, innerWhere: innerWhere)
              .equals(10));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."active".'),
          )));
    });
  });
}
