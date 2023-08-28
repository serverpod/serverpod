import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

void main() {
  group('Given SelectQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = SelectQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT * FROM citizen');
    });

    test('when query with specific fields is built then output selects fields.',
        () {
      var fields = ['id', 'name', 'age'];
      var query =
          SelectQueryBuilder(table: 'citizen').withSelectFields(fields).build();

      expect(query, 'SELECT id, name, age FROM citizen');
    });

    test(
        'when query with simple where expression is built then output is a WHERE query.',
        () {
      var query = SelectQueryBuilder(table: 'citizen')
          .withWhere(Expression('"test"=@test'))
          .build();

      expect(query, 'SELECT * FROM citizen WHERE "test"=@test');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var expression1 = Expression('test expression 1');
      var expression2 = Expression('test expression 2');
      var combinedExpression = expression1 & expression2;

      var query = SelectQueryBuilder(table: 'citizen')
          .withWhere(combinedExpression)
          .build();

      expect(query,
          'SELECT * FROM citizen WHERE (test expression 1 AND test expression 2)');
    });

    test(
        'when query with single order by is built then output is single order by query.',
        () {
      Order order = Order(column: ColumnString('id'), orderDescending: false);

      var query =
          SelectQueryBuilder(table: 'citizen').withOrderBy([order]).build();

      expect(query, 'SELECT * FROM citizen ORDER BY "id"');
    });

    test(
        'when query with multiple order by is built then output is query with multiple order by requirements.',
        () {
      var orders = [
        Order(column: ColumnString('id'), orderDescending: false),
        Order(column: ColumnString('name'), orderDescending: true),
        Order(column: ColumnString('age'), orderDescending: false)
      ];

      var query =
          SelectQueryBuilder(table: 'citizen').withOrderBy(orders).build();

      expect(query, 'SELECT * FROM citizen ORDER BY "id", "name" DESC, "age"');
    });

    test('when query with limit is built then output is query with limit.', () {
      var query = SelectQueryBuilder(table: 'citizen').withLimit(10).build();

      expect(query, 'SELECT * FROM citizen LIMIT 10');
    });

    test('when query with offset is built then output is query with offset.',
        () {
      var query = SelectQueryBuilder(table: 'citizen').withOffset(10).build();

      expect(query, 'SELECT * FROM citizen OFFSET 10');
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
          'SELECT * FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
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
          'SELECT * FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN citizen AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test('when all properties configured is built then output is valid SQL.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = SelectQueryBuilder(table: table)
          .withSelectFields(['id', 'name', 'age'])
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
          .withOrderBy(
              [Order(column: ColumnString('id'), orderDescending: true)])
          .withLimit(10)
          .withOffset(5)
          .build();

      expect(query,
          'SELECT id, name, age FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\' ORDER BY "id" DESC LIMIT 10 OFFSET 5');
    });
  });

  group('Given CountQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = CountQueryBuilder(table: 'citizen').build();

      expect(query, 'SELECT COUNT(*) FROM citizen');
    });
    test('when query with alias is built then count result has defined alias.',
        () {
      var query =
          CountQueryBuilder(table: 'citizen').withCountAlias('c').build();

      expect(query, 'SELECT COUNT(*) AS c FROM citizen');
    });

    test('when query with field is built then count is based on that field.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withField('age').build();

      expect(query, 'SELECT COUNT(age) FROM citizen');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = CountQueryBuilder(table: 'citizen')
          .withWhere(Expression('"test"=@test'))
          .build();

      expect(query, 'SELECT COUNT(*) FROM citizen WHERE "test"=@test');
    });

    test('when query with limit is built then output is a query with limit.',
        () {
      var query = CountQueryBuilder(table: 'citizen').withLimit(10).build();

      expect(query, 'SELECT COUNT(*) FROM citizen LIMIT 10');
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
          'SELECT COUNT(*) FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\'');
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
          'SELECT COUNT(*) FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" LEFT JOIN citizen AS citizen_company_company_ceo_citizen ON citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id" WHERE citizen_company_company_ceo_citizen."name" = \'Alex\'');
    });

    test(
        'when query with all properties configured is built then output is valid SQL.',
        () {
      var table = 'citizen';
      var queryPrefix = 'citizen_company_';
      var queryPrefixForColumn = 'citizen_company_company';
      var query = CountQueryBuilder(table: table)
          .withCountAlias('c')
          .withField('age')
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
          .withLimit(10)
          .build();

      expect(query,
          'SELECT COUNT(age) AS c FROM citizen LEFT JOIN company AS citizen_company_company ON citizen."companyId" = citizen_company_company."id" WHERE citizen_company_company."name" = \'Serverpod\' LIMIT 10');
    });
  });

  group('Given DeleteQueryBuilder', () {
    test('when default initialized then build outputs a valid SQL query.', () {
      var query = DeleteQueryBuilder(table: 'citizen').build();

      expect(query, 'DELETE FROM citizen');
    });

    test(
        'when query with where expression is built then output is a WHERE query.',
        () {
      var query = DeleteQueryBuilder(table: 'citizen')
          .withWhere(Expression('"test"=@test'))
          .build();

      expect(query, 'DELETE FROM citizen WHERE "test"=@test');
    });

    test('when query returning all is built then output is a return all query.',
        () {
      var query = DeleteQueryBuilder(table: 'citizen').withReturnAll().build();

      expect(query, 'DELETE FROM citizen RETURNING *');
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
          'DELETE FROM citizen USING company AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id"');
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
          'DELETE FROM citizen USING company AS citizen_company_company, citizen AS citizen_company_company_ceo_citizen WHERE citizen_company_company_ceo_citizen."name" = \'Alex\' AND citizen."companyId" = citizen_company_company."id" AND citizen_company_company."ceoId" = citizen_company_company_ceo_citizen."id"');
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
          'DELETE FROM citizen USING company AS citizen_company_company WHERE citizen_company_company."name" = \'Serverpod\' AND citizen."companyId" = citizen_company_company."id" RETURNING *');
    });
  });
}
