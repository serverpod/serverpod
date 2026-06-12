import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
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
  ValueEncoder.set(const PostgresValueEncoder());

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

    test(
      'when building upsert query with a row without id and single unique column then output is valid SQL with ON CONFLICT DO UPDATE.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          conflictColumns: [table.name],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) '
          'ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" '
          'RETURNING *',
        );
      },
    );

    test(
      'when building upsert query with a row with id and single unique column then id is included in INSERT but excluded from DO UPDATE SET.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(id: 5, name: 'Alex', age: 33)],
          conflictColumns: [table.name],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("id", "name", "age") VALUES (5, \'Alex\', 33) '
          'ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" '
          'RETURNING *',
        );
      },
    );

    test(
      'when building upsert query with multiple unique columns then ON CONFLICT lists all unique columns.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          conflictColumns: [table.name, table.age],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) '
          'ON CONFLICT ("name", "age") DO UPDATE SET "name" = EXCLUDED."name" '
          'RETURNING *',
        );
      },
    );

    test(
      'when building upsert query with updateWhere then WHERE appears after SET clause and RETURNING is present.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          conflictColumns: [table.name],
          updateWhere: table.age.notEquals(99),
        ).build();

        expect(
          query,
          contains('DO UPDATE SET "age" = EXCLUDED."age" WHERE'),
        );
        expect(query, endsWith('RETURNING *'));
      },
    );

    test(
      'when building upsert query with both updateColumns and updateWhere then both are applied.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          conflictColumns: [table.name],
          updateColumns: [table.age],
          updateWhere: table.age.notEquals(99),
        ).build();

        expect(
          query,
          contains('DO UPDATE SET "age" = EXCLUDED."age" WHERE'),
        );
        expect(query, endsWith('RETURNING *'));
      },
    );

    test(
      'when updateWhere is provided without conflictColumns then ArgumentError is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            updateWhere: table.age.notEquals(99),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when updateColumns is provided without conflictColumns then ArgumentError is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            updateColumns: [table.age],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when building upsert query with multiple rows without id then output includes all rows in VALUES.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [
            PersonClass(name: 'Alex', age: 33),
            PersonClass(name: 'Isak', age: 25),
          ],
          conflictColumns: [table.name],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33), (\'Isak\', 25) '
          'ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" '
          'RETURNING *',
        );
      },
    );

    test(
      'when building upsert query with mixed id rows then WITH/UNION ALL query is generated.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [
            PersonClass(id: 5, name: 'Alex', age: 33),
            PersonClass(name: 'Isak', age: 25),
          ],
          conflictColumns: [table.name],
        ).build();

        expect(
          query,
          '''
WITH
  insertWithIdNull AS (INSERT INTO "person" ("name", "age") VALUES ('Isak', 25) ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" RETURNING *),
  insertWithIdNotNull AS (INSERT INTO "person" ("id", "name", "age") VALUES (5, 'Alex', 33) ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" RETURNING *)

SELECT * FROM insertWithIdNull
UNION ALL
SELECT * FROM insertWithIdNotNull
''',
        );
      },
    );

    test(
      'when building upsert query with explicit updateColumns then SET clause only includes those columns.',
      () {
        var table = PersonTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          conflictColumns: [table.name],
          updateColumns: [table.age],
        ).build();

        expect(
          query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) '
          'ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" '
          'RETURNING *',
        );
      },
    );
    test(
      'when instantiating upsert query with empty list of rows then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [],
            conflictColumns: [table.name],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with empty conflictColumns then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with id as conflict column then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [table.id],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with column not in table then argument error is thrown.',
      () {
        var personTable = PersonTable();
        var userTable = UserTable();
        expect(
          () => InsertQueryBuilder(
            table: personTable,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [userTable.userName],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with empty updateColumns then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [table.name],
            updateColumns: [],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with id in updateColumns then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [table.name],
            updateColumns: [table.id],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with updateColumns containing column not in table then argument error is thrown.',
      () {
        var personTable = PersonTable();
        var userTable = UserTable();
        expect(
          () => InsertQueryBuilder(
            table: personTable,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [personTable.name],
            updateColumns: [userTable.userName],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with updateColumns overlapping conflictColumns then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => InsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            conflictColumns: [table.name],
            updateColumns: [table.name],
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

    test(
      'when building upsert query then output uses column names and field name returning clause.',
      () {
        var table = UserTable();
        var query = InsertQueryBuilder(
          table: table,
          rows: [UserClass(id: 33, userName: 'Alex', age: 33)],
          conflictColumns: [table.userName],
        ).build();

        expect(
          query,
          'INSERT INTO "user" ("id", "user_name", "age") VALUES (33, \'Alex\', 33) '
          'ON CONFLICT ("user_name") DO UPDATE SET "age" = EXCLUDED."age" '
          'RETURNING "user"."id" AS "id", "user"."user_name" AS "userName", "user"."age" AS "age"',
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
