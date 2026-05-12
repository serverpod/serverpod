import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'Given no database section when inferring source then result is null.',
    () {
      expect(
        inferDatabaseSourceFromConfigMap({
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
    'Given empty database section when inferring source then result is null.',
    () {
      expect(inferDatabaseSourceFromConfigMap({'database': {}}), isNull);
    },
  );

  test(
    'Given Postgres config with no source field when inferring source then '
    'result is DatabaseSource.config.',
    () {
      expect(
        inferDatabaseSourceFromConfigMap({
          'database': {
            'host': 'localhost',
            'port': 5432,
            'name': 'db',
            'user': 'u',
          },
        }),
        DatabaseSource.config,
      );
    },
  );

  for (var src in DatabaseSource.values) {
    test(
      'Given Postgres config with source ${src.name} when inferring source '
      'then result is $src.',
      () {
        expect(
          inferDatabaseSourceFromConfigMap({
            'database': {
              'host': 'localhost',
              'port': 5432,
              'name': 'db',
              'user': 'u',
              'source': src.name,
            },
          }),
          src,
        );
      },
    );
  }

  test(
    'Given SQLite config when inferring source then result is null (sqlite '
    'ignores source).',
    () {
      expect(
        inferDatabaseSourceFromConfigMap({
          'database': {'filePath': 'app.db', 'source': 'embedded'},
        }),
        isNull,
      );
    },
  );

  test(
    'Given SERVERPOD_DATABASE_SOURCE env var when inferring source then env '
    'wins over absent config.',
    () {
      expect(
        inferDatabaseSourceFromConfigMap(
          {
            'database': {
              'host': 'localhost',
              'port': 5432,
              'name': 'db',
              'user': 'u',
            },
          },
          environment: {'SERVERPOD_DATABASE_SOURCE': 'auto'},
        ),
        DatabaseSource.auto,
      );
    },
  );

  test(
    'Given YAML from loadYaml when inferring source then field is parsed.',
    () {
      final doc = loadYaml('''
database:
  host: localhost
  port: 5432
  name: db
  user: u
  source: embedded
''');
      expect(
        inferDatabaseSourceFromConfigMap(
          Map<dynamic, dynamic>.from(doc as Map),
        ),
        DatabaseSource.embedded,
      );
    },
  );
}
