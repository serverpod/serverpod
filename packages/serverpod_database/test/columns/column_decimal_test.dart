import 'package:decimal/decimal.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(PostgresValueEncoder());

  group('Given a ColumnDecimal', () {
    var columnName = 'amount';
    var column = ColumnDecimal(columnName, Table<int?>(tableName: 'test'));

    test(
      'when type is called then Decimal is returned.',
      () {
        expect(column.type, Decimal);
      },
    );

    test(
      'when equals compared to Decimal value then output is equals expression.',
      () {
        var comparisonExpression = column.equals(
          Decimal.parse('123456789.123456789012345678'),
        );

        expect(
          comparisonExpression.toString(),
          '$column = \'123456789.123456789012345678\'',
        );
      },
    );

    test(
      'when notEquals compared to null then output is IS NOT NULL expression.',
      () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      },
    );

    test(
      'when greater than compared to Decimal value then output is operator expression.',
      () {
        var comparisonExpression = column > Decimal.parse('10.50');

        expect(comparisonExpression.toString(), '$column > \'10.5\'');
      },
    );

    test(
      'when checking between Decimal values then output is BETWEEN expression.',
      () {
        var comparisonExpression = column.between(
          Decimal.parse('-1.0'),
          Decimal.parse('1.0'),
        );

        expect(
          comparisonExpression.toString(),
          '$column BETWEEN \'-1\' AND \'1\'',
        );
      },
    );
  });
}
