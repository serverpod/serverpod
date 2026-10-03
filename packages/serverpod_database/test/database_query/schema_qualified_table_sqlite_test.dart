import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
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
  ValueEncoder.set(const SqliteValueEncoder());

  group('Given a table with an unqualified name on SQLite', () {
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

  group('Given a table with a schema qualified name on SQLite', () {
    var citizenTable = _CitizenTable();

    test(
      'when reading the quoted table name then the full name is quoted as one identifier.',
      () {
        expect(citizenTable.quotedTableName, '"auth.citizen"');
      },
    );

    test(
      'when building a select query then the full name is one identifier without an alias.',
      () {
        var query = SelectQueryBuilder(table: citizenTable).build();

        expect(
          query,
          'SELECT "auth.citizen"."id" AS "auth.citizen.id", "auth.citizen"."name" AS "auth.citizen.name" FROM "auth.citizen"',
        );
      },
    );

    test(
      'when building a count query then the full name is one identifier without an alias.',
      () {
        var query = CountQueryBuilder(table: citizenTable).build();

        expect(query, 'SELECT COUNT("auth.citizen"."id") FROM "auth.citizen"');
      },
    );

    test(
      'when building a delete query then the full name is one identifier without an alias.',
      () {
        var query = DeleteQueryBuilder(table: citizenTable).build();

        expect(query, 'DELETE FROM "auth.citizen"');
      },
    );

    test(
      'when building an insert query then the full name is one identifier without an alias.',
      () {
        var query = InsertQueryBuilder(
          table: citizenTable,
          rows: [_Citizen(name: 'Alex')],
        ).build();

        expect(
          query,
          'INSERT INTO "auth.citizen" ("name") VALUES (\'Alex\') RETURNING *',
        );
      },
    );
  });

  group('Given a relation to a table with a schema qualified name on SQLite', () {
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
      'when building a select query filtering on the relation then the join uses one identifier.',
      () {
        var query = SelectQueryBuilder(table: citizenTable)
            .withWhere(ColumnString('name', relationTable).equals('Serverpod'))
            .build();

        expect(
          query,
          'SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "auth.company" AS "citizen_company_auth.company" ON "citizen"."companyId" = "citizen_company_auth.company"."id" WHERE "citizen_company_auth.company"."name" = \'Serverpod\'',
        );
      },
    );
  });
}
