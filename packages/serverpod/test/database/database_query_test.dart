import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

class _TableWithoutFields extends Table {
  _TableWithoutFields() : super(tableName: 'table');

  @override
  List<Column> get columns => [];
}

class _TableWithManyRelation extends Table {
  final String _relationAlias;
  _TableWithManyRelation(
      {required String relationAlias,
      required super.tableName,
      super.tableRelation})
      : _relationAlias = relationAlias;

  ManyRelation<_TableWithManyRelation>? _manyRelation;
  ManyRelation<_TableWithManyRelation> get manyRelation {
    if (_manyRelation != null) return _manyRelation!;

    var relationTable = createRelationTable(
      relationFieldName: _relationAlias,
      field: id,
      foreignField:
          id /* This should really be something different than the "id" column but by reusing it we are saved from creating a different table. */,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _TableWithManyRelation(
        relationAlias: _relationAlias,
        tableName: tableName,
        tableRelation: foreignTableRelation,
      ),
    );

    _manyRelation = ManyRelation<_TableWithManyRelation>(
        tableWithRelations: relationTable,
        table: _TableWithManyRelation(
          relationAlias: _relationAlias,
          tableName: tableName,
        ));
    return _manyRelation!;
  }

  @override
  List<Column> get columns => [id];
}

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');

  group('Given SelectQueryBuilder', () {
    test(
        'when initialized with table without fields then argument error is thrown',
        () {
      expect(
          () => SelectQueryBuilder(table: _TableWithoutFields()),
          throwsA(isA<ArgumentError>().having(
            (e) => e.toString(),
            'message',
            equals(
                'Invalid argument (table): Must have at least one column: Instance of \'_TableWithoutFields\''),
          )));
    });

    test(
        'when trying to set select fields to empty list then argument error is thrown',
        () {
      expect(
          () => SelectQueryBuilder(table: citizenTable).withSelectFields([]),
          throwsA(isA<ArgumentError>().having(
            (e) => e.toString(),
            'message',
            equals(
                'Invalid argument (fields): Cannot be empty: Instance(length:0) of \'_GrowableList\''),
          )));
    });

    test('when default initialized then build outputs a valid SQL query.', () {
      var query = SelectQueryBuilder(table: citizenTable).build();

      expect(query, 'SELECT "citizen"."id" AS "citizen.id" FROM "citizen"');
    });

    test('when query with specific fields is built then output selects fields.',
        () {
      var fields = [
        ColumnString('id', citizenTable),
        ColumnString('name', citizenTable),
        ColumnString('age', citizenTable),
      ];
      var query = SelectQueryBuilder(table: citizenTable)
          .withSelectFields(fields)
          .build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id", "citizen"."name" AS "citizen.name", "citizen"."age" AS "citizen.age" FROM "citizen"');
    });

    test(
        'when query with simple where expression is built then output is a WHERE query.',
        () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "test"=@test');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var expression1 = const Expression('TRUE = TRUE');
      var expression2 = const Expression('FALSE = FALSE');
      var combinedExpression = expression1 & expression2;

      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(combinedExpression)
          .build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE (TRUE = TRUE AND FALSE = FALSE)');
    });

    test(
        'when query with single order by is built then output is single order by query.',
        () {
      Order order = Order(
        column: ColumnString('id', citizenTable),
        orderDescending: false,
      );

      var query =
          SelectQueryBuilder(table: citizenTable).withOrderBy([order]).build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" ORDER BY "citizen"."id"');
    });

    test(
        'when query with multiple order by is built then output is query with multiple order by requirements.',
        () {
      var orders = [
        Order(
          column: ColumnString('id', citizenTable),
          orderDescending: false,
        ),
        Order(
          column: ColumnString('name', citizenTable),
          orderDescending: true,
        ),
        Order(
          column: ColumnString('age', citizenTable),
          orderDescending: false,
        )
      ];

      var query =
          SelectQueryBuilder(table: citizenTable).withOrderBy(orders).build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" ORDER BY "citizen"."id", "citizen"."name" DESC, "citizen"."age"');
    });

    test(
        'when ordering by many relation then output is many relation order by query.',
        () {
      var relationTable = _TableWithManyRelation(
        tableName: citizenTable.tableName,
        relationAlias: 'friends',
      );
      Order order = Order(
        column: relationTable.manyRelation.count(),
        orderDescending: false,
      );

      var query =
          SelectQueryBuilder(table: relationTable).withOrderBy([order]).build();

      expect(
        query,
        'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."id" GROUP BY "citizen"."id" ORDER BY COUNT("citizen_friends_citizen"."id")',
      );
    });

    test(
        'when ordering by is filtered many relation then output contains many relation sub query.',
        () {
      var relationTable = _TableWithManyRelation(
        tableName: citizenTable.tableName,
        relationAlias: 'friends',
      );
      Order order = Order(
        column: relationTable.manyRelation.count((t) => t.id.equals(5)),
        orderDescending: false,
      );

      var query =
          SelectQueryBuilder(table: citizenTable).withOrderBy([order]).build();

      expect(query,
          'WITH "citizen_friends_citizen" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."id" = 5) SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."citizen.id" GROUP BY "citizen"."id" ORDER BY COUNT("citizen_friends_citizen"."citizen.id")');
    });

    test('when query with limit is built then output is query with limit.', () {
      var query = SelectQueryBuilder(table: citizenTable).withLimit(10).build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LIMIT 10');
    });

    test('when query with offset is built then output is query with offset.',
        () {
      var query =
          SelectQueryBuilder(table: citizenTable).withOffset(10).build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" OFFSET 10');
    });

    test(
        'when where expression depends on relations then output includes joins according to table relations.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" WHERE "citizen_company_company"."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationAlias: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(ColumnString(
            'name',
            nestedRelationTable,
          ).equals('Alex'))
          .build();

      expect(query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" LEFT JOIN "citizen" AS "citizen_company_company_ceo_citizen" ON "citizen_company_company"."ceoId" = "citizen_company_company_ceo_citizen"."id" WHERE "citizen_company_company_ceo_citizen"."name" = \'Alex\'');
    });

    test('when all properties configured is built then output is valid SQL.',
        () {
      var manyRelationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'companiesOwned',
            field: ColumnInt('id', citizenTable),
            foreignField: ColumnInt(
                'id' /* This should be 'companyOwnerId' but by using id this saves us from creating a test class */,
                companyTable),
          )
        ]),
      );
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable)
          .withSelectFields([
            ColumnString('id', citizenTable),
            ColumnString('name', citizenTable),
            ColumnString('age', citizenTable),
          ])
          .withWhere(ColumnString(
            'name',
            relationTable,
          ).equals('Serverpod'))
          .withOrderBy([
            Order(
              column: ColumnString('id', citizenTable),
              orderDescending: true,
            ),
            Order(
                column: ColumnCount(
              companyTable.id.equals(5),
              companyTable,
              manyRelationTable.id,
            ))
          ])
          .withLimit(10)
          .withOffset(5)
          .build();

      expect(query,
          'WITH "citizen_companiesOwned_company" AS (SELECT "company"."id" AS "company.id" FROM "company" WHERE "company"."id" = 5) SELECT "citizen"."id" AS "citizen.id", "citizen"."name" AS "citizen.name", "citizen"."age" AS "citizen.age" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" LEFT JOIN "citizen_companiesOwned_company" ON "citizen"."id" = "citizen_companiesOwned_company"."company.id" WHERE "citizen_company_company"."name" = \'Serverpod\' GROUP BY "citizen"."id", "citizen"."name", "citizen"."age" ORDER BY "citizen"."id" DESC, COUNT("citizen_companiesOwned_company"."company.id") LIMIT 10 OFFSET 5');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = SelectQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column "company"."name".'),
          )));
    });

    test('when order by has different table as base then exception is thrown.',
        () {
      var queryBuilder = SelectQueryBuilder(table: citizenTable)
          .withOrderBy([Order(column: ColumnString('name', companyTable))]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"orderBy" expression referencing column "company"."name".'),
          )));
    });

    test(
        'when count column with inner where that does NOT have table relations then exception is thrown.',
        () {
      var countColumn =
          ColumnCount(citizenTable.id.equals(5), citizenTable, citizenTable.id);
      var queryBuilder = SelectQueryBuilder(table: citizenTable).withOrderBy([
        Order(
          column: countColumn,
        )
      ]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<ArgumentError>().having(
            (e) => e.toString(),
            'message',
            equals(
                'Invalid argument(s) (countColumn.table.tableRelation): Must not be null'),
          )));
    });

    test(
        'when same count column with inner where appears multiple times then exception is thrown.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var countColumn = ColumnCount(
          companyTable.id.equals(5), companyTable, relationTable.id);
      expect(
          () => SelectQueryBuilder(table: citizenTable).withOrderBy([
                Order(column: countColumn),
                Order(column: countColumn, orderDescending: true)
              ]),
          throwsA(isA<ArgumentError>().having(
            (e) => e.toString(),
            'message',
            equals(
                'Invalid argument(s): Ordering by same column multiple times: citizen_company_company.id'),
          )));
    });

    test(
        'when count column is used in where expression then exception is thrown.',
        () {
      var countColumn =
          ColumnCount(citizenTable.id.equals(5), citizenTable, citizenTable.id);
      var queryBuilder = SelectQueryBuilder(table: citizenTable)
          .withWhere(countColumn.equals(5));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Count columns are not supported in where expressions.'),
          )));
    });

    test(
        'when ordering by is filtered by nested many relation then exception is thrown.',
        () {
      var relationTable = _TableWithManyRelation(
        tableName: citizenTable.tableName,
        relationAlias: 'friends',
      );
      Order order = Order(
        column: relationTable.manyRelation
            .count((t) => t.manyRelation.count((t) => t.id.equals(5)) > 3),
        orderDescending: false,
      );

      expect(
          () => SelectQueryBuilder(table: citizenTable)
              .withOrderBy([order]).build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Count columns are not supported in where expressions.'),
          )));
    });

    test('when ordering by multiple many relations then exception is thrown.',
        () {
      var friendsRelationTable = _TableWithManyRelation(
        tableName: citizenTable.tableName,
        relationAlias: 'friends',
      );
      var enemiesRelationTable = _TableWithManyRelation(
        tableName: citizenTable.tableName,
        relationAlias: 'enemies',
      );

      List<Order> orderByList = [
        Order(
          column: friendsRelationTable.manyRelation.count(),
          orderDescending: false,
        ),
        Order(
          column: enemiesRelationTable.manyRelation.count(),
          orderDescending: false,
        )
      ];

      expect(
          () =>
              SelectQueryBuilder(table: citizenTable).withOrderBy(orderByList),
          throwsA(isA<UnimplementedError>().having(
            (e) => e.toString(),
            'message',
            equals(
              'UnimplementedError: Ordering by multiple many relation columns is not supported. Please file an issue at https://github.com/serverpod/serverpod/issues if you need this.',
            ),
          )));
    });
  });

  group('Given CountQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = CountQueryBuilder(table: citizenTable).build();

      expect(query, 'SELECT COUNT("citizen"."id") FROM "citizen"');
    });
    test('when query with alias is built then count result has defined alias.',
        () {
      var query =
          CountQueryBuilder(table: citizenTable).withCountAlias('c').build();

      expect(query, 'SELECT COUNT("citizen"."id") AS c FROM "citizen"');
    });

    test('when query with field is built then count is based on that field.',
        () {
      var query = CountQueryBuilder(table: citizenTable)
          .withField(ColumnInt('age', citizenTable))
          .build();

      expect(query, 'SELECT COUNT("citizen"."age") FROM "citizen"');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = CountQueryBuilder(table: citizenTable)
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query,
          'SELECT COUNT("citizen"."id") FROM "citizen" WHERE "test"=@test');
    });

    test('when query with limit is built then output is a query with limit.',
        () {
      var query = CountQueryBuilder(table: citizenTable).withLimit(10).build();

      expect(query, 'SELECT COUNT("citizen"."id") FROM "citizen" LIMIT 10');
    });

    test(
        'when where expression depends on relations then output includes joins according to table relations.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable)
          .withWhere(ColumnString(
            'name',
            relationTable,
          ).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT COUNT("citizen"."id") FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" WHERE "citizen_company_company"."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationAlias: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable)
          .withWhere(ColumnString(
            'name',
            nestedRelationTable,
          ).equals('Alex'))
          .build();

      expect(query,
          'SELECT COUNT("citizen"."id") FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" LEFT JOIN "citizen" AS "citizen_company_company_ceo_citizen" ON "citizen_company_company"."ceoId" = "citizen_company_company_ceo_citizen"."id" WHERE "citizen_company_company_ceo_citizen"."name" = \'Alex\'');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable)
          .withCountAlias('c')
          .withField(ColumnInt('age', citizenTable))
          .withWhere(
            ColumnString('name', relationTable).equals('Serverpod'),
          )
          .withLimit(10)
          .build();

      expect(query,
          'SELECT COUNT("citizen"."age") AS c FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."companyId" = "citizen_company_company"."id" WHERE "citizen_company_company"."name" = \'Serverpod\' LIMIT 10');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = CountQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column "company"."name".'),
          )));
    });

    test(
        'when count column is used in where expression then exception is thrown.',
        () {
      var countColumn =
          ColumnCount(citizenTable.id.equals(5), citizenTable, citizenTable.id);
      var queryBuilder = CountQueryBuilder(table: citizenTable)
          .withWhere(countColumn.equals(5));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Count columns are not supported in where expressions.'),
          )));
    });
  });

  group('Given DeleteQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = DeleteQueryBuilder(table: citizenTable).build();

      expect(query, 'DELETE FROM "citizen"');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query, 'DELETE FROM "citizen" WHERE "test"=@test');
    });

    test('when query returning all is built then output is a return all query.',
        () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withReturn(Returning.all)
          .build();

      expect(query, 'DELETE FROM "citizen" RETURNING *');
    });

    test('when query return id is build then the output is a return id query.',
        () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withReturn(Returning.id)
          .build();

      expect(query, 'DELETE FROM "citizen" RETURNING "citizen".id');
    });

    test(
        'when where expression depends on relations then output includes using according to table relations.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS "citizen_company_company" WHERE "citizen_company_company"."name" = \'Serverpod\' AND "citizen"."companyId" = "citizen_company_company"."id"');
    });

    test(
        'when where expression depends on nested relations then output includes using according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationAlias: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', nestedRelationTable).equals('Alex'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS "citizen_company_company", "citizen" AS "citizen_company_company_ceo_citizen" WHERE "citizen_company_company_ceo_citizen"."name" = \'Alex\' AND "citizen"."companyId" = "citizen_company_company"."id" AND "citizen_company_company"."ceoId" = "citizen_company_company_ceo_citizen"."id"');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationAlias: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .withReturn(Returning.all)
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS "citizen_company_company" WHERE "citizen_company_company"."name" = \'Serverpod\' AND "citizen"."companyId" = "citizen_company_company"."id" RETURNING *');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = DeleteQueryBuilder(table: citizenTable)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column "company"."name".'),
          )));
    });

    test(
        'when count column is used in where expression then exception is thrown.',
        () {
      var countColumn =
          ColumnCount(citizenTable.id.equals(5), citizenTable, citizenTable.id);
      var queryBuilder = DeleteQueryBuilder(table: citizenTable)
          .withWhere(countColumn.equals(5));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Count columns are not supported in where expressions.'),
          )));
    });
  });

  test(
      'Given a select query with a filtered result set when building the query then the query includes a where clause for the specified ids',
      () {
    var manyTable = _TableWithManyRelation(
      relationAlias: 'citizens',
      tableName: 'country',
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'citizens',
          field: ColumnInt('citizenId', citizenTable),
          foreignField: ColumnInt('id', citizenTable),
        )
      ]),
    );

    var query = SelectQueryBuilder(table: citizenTable)
        .withWhereRelationInResultSet({1, 2, 3}, manyTable).build();
    expect(
      query,
      'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."id" IN (1, 2, 3)',
    );
  });

  test(
      'Given a select query with a filtered result set and a manual where query when building then the query contains the where clause chained with the id filter with an AND.',
      () {
    var manyTable = _TableWithManyRelation(
      relationAlias: 'citizens',
      tableName: 'country',
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'citizens',
          field: ColumnInt('citizenId', citizenTable),
          foreignField: ColumnInt('id', citizenTable),
        )
      ]),
    );

    var query = SelectQueryBuilder(table: citizenTable)
        .withWhere(
      ColumnString(
        'name',
        citizenTable,
      ).equals('Serverpod'),
    )
        .withWhereRelationInResultSet({1, 2, 3}, manyTable).build();
    expect(
      query,
      'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."name" = \'Serverpod\' AND "citizen"."id" IN (1, 2, 3)',
    );
  });

  test(
      'Given a select query with a filtered result set and a limit when building then the query is wrapped in a subquery with a row_number() that selects the specific rows.',
      () {
    var manyTable = _TableWithManyRelation(
      relationAlias: 'citizens',
      tableName: 'country',
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'citizens',
          field: ColumnInt('citizenId', citizenTable),
          foreignField: ColumnInt('id', citizenTable),
        )
      ]),
    );

    var query = SelectQueryBuilder(table: citizenTable)
        .withWhereRelationInResultSet({1, 2, 3}, manyTable)
        .withLimit(10)
        .build();

    expect(
      query,
      'WITH _base_query_sorting_and_ordering AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."id" IN (1, 2, 3)), _partitioned_list_by_parent_id AS (SELECT *, row_number() OVER ( PARTITION BY _base_query_sorting_and_ordering."citizen.id") FROM _base_query_sorting_and_ordering)SELECT * FROM _partitioned_list_by_parent_id WHERE row_number BETWEEN 1 AND 10',
    );
  });

  test(
      'Given a select query with a filtered result set and an offset when building then the query is wrapped in a subquery with a row_number() that selects the specific rows.',
      () {
    var manyTable = _TableWithManyRelation(
      relationAlias: 'citizens',
      tableName: 'country',
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'citizens',
          field: ColumnInt('citizenId', citizenTable),
          foreignField: ColumnInt('id', citizenTable),
        )
      ]),
    );

    var query = SelectQueryBuilder(table: citizenTable)
        .withWhereRelationInResultSet({1, 2, 3}, manyTable)
        .withOffset(10)
        .build();

    expect(
      query,
      'WITH _base_query_sorting_and_ordering AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."id" IN (1, 2, 3)), _partitioned_list_by_parent_id AS (SELECT *, row_number() OVER ( PARTITION BY _base_query_sorting_and_ordering."citizen.id") FROM _base_query_sorting_and_ordering)SELECT * FROM _partitioned_list_by_parent_id WHERE row_number >= 11',
    );
  });

  test(
      'Given a select query with a filtered result set and a limit and an offset when building then the query is wrapped in a subquery with a row_number() that selects the specific rows.',
      () {
    var manyTable = _TableWithManyRelation(
      relationAlias: 'citizens',
      tableName: 'country',
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'citizens',
          field: ColumnInt('citizenId', citizenTable),
          foreignField: ColumnInt('id', citizenTable),
        )
      ]),
    );

    var query = SelectQueryBuilder(table: citizenTable)
        .withWhereRelationInResultSet({1, 2, 3}, manyTable)
        .withOffset(10)
        .withLimit(10)
        .build();

    expect(
      query,
      'WITH _base_query_sorting_and_ordering AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" WHERE "citizen"."id" IN (1, 2, 3)), _partitioned_list_by_parent_id AS (SELECT *, row_number() OVER ( PARTITION BY _base_query_sorting_and_ordering."citizen.id") FROM _base_query_sorting_and_ordering)SELECT * FROM _partitioned_list_by_parent_id WHERE row_number BETWEEN 11 AND 20',
    );
  });
}
