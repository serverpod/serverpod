import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
import 'package:test/test.dart';

class _PersonTable extends Table<int?> {
  late final ColumnString name;
  late final ColumnInt age;
  late final ColumnBool active;

  _PersonTable() : super(tableName: 'person') {
    name = ColumnString('full_name', this, fieldName: 'name');
    age = ColumnInt('age', this);
    active = ColumnBool('active', this);
  }

  @override
  List<Column> get columns => [id, name, age, active];
}

class _Person implements TableRow<int?> {
  @override
  final int? id;
  final String name;
  final int? age;
  final bool active;
  final _PersonTable _table;

  _Person({
    required this.id,
    required this.name,
    required this.age,
    required this.active,
    required _PersonTable table,
  }) : _table = table;

  @override
  Table<int?> get table => _table;

  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'active': active,
  };
}

void main() {
  group('Given UpdateQueryBuilder for PostgreSQL', () {
    late _PersonTable table;

    setUp(() {
      ValueEncoder.set(const PostgresValueEncoder());
      table = _PersonTable();
    });

    test('when updating rows then it builds a typed VALUES update', () {
      var rows = [
        _Person(
          id: 1,
          name: 'Alex',
          age: 33,
          active: true,
          table: table,
        ),
        _Person(
          id: 2,
          name: 'Bob',
          age: 40,
          active: false,
          table: table,
        ),
      ];

      var query = UpdateQueryBuilder.forRows(
        table: table,
        dialect: DatabaseDialect.postgres,
        rows: rows,
        columns: table.columns.toSet(),
      ).build();

      expect(
        query,
        'UPDATE "person" AS t SET "id" = data."id", '
        '"full_name" = data."full_name", "age" = data."age", '
        '"active" = data."active" FROM (VALUES '
        '(1::bigint, \'Alex\'::text, 33::bigint, TRUE::boolean), '
        '(2::bigint, \'Bob\'::text, 40::bigint, FALSE::boolean)) '
        'AS data("id", "full_name", "age", "active") '
        'WHERE data.id = t.id RETURNING '
        '"t"."id" AS "id", "t"."full_name" AS "name", '
        '"t"."age" AS "age", "t"."active" AS "active"',
      );
    });

    test('when returning is disabled then RETURNING is omitted', () {
      var row = _Person(
        id: 1,
        name: 'Alex',
        age: 33,
        active: true,
        table: table,
      );

      var query = UpdateQueryBuilder.forRows(
        table: table,
        dialect: DatabaseDialect.postgres,
        rows: [row],
        columns: {table.id, table.name},
      ).withReturn(Returning.none).build();

      expect(query, isNot(contains('RETURNING')));
    });

    test('when a row update returns its id then the target is qualified', () {
      var row = _Person(
        id: 1,
        name: 'Alex',
        age: 33,
        active: true,
        table: table,
      );

      var query = UpdateQueryBuilder.forRows(
        table: table,
        dialect: DatabaseDialect.postgres,
        rows: [row],
        columns: {table.id, table.name},
      ).withReturn(Returning.id).build();

      expect(query, endsWith('WHERE data.id = t.id RETURNING "t"."id"'));
    });

    test('when only the id is returned then RETURNING selects the id', () {
      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [ColumnValue(table.name, 'Updated')],
      ).withId(7).withReturn(Returning.id).build();

      expect(
        query,
        'UPDATE "person" SET "full_name" = \'Updated\'::text '
        'WHERE "id" = 7 RETURNING "id"',
      );
    });

    test('when updating column values by id then values are cast', () {
      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [
          ColumnValue(table.name, 'Updated'),
          ColumnValue(table.age, null),
        ],
      ).withId(7).build();

      expect(
        query,
        'UPDATE "person" SET "full_name" = \'Updated\'::text, '
        '"age" = NULL::bigint WHERE "id" = 7 RETURNING *',
      );
    });

    test('when updating with a where expression then it is preserved', () {
      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [ColumnValue(table.active, false)],
      ).withWhere(table.age > 20).build();

      expect(
        query,
        'UPDATE "person" SET "active" = FALSE::boolean '
        'WHERE "person"."age" > 20 RETURNING *',
      );
    });

    test('when using a filtered selection then it builds an ordered CTE', () {
      var orders = [table.age.desc()];
      var selection = SelectQueryBuilder(table: table)
          .withSelectFields([table.id])
          .withWhere(table.active.equals(true))
          .withOrderBy(orders)
          .withLimit(2)
          .withOffset(1)
          .build();

      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [ColumnValue(table.name, 'Updated')],
      ).withFilteredSelection(selection, orderBy: orders).build();

      expect(
        query,
        'WITH rows_to_update AS ($selection), updated AS ('
        'UPDATE "person" SET "full_name" = \'Updated\'::text '
        'WHERE "id" IN (SELECT "person.id" FROM rows_to_update) '
        'RETURNING *) SELECT * FROM updated ORDER BY "age" DESC',
      );
    });

    test('when a filtered update returns nothing then wrapping is omitted', () {
      var selection = SelectQueryBuilder(
        table: table,
      ).withSelectFields([table.id]).withLimit(1).build();

      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [ColumnValue(table.name, 'Updated')],
      ).withFilteredSelection(selection).withReturn(Returning.none).build();

      expect(
        query,
        'WITH rows_to_update AS ($selection) '
        'UPDATE "person" SET "full_name" = \'Updated\'::text '
        'WHERE "id" IN (SELECT "person.id" FROM rows_to_update)',
      );
    });

    test(
      'when a filtered update returns only its id then ordering by another '
      'column throws',
      () {
        var builder =
            UpdateQueryBuilder.forColumnValues(
                table: table,
                dialect: DatabaseDialect.postgres,
                columnValues: [ColumnValue(table.name, 'Updated')],
              )
              ..withFilteredSelection(
                'SELECT "id" AS "person.id" FROM "person"',
                orderBy: [table.age.asc()],
              )
              ..withReturn(Returning.id);

        expect(
          builder.build,
          throwsA(
            isA<FormatException>().having(
              (error) => error.message,
              'message',
              'Filtered updates returning only the id can only be ordered by '
                  'the id column.',
            ),
          ),
        );
      },
    );
  });

  group('Given UpdateQueryBuilder for SQLite', () {
    late _PersonTable table;

    setUp(() {
      ValueEncoder.set(const SqliteValueEncoder());
      table = _PersonTable();
    });

    test('when updating a row then it builds a single-row update', () {
      var row = _Person(
        id: 1,
        name: 'Alex',
        age: 33,
        active: true,
        table: table,
      );

      var query = UpdateQueryBuilder.forRows(
        table: table,
        dialect: DatabaseDialect.sqlite,
        rows: [row],
        columns: table.columns.toSet(),
      ).build();

      expect(
        query,
        'UPDATE "person" SET "full_name" = \'Alex\', "age" = 33, '
        '"active" = 1 WHERE "id" = 1 RETURNING *',
      );
    });

    test('when only the id is selected then it builds a valid no-op set', () {
      var row = _Person(
        id: 1,
        name: 'Alex',
        age: 33,
        active: true,
        table: table,
      );

      var query = UpdateQueryBuilder.forRows(
        table: table,
        dialect: DatabaseDialect.sqlite,
        rows: [row],
        columns: {table.id},
      ).build();

      expect(
        query,
        'UPDATE "person" SET "id" = 1 WHERE "id" = 1 RETURNING *',
      );
    });

    test('when updating column values by id then SQLite values are used', () {
      var query = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.sqlite,
        columnValues: [
          ColumnValue(table.name, 'Updated'),
          ColumnValue(table.active, true),
          ColumnValue(table.age, null),
        ],
      ).withId(7).build();

      expect(
        query,
        'UPDATE "person" SET "full_name" = \'Updated\', "active" = 1, '
        '"age" = NULL WHERE "id" = 7 RETURNING *',
      );
    });

    test(
      'when updating selected ids without return then it omits RETURNING',
      () {
        var query = UpdateQueryBuilder.forColumnValues(
          table: table,
          dialect: DatabaseDialect.sqlite,
          columnValues: [ColumnValue(table.active, false)],
        ).withIds([1, 2]).withReturn(Returning.none).build();

        expect(
          query,
          'UPDATE "person" SET "active" = 0 WHERE "id" IN (1, 2)',
        );
      },
    );

    test('when using a filtered selection then it throws', () {
      var builder = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.sqlite,
        columnValues: [ColumnValue(table.name, 'Updated')],
      );

      expect(
        () => builder.withFilteredSelection('SELECT "id" FROM "person"'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('Given invalid UpdateQueryBuilder input', () {
    test('when rows are empty then it throws an ArgumentError', () {
      expect(
        () => UpdateQueryBuilder.forRows(
          table: _PersonTable(),
          dialect: DatabaseDialect.postgres,
          rows: [],
          columns: {ColumnInt('id', _PersonTable())},
        ),
        throwsArgumentError,
      );
    });

    test('when column values are empty then it throws an ArgumentError', () {
      expect(
        () => UpdateQueryBuilder.forColumnValues(
          table: _PersonTable(),
          dialect: DatabaseDialect.postgres,
          columnValues: [],
        ),
        throwsArgumentError,
      );
    });

    test('when SQLite rows contain multiple entries then it throws', () {
      var table = _PersonTable();
      var rows = [
        _Person(
          id: 1,
          name: 'Alex',
          age: 33,
          active: true,
          table: table,
        ),
        _Person(
          id: 2,
          name: 'Bob',
          age: 40,
          active: false,
          table: table,
        ),
      ];

      expect(
        () => UpdateQueryBuilder.forRows(
          table: table,
          dialect: DatabaseDialect.sqlite,
          rows: rows,
          columns: {table.id, table.name},
        ),
        throwsArgumentError,
      );
    });

    test('when ids are empty then it throws an ArgumentError', () {
      var table = _PersonTable();
      var builder = UpdateQueryBuilder.forColumnValues(
        table: table,
        dialect: DatabaseDialect.postgres,
        columnValues: [ColumnValue(table.name, 'Updated')],
      );

      expect(() => builder.withIds([]), throwsArgumentError);
    });
  });
}
