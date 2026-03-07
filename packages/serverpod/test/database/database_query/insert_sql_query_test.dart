import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/adapters/postgres/sql_query_builder.dart';
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

class UserTable extends Table<int?> {
  late final ColumnString userName;
  late final ColumnInt age;

  UserTable() : super(tableName: 'user') {
    userName = ColumnString('user_name', this, fieldName: 'userName');
    age = ColumnInt('age', this);
  }

  @override
  List<Column> get columns => [id, userName, age];
}

class UserClass implements TableRow<int?>, ProtocolSerialization {
  final String userName;
  final int age;

  @override
  int? id;

  UserClass({this.id, required this.userName, required this.age});

  factory UserClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserClass(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      age: jsonSerialization['age'] as int,
    );
  }

  @override
  Table<int?> get table => UserTable();

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userName': userName,
      'age': age,
    };
  }

  @override
  Map<String, Object?> toJsonForProtocol() {
    return {
      'id': id,
      'userName': userName,
      'age': age,
    };
  }
}

void main() {
  ValueEncoder.set(PostgresValueEncoder());

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

  group('Given model with an explicit column field name', () {
    test(
      'when building insert query then output is a valid SQL query with column names.',
      () {
        var query = InsertQueryBuilder(
          table: UserTable(),
          rows: [UserClass(id: 33, userName: 'Alex', age: 33)],
        ).build();

        expect(
          query,
          'INSERT INTO "user" ("id", "user_name", "age") '
          'VALUES (33, \'Alex\', 33) RETURNING "user"."id" AS "id", "user"."user_name" AS "userName", "user"."age" AS "age"',
        );
      },
    );
  });

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

  group('Given ignoreConflicts is true and a row without id', () {
    late String query;

    setUp(() {
      query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [PersonClass(name: 'Alex', age: 33)],
        ignoreConflicts: true,
      ).build();
    });

    test(
      'when building insert query then ON CONFLICT DO NOTHING is appended.',
      () {
        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) ON CONFLICT DO NOTHING RETURNING *',
        );
      },
    );
  });

  group('Given ignoreConflicts is true and a row with id', () {
    late String query;

    setUp(() {
      query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [PersonClass(id: 33, name: 'Alex', age: 33)],
        ignoreConflicts: true,
      ).build();
    });

    test(
      'when building insert query then ON CONFLICT DO NOTHING is appended.',
      () {
        expect(
          query,
          'INSERT INTO "person" ("id", "name", "age") VALUES (33, \'Alex\', 33) ON CONFLICT DO NOTHING RETURNING *',
        );
      },
    );
  });

  group('Given ignoreConflicts is true and only id column', () {
    late String query;

    setUp(() {
      query = InsertQueryBuilder(
        table: Table<int?>(tableName: 'only_id'),
        rows: [OnlyIdClass()],
        ignoreConflicts: true,
      ).build();
    });

    test(
      'when building insert query then ON CONFLICT DO NOTHING is appended to DEFAULT VALUES query.',
      () {
        expect(
          query,
          'INSERT INTO "only_id" DEFAULT VALUES ON CONFLICT DO NOTHING RETURNING *',
        );
      },
    );
  });

  group('Given ignoreConflicts is true and mixed id rows', () {
    late String query;

    setUp(() {
      query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [
          PersonClass(id: 33, name: 'Alex', age: 33),
          PersonClass(name: 'Isak', age: 33),
        ],
        ignoreConflicts: true,
      ).build();
    });

    test(
      'when building insert query then both sub-queries include ON CONFLICT DO NOTHING.',
      () {
        expect(
          query,
          '''
WITH
  insertWithIdNull AS (INSERT INTO "person" ("name", "age") VALUES ('Isak', 33) ON CONFLICT DO NOTHING RETURNING *),
  insertWithIdNotNull AS (INSERT INTO "person" ("id", "name", "age") VALUES (33, 'Alex', 33) ON CONFLICT DO NOTHING RETURNING *)

SELECT * FROM insertWithIdNull
UNION ALL
SELECT * FROM insertWithIdNotNull
''',
        );
      },
    );
  });

  group('Given ignoreConflicts is false (default)', () {
    late String query;

    setUp(() {
      query = InsertQueryBuilder(
        table: PersonTable(),
        rows: [PersonClass(name: 'Alex', age: 33)],
        ignoreConflicts: false,
      ).build();
    });

    test(
      'when building insert query then ON CONFLICT DO NOTHING is not present.',
      () {
        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) RETURNING *',
        );
      },
    );
  });
}
