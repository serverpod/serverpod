import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_default_value.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Decimal default value,', () {
    test(
      'when getSqliteColumnDefault is called, then the value is quoted as a TEXT literal',
      () {
        expect(
          ColumnType.decimal.getSqliteColumnDefault('10.5'),
          equals("'10.5'"),
        );
      },
    );

    test(
      'when getSqliteColumnDefault is called with null, then it returns null',
      () {
        expect(ColumnType.decimal.getSqliteColumnDefault(null), isNull);
      },
    );

    test(
      'when sqliteSqlToAbstractDefault reads a quoted TEXT literal, then the quotes are stripped',
      () {
        expect(
          sqliteSqlToAbstractDefault("'10.5'", ColumnType.decimal),
          equals('10.5'),
        );
      },
    );

    test(
      'round-trip: writing then reading a decimal default is lossless',
      () {
        final written = ColumnType.decimal.getSqliteColumnDefault(
          '123456789.123456',
        );
        final recovered = sqliteSqlToAbstractDefault(
          written,
          ColumnType.decimal,
        );
        expect(recovered, equals('123456789.123456'));
      },
    );
  });
}
