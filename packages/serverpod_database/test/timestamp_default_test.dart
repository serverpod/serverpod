import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/postgres_default_value.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_default_value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a PostgreSQL timestamp literal default, '
    'when normalizing the default, '
    'then the UTC timestamp is preserved.',
    () {
      const sql = "'2024-01-02 03:04:05.006'::timestamp without time zone";

      final result = pgSqlToAbstractDefault(
        sql,
        ColumnType.timestampWithoutTimeZone,
      );

      expect(result, '2024-01-02T03:04:05.006Z');
    },
  );

  test(
    'Given a PostgreSQL timestamp default with a custom SQL expression, '
    'when normalizing the default, '
    'then the original SQL is preserved.',
    () {
      const sql = "(now() AT TIME ZONE 'utc'::text)";

      final result = pgSqlToAbstractDefault(
        sql,
        ColumnType.timestampWithoutTimeZone,
      );

      expect(result, sql);
    },
  );

  test(
    'Given a SQLite timestamp literal default before the Unix epoch, '
    'when normalizing the default, '
    'then the UTC timestamp is preserved.',
    () {
      const sql = '-1';

      final result = sqliteSqlToAbstractDefault(
        sql,
        ColumnType.timestampWithoutTimeZone,
      );

      expect(result, '1969-12-31T23:59:59.999Z');
    },
  );

  test(
    'Given a SQLite timestamp default with a custom SQL expression, '
    'when normalizing the default, '
    'then the original SQL is preserved.',
    () {
      const sql = "unixepoch('now') * 1000";

      final result = sqliteSqlToAbstractDefault(
        sql,
        ColumnType.timestampWithoutTimeZone,
      );

      expect(result, sql);
    },
  );
}
