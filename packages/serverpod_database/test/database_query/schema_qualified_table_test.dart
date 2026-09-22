import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_database/src/concepts/table_relation.dart';
import 'package:test/test.dart';

class _CitizenTable extends Table<int?> {
  late final ColumnString name;

  _CitizenTable() : super(tableName: 'auth.citizen') {
    name = ColumnString('name', this);
  }

  @override
  List<Column> get columns => [id, name];
}

class _Citizen implements TableRow<int?> {
  @override
  int? id;

  final String name;

  _Citizen({required this.name});

  @override
  Table<int?> get table => _CitizenTable();

  @override
  Map<String, Object?> toJson() => {'id': id, 'name': name};
}

void main() {
  setUpAll(() => ValueEncoder.set(const PostgresValueEncoder()));

  group('Given a table with an unqualified name', () {
    var citizenTable = Table<int?>(tableName: 'citizen');

    test(
      'when reading the quoted table name then the name is quoted as one identifier.',
      () {
        expect(citizenTable.quotedTableName, '"citizen"');
      },
    );

    test('when building a select query then the table is not aliased.', () {
      var query = SelectQueryBuilder(table: citizenTable).build();

      expect(query, 'SELECT "citizen"."id" AS "citizen.id" FROM "citizen"');
    });
  });

  group('Given a table with a schema qualified name', () {
    var citizenTable = _CitizenTable();

    test(
      'when reading the quoted table name then the schema and table are quoted separately.',
      () {
        expect(citizenTable.quotedTableName, '"auth"."citizen"');
      },
    );

    test(
      'when building a select query then the table is qualified and aliased to its full name.',
      () {
        var query = SelectQueryBuilder(table: citizenTable).build();

        expect(
          query,
          'SELECT "auth.citizen"."id" AS "auth.citizen.id", "auth.citizen"."name" AS "auth.citizen.name" FROM "auth"."citizen" AS "auth.citizen"',
        );
      },
    );

    test(
      'when building a select query with order by then the column reference passes table validation.',
      () {
        var query = SelectQueryBuilder(
          table: citizenTable,
        ).withOrderBy([citizenTable.id.asc()]).build();

        expect(
          query,
          'SELECT "auth.citizen"."id" AS "auth.citizen.id", "auth.citizen"."name" AS "auth.citizen.name" FROM "auth"."citizen" AS "auth.citizen" ORDER BY "auth.citizen"."id" ASC NULLS LAST',
        );
      },
    );

    test(
      'when building a count query then the table is qualified and aliased to its full name.',
      () {
        var query = CountQueryBuilder(table: citizenTable).build();

        expect(
          query,
          'SELECT COUNT("auth.citizen"."id") FROM "auth"."citizen" AS "auth.citizen"',
        );
      },
    );

    test(
      'when building a delete query then the table is qualified and aliased to its full name.',
      () {
        var query = DeleteQueryBuilder(table: citizenTable).build();

        expect(query, 'DELETE FROM "auth"."citizen" AS "auth.citizen"');
      },
    );

    test(
      'when building an insert query then the table is qualified and aliased to its full name.',
      () {
        var query = InsertQueryBuilder(
          table: citizenTable,
          rows: [_Citizen(name: 'Alex')],
        ).build();

        expect(
          query,
          'INSERT INTO "auth"."citizen" AS "auth.citizen" ("name") VALUES (\'Alex\') RETURNING *',
        );
      },
    );
  });

  group('Given a relation to a table with a schema qualified name', () {
    var citizenTable = Table<int?>(tableName: 'citizen');
    var companyTable = Table<int?>(tableName: 'auth.company');
    var relationTable = Table<int?>(
      tableName: companyTable.tableName,
      tableRelation: TableRelation([
        TableRelationEntry(
          relationAlias: 'company',
          field: ColumnInt('companyId', citizenTable),
          foreignField: ColumnInt('id', companyTable),
        ),
      ]),
    );

    test(
      'when building a select query filtering on the relation then the join is qualified.',
      () {
        var query = SelectQueryBuilder(table: citizenTable)
            .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
            .build();

        expect(
          query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "auth"."company" AS "citizen_company_auth.company" ON "citizen"."companyId" = "citizen_company_auth.company"."id" WHERE "citizen_company_auth.company"."name" = \'Serverpod\'',
        );
      },
    );

    test(
      'when building a delete query filtering on the relation then the using clause is qualified.',
      () {
        var query = DeleteQueryBuilder(table: citizenTable)
            .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
            .build();

        expect(
          query,
          'DELETE FROM "citizen" USING "auth"."company" AS "citizen_company_auth.company" WHERE "citizen_company_auth.company"."name" = \'Serverpod\' AND "citizen"."companyId" = "citizen_company_auth.company"."id"',
        );
      },
    );
  });
}
