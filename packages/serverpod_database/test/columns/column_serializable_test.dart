import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given a ColumnSerializable containing a String', () {
    var columnName = 'configuration';
    var column = ColumnSerializable<String>(
      columnName,
      Table<int?>(tableName: 'test'),
    );

    test(
      'when toString is called then column name withing double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then String is returned.', () {
      expect(column.type, String);
    });

    group('with _NullableColumnDefaultOperations mixin', () {
      test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
          var comparisonExpression = column.equals(null);

          expect(comparisonExpression.toString(), '$column IS NULL');
        },
      );

      test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
          var comparisonExpression = column.notEquals(null);

          expect(comparisonExpression.toString(), '$column IS NOT NULL');
        },
      );
    });
  });
}
