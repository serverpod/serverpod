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

    group('with _ColumnDefaultOperations mixin', () {
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

  group('Given a ColumnSerializable containing a List', () {
    var columnName = 'values';
    var column = ColumnSerializable<List<int>>(
      columnName,
      Table<int?>(tableName: 'test'),
    );

    test(
      'when equals compared to List value then output is escaped equals expression.',
      () {
        var comparisonExpression = column.equals([1, 2, 3]);

        expect(comparisonExpression.toString(), '$column = \'[1,2,3]\'');
      },
    );

    test(
      'when NOT equals compared to List value then output is escaped NOT equals expression.',
      () {
        var comparisonExpression = column.notEquals([1, 2, 3]);

        expect(
          comparisonExpression.toString(),
          '$column IS DISTINCT FROM \'[1,2,3]\'',
        );
      },
    );

    test(
      'when checking if expression is in value set then output is IN expression.',
      () {
        var comparisonExpression = column.inSet({
          [1, 2],
          [3, 4],
        });

        expect(
          comparisonExpression.toString(),
          '$column IN (\'[1,2]\', \'[3,4]\')',
        );
      },
    );

    test(
      'when checking if expression is NOT in value set then output is NOT IN expression.',
      () {
        var comparisonExpression = column.notInSet({
          [1, 2],
          [3, 4],
        });

        expect(
          comparisonExpression.toString(),
          '($column NOT IN (\'[1,2]\', \'[3,4]\') OR $column IS NULL)',
        );
      },
    );
  });
}
