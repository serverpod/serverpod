import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'Given no database section, '
    'when inferring database config, '
    'then result is null.',
    () {
      expect(
        inferDatabaseConfigFromConfigMap({
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
    'Given empty database section, '
    'when inferring database config, '
    'then result is null.',
    () {
      expect(
        inferDatabaseConfigFromConfigMap({'database': {}}),
        isNull,
      );
    },
  );

  test(
    'Given SQLite filePath, '
    'when inferring database config, '
    'then result is a sqlite config.',
    () {
      expect(
        inferDatabaseConfigFromConfigMap({
          'database': {'filePath': 'app.db'},
        }),
        isA<SqliteDatabaseConfig>().having(
          (c) => c.dialect,
          'dialect',
          DatabaseDialect.sqlite,
        ),
      );
    },
  );

  test(
    'Given PostgreSQL-shaped database, '
    'when inferring database config, '
    'then result is a postgres config.',
    () {
      expect(
        inferDatabaseConfigFromConfigMap({
          'database': {
            'host': 'localhost',
            'port': 5432,
            'name': 'db',
            'user': 'u',
          },
        }),
        isA<PostgresDatabaseConfig>().having(
          (c) => c.dialect,
          'dialect',
          DatabaseDialect.postgres,
        ),
      );
    },
  );

  test(
    'Given YAML with a database section and filePath from loadYaml, '
    'when inferring database config, '
    'then result is a sqlite config.',
    () {
      final doc = loadYaml('''
database:
  filePath: data/app.db
''');
      expect(
        inferDatabaseConfigFromConfigMap(
          Map<dynamic, dynamic>.from(doc as Map),
        ),
        isA<SqliteDatabaseConfig>().having(
          (c) => c.dialect,
          'dialect',
          DatabaseDialect.sqlite,
        ),
      );
    },
  );

  test(
    'Given invalid database section, '
    'when inferring database config, '
    'then an exception is thrown.',
    () {
      expect(
        () => inferDatabaseConfigFromConfigMap({
          'database': {'host': 'only-host'},
        }),
        throwsException,
      );
    },
  );
}
