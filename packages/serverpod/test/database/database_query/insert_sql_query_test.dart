import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:test/test.dart';

class PersonTable extends Table {
  late final ColumnString name;
  late final ColumnInt age;

  PersonTable() : super(tableName: 'person') {
    name = ColumnString('name', this);
    age = ColumnInt('age', this);
  }

  @override
  List<Column> get columns => [id, name, age];
}

class PersonClass extends TableRow {
  final String name;
  final int age;

  PersonClass({required this.name, required this.age}) : super(1);

  @override
  Table get table => PersonTable();

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}

class OnlyIdClass extends TableRow {
  OnlyIdClass() : super(1);

  @override
  Table get table => Table(tableName: 'only_id');

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

      expect(query,
          'INSERT INTO "person" ("name", "age") VALUES (\'Alex\', 33) RETURNING *');
    });

    test(
        'when instantiating insert query with empty list of rows then argument error is thrown.',
        () {
      expect(
          () => InsertQueryBuilder(
                table: PersonTable(),
                rows: [],
              ),
          throwsArgumentError);
    });
  });

  group(
      'Given model with only id column when building insert query then default values are used in the query.',
      () {
    test(
        'when building insert query with a row then output is a valid SQL query that lists the columns.',
        () {
      var query = InsertQueryBuilder(
        table: Table(tableName: 'only_id'),
        rows: [OnlyIdClass()],
      ).build();

      expect(query, 'INSERT INTO "only_id" DEFAULT VALUES RETURNING *');
    });
  });
}
