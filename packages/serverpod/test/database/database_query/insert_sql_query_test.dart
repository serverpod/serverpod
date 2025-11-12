import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:test/test.dart';

class PersonTable extends Table<int?> {
  late final ColumnString name;
  late final ColumnInt age;

  PersonTable() : super(tableName: 'person') {
    name = ColumnString('name', this);
    age = ColumnInt('age', this);
  }

  @override
  List<Column> get columns => [id, name, age];
}

class PersonClass implements TableRow<int?> {
  final String name;
  final int age;

  @override
  int? id;

  PersonClass({this.id, required this.name, required this.age});

  @override
  Table<int?> get table => PersonTable();

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}

class OnlyIdClass implements TableRow<int?> {
  OnlyIdClass({this.id});

  @override
  int? id;

  @override
  Table<int?> get table => Table<int?>(tableName: 'only_id');

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
    };
  }
}

void main() {
  group('Given model with a couple of columns', () {
    test(
      'when building insert query with a row then output is a valid SQL query that lists the columns.',
      () {
        var query = InsertQueryBuilder(
          table: PersonTable(),
          rows: [PersonClass(name: 'Alex', age: 33)],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) RETURNING *',
        );
      },
    );

    test(
      'when instantiating insert query with empty list of rows then argument error is thrown.',
      () {
        expect(
          () => InsertQueryBuilder(
            table: PersonTable(),
            rows: [],
          ),
          throwsArgumentError,
        );
      },
    );
  });

  group(
    'Given model with only id column when building insert query then default values are used in the query.',
    () {
      test(
        'when building insert query with a row then output is a valid SQL query that lists the columns.',
        () {
          var query = InsertQueryBuilder(
            table: Table<int?>(tableName: 'only_id'),
            rows: [OnlyIdClass()],
          ).build();

          expect(query, 'INSERT INTO "only_id" DEFAULT VALUES RETURNING *');
        },
      );
    },
  );

  test(
    'Given model with multiple columns and id column having value when building insert query then its id is used in the query.',
    () {
      var query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [PersonClass(id: 33, name: 'Alex', age: 33)],
      ).build();

      expect(
        query,
        'INSERT INTO "person" ("id", "name", "age") VALUES (33, \'Alex\', 33) RETURNING *',
      );
    },
  );

  test(
    'Given model with only id column and id column having value when building insert query then its id is used in the query.',
    () {
      var query = InsertQueryBuilder(
        table: Table<int?>(tableName: 'only_id'),
        rows: [OnlyIdClass(id: 33)],
      ).build();

      expect(query, 'INSERT INTO "only_id" ("id") VALUES (33) RETURNING *');
    },
  );

  test(
    'Given models a list of models with and without id column having value when building insert query then two separate insert queries are generated.',
    () {
      var query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [
          PersonClass(id: 33, name: 'Alex', age: 33),
          PersonClass(name: 'Isak', age: 33),
        ],
      ).build();

      expect(
        query,
        '''
WITH
  insertWithIdNull AS (INSERT INTO "person" ("name", "age") VALUES ('Isak', 33) RETURNING *),
  insertWithIdNotNull AS (INSERT INTO "person" ("id", "name", "age") VALUES (33, 'Alex', 33) RETURNING *)

SELECT * FROM insertWithIdNull
UNION ALL
SELECT * FROM insertWithIdNotNull
''',
      );
    },
  );
}
