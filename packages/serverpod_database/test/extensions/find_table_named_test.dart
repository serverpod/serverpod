import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

TableDefinition _table(String name, String schema) => TableDefinition(
  name: name,
  schema: schema,
  columns: [],
  foreignKeys: [],
  indexes: [],
);

DatabaseDefinition _database(List<TableDefinition> tables) =>
    DatabaseDefinition(
      moduleName: 'test',
      tables: tables,
      installedModules: [],
      migrationApiVersion: 1,
    );

void main() {
  group('Given a database with the same table name in two schemas', () {
    var database = _database([
      _table('citizen', 'auth'),
      _table('citizen', 'app'),
    ]);

    test('when finding by name only then the first match is returned.', () {
      var table = database.findTableNamed('citizen');

      expect(table?.schema, 'auth');
    });

    test(
      'when finding with a schema then the table in that schema is returned.',
      () {
        var table = database.findTableNamed('citizen', schema: 'app');

        expect(table?.schema, 'app');
      },
    );

    test(
      'when finding with a schema that has no match then null is returned.',
      () {
        var table = database.findTableNamed('citizen', schema: 'crm');

        expect(table, isNull);
      },
    );

    test(
      'when finding with the public schema then the first match is returned.',
      () {
        var table = database.findTableNamed('citizen', schema: 'public');

        expect(table?.schema, 'auth');
      },
    );
  });

  group('Given a database with a table in the public schema', () {
    var database = _database([_table('citizen', 'public')]);

    test('when finding with another schema then null is returned.', () {
      var table = database.findTableNamed('citizen', schema: 'auth');

      expect(table, isNull);
    });

    test(
      'when checking containment with another schema then false is returned.',
      () {
        expect(database.containsTableNamed('citizen', schema: 'auth'), isFalse);
      },
    );
  });
}
