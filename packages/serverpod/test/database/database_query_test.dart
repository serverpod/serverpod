import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');

  group('Given SelectQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = SelectQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT * FROM "citizen"');
    });

    test('when query with specific fields is built then output selects fields.',
        () {
      var table = Table(tableName: 'citizen');
      var fields = [
        ColumnString('id', table),
        ColumnString('name', table),
        ColumnString('age', table),
      ];
      var query = SelectQueryBuilder(table: table.tableName)
          .withSelectFields(fields)
          .build();

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
      var table = Table(tableName: 'citizen');
      Order order = Order(
        column: ColumnString('id', table),
        orderDescending: false,
      );

      var query = SelectQueryBuilder(table: table.tableName)
          .withOrderBy([order]).build();

      expect(query, 'SELECT * FROM "citizen" ORDER BY citizen."id"');
    });

    test(
        'when query with multiple order by is built then output is query with multiple order by requirements.',
        () {
      var table = Table(tableName: 'citizen');
      var orders = [
        Order(
          column: ColumnString('id', table),
          orderDescending: false,
        ),
        Order(
          column: ColumnString('name', table),
          orderDescending: true,
        ),
        Order(
          column: ColumnString('age', table),
          orderDescending: false,
        )
      ];

      var query = SelectQueryBuilder(table: table.tableName)
          .withOrderBy(orders)
          .build();

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
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT * FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationFieldName: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString(
            'name',
            nestedRelationTable,
          ).equals('Alex'))
          .build();

      expect(query,
          'SELECT * FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN "citizen" AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test('when all properties configured is built then output is valid SQL.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = SelectQueryBuilder(table: citizenTable.tableName)
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
                column: ColumnString('id', citizenTable), orderDescending: true)
          ])
          .withLimit(10)
          .withOffset(5)
          .build();

      expect(query,
          'SELECT citizen."id" AS "citizen.id", citizen."name" AS "citizen.name", citizen."age" AS "citizen.age" FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\' ORDER BY citizen."id" DESC LIMIT 10 OFFSET 5');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = SelectQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

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
      var queryBuilder = SelectQueryBuilder(table: citizenTable.tableName)
          .withOrderBy([Order(column: ColumnString('name', companyTable))]);

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"orderBy" expression referencing column company."name".'),
          )));
    });
  });

  group('Given CountQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = CountQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT COUNT(*) FROM "citizen"');
    });
    test('when query with alias is built then count result has defined alias.',
        () {
      var query =
          CountQueryBuilder(table: 'citizen').withCountAlias('c').build();

      expect(query, 'SELECT COUNT(*) AS c FROM "citizen"');
    });

    test('when query with field is built then count is based on that field.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withField('age').build();

      expect(query, 'SELECT COUNT(age) FROM "citizen"');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = CountQueryBuilder(table: 'citizen')
          .withWhere(const Expression('"test"=@test'))
          .build();

      expect(query, 'SELECT COUNT(*) FROM "citizen" WHERE "test"=@test');
    });

    test('when query with limit is built then output is a query with limit.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withLimit(10).build();

      expect(query, 'SELECT COUNT(*) FROM "citizen" LIMIT 10');
    });

    test(
        'when where expression depends on relations then output includes joins according to table relations.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString(
            'name',
            relationTable,
          ).equals('Serverpod'))
          .build();

      expect(query,
          'SELECT COUNT(*) FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
    });

    test(
        'when where expression depends on nested relations then output includes joins according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationFieldName: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString(
            'name',
            nestedRelationTable,
          ).equals('Alex'))
          .build();

      expect(query,
          'SELECT COUNT(*) FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN "citizen" AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = CountQueryBuilder(table: citizenTable.tableName)
          .withCountAlias('c')
          .withField('age')
          .withWhere(
            ColumnString('name', relationTable).equals('Serverpod'),
          )
          .withLimit(10)
          .build();

      expect(query,
          'SELECT COUNT(age) AS c FROM "citizen" LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\' LIMIT 10');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = CountQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."name".'),
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
      var query = DeleteQueryBuilder(table: 'citizen')
          .withReturn(Returning.all)
          .build();

      expect(query, 'DELETE FROM "citizen" RETURNING *');
    });

    test('when query return id is build then the output is a return id query.',
        () {
      var query =
          DeleteQueryBuilder(table: 'citizen').withReturn(Returning.id).build();

      expect(query, 'DELETE FROM "citizen" RETURNING "citizen".id');
    });

    test(
        'when where expression depends on relations then output includes using according to table relations.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id"');
    });

    test(
        'when where expression depends on nested relations then output includes using according to table relations.',
        () {
      var nestedRelationTable = Table(
        tableName: citizenTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          ),
          TableRelationEntry(
            relationFieldName: 'ceo',
            field: ColumnInt('ceoId', companyTable),
            foreignField: ColumnInt('id', citizenTable),
          ),
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', nestedRelationTable).equals('Alex'))
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company, "citizen" AS citizen_company_company_ceo_citizen WHERE citizen_company_company_ceo_citizen."name" = \'Alex\' AND citizen."companyId" = citizen_company_company."id" AND citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id"');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var relationTable = Table(
        tableName: companyTable.tableName,
        tableRelation: TableRelation([
          TableRelationEntry(
            relationFieldName: 'company',
            field: ColumnInt('companyId', citizenTable),
            foreignField: ColumnInt('id', companyTable),
          )
        ]),
      );

      var query = DeleteQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
          .withReturn(Returning.all)
          .build();

      expect(query,
          'DELETE FROM "citizen" USING "company" AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id" RETURNING *');
    });

    test(
        'when column where expression has different table as base then exception is thrown.',
        () {
      var queryBuilder = DeleteQueryBuilder(table: citizenTable.tableName)
          .withWhere(ColumnString('name', companyTable).equals('Serverpod'));

      expect(
          () => queryBuilder.build(),
          throwsA(isA<FormatException>().having(
            (e) => e.toString(),
            'message',
            equals(
                'FormatException: Column references starting from other tables than "citizen" are not supported. The following expressions need to be removed or modified:\n"where" expression referencing column company."name".'),
          )));
    });
  });
}
