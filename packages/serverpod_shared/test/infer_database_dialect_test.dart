import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'Given no database section when inferring dialect then result is null.',
    () {
      expect(
        inferDatabaseDialectFromConfigMap({
          'apiServer': {
            'port': 8080,
            'publicHost': 'localhost',
            'publicPort': 8080,
            'publicScheme': 'http',
          },
        }),
        isNull,
      );
    },
  );

  test(
    'Given empty database section when inferring dialect then result is null.',
    () {
      expect(
        inferDatabaseDialectFromConfigMap({'database': {}}),
        isNull,
      );
    },
  );

  test(
    'Given SQLite filePath when inferring dialect then result is sqlite.',
    () {
      expect(
        inferDatabaseDialectFromConfigMap({
          'database': {'filePath': 'app.db'},
        }),
        DatabaseDialect.sqlite,
      );
    },
  );

  test(
    'Given PostgreSQL-shaped database when inferring dialect then result is postgres.',
    () {
      expect(
        inferDatabaseDialectFromConfigMap({
          'database': {
            'host': 'localhost',
            'port': 5432,
            'name': 'db',
            'user': 'u',
          },
        }),
        DatabaseDialect.postgres,
      );
    },
  );

  test(
    'Given YAML from loadYaml when inferring dialect then result is sqlite.',
    () {
      final doc = loadYaml('''
database:
  filePath: data/app.db
''');
      expect(
        inferDatabaseDialectFromConfigMap(
          Map<dynamic, dynamic>.from(doc as Map),
        ),
        DatabaseDialect.sqlite,
      );
    },
  );

  test(
    'Given invalid database section when inferring then an exception is thrown.',
    () {
      expect(
        () => inferDatabaseDialectFromConfigMap({
          'database': {'host': 'only-host'},
        }),
        throwsException,
      );
    },
  );
}
