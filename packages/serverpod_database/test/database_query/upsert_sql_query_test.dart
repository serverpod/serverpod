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
      'when building upsert query with a row without id and single unique column then output is valid SQL with ON CONFLICT DO UPDATE.',
      () {
        var table = PersonTable();
        var query = UpsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          uniqueColumns: [table.name],
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
        var query = UpsertQueryBuilder(
          table: table,
          rows: [PersonClass(id: 5, name: 'Alex', age: 33)],
          uniqueColumns: [table.name],
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
        var query = UpsertQueryBuilder(
          table: table,
          rows: [PersonClass(name: 'Alex', age: 33)],
          uniqueColumns: [table.name, table.age],
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
      'when building upsert query with multiple rows without id then output includes all rows in VALUES.',
      () {
        var table = PersonTable();
        var query = UpsertQueryBuilder(
          table: table,
          rows: [
            PersonClass(name: 'Alex', age: 33),
            PersonClass(name: 'Isak', age: 25),
          ],
          uniqueColumns: [table.name],
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
        var query = UpsertQueryBuilder(
          table: table,
          rows: [
            PersonClass(id: 5, name: 'Alex', age: 33),
            PersonClass(name: 'Isak', age: 25),
          ],
          uniqueColumns: [table.name],
        ).build();

        expect(
          query,
          '''
WITH
  upsertWithIdNull AS (INSERT INTO "person" ("name", "age") VALUES ('Isak', 25) ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" RETURNING *),
  upsertWithIdNotNull AS (INSERT INTO "person" ("id", "name", "age") VALUES (5, 'Alex', 33) ON CONFLICT ("name") DO UPDATE SET "age" = EXCLUDED."age" RETURNING *)

SELECT * FROM upsertWithIdNull
UNION ALL
SELECT * FROM upsertWithIdNotNull
''',
        );
      },
    );
  });

  group('Given model with an explicit column field name', () {
    test(
      'when building upsert query then output uses column names and field name returning clause.',
      () {
        var table = UserTable();
        var query = UpsertQueryBuilder(
          table: table,
          rows: [UserClass(id: 33, userName: 'Alex', age: 33)],
          uniqueColumns: [table.userName],
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

  group('Given validation errors', () {
    test(
      'when instantiating upsert query with empty list of rows then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => UpsertQueryBuilder(
            table: table,
            rows: [],
            uniqueColumns: [table.name],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with empty uniqueColumns then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => UpsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            uniqueColumns: [],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when instantiating upsert query with id as unique column then argument error is thrown.',
      () {
        var table = PersonTable();
        expect(
          () => UpsertQueryBuilder(
            table: table,
            rows: [PersonClass(name: 'Alex', age: 33)],
            uniqueColumns: [table.id],
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
          () => UpsertQueryBuilder(
            table: personTable,
            rows: [PersonClass(name: 'Alex', age: 33)],
            uniqueColumns: [userTable.userName],
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
