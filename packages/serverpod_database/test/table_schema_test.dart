import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a table with an unqualified name', () {
    var table = Table<int?>(tableName: 'citizen');

    test('when reading the schema then null is returned.', () {
      expect(table.schema, isNull);
    });

    test(
      'when reading the unqualified table name then the full name is returned.',
      () {
        expect(table.unqualifiedTableName, 'citizen');
      },
    );

    test('when reading the query prefix then the full name is returned.', () {
      expect(table.queryPrefix, 'citizen');
    });
  });

  group('Given a table with a schema qualified name', () {
    var table = Table<int?>(tableName: 'auth.citizen');

    test('when reading the schema then the schema part is returned.', () {
      expect(table.schema, 'auth');
    });

    test(
      'when reading the unqualified table name then the table part is returned.',
      () {
        expect(table.unqualifiedTableName, 'citizen');
      },
    );

    test('when reading the query prefix then the full name is returned.', () {
      expect(table.queryPrefix, 'auth.citizen');
    });
  });
}
