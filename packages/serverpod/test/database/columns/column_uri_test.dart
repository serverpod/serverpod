import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnUri', () {
    var columnName = 'uri';
    var column = ColumnUri(columnName, Table<int?>(tableName: 'test'));

    test(
      'when toString is called then column name withing double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then Uri is returned.', () {
      expect(column.type, Uri);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
          var comparisonExpression = column.equals(null);

          expect(comparisonExpression.toString(), '$column IS NULL');
        },
      );

      test('when equals compared to uri then output is equals expression.', () {
        var comparisonExpression = column.equals(
          Uri.parse('https://serverpod.dev/'),
        );

        expect(
          comparisonExpression.toString(),
          '$column = \'https://serverpod.dev/\'',
        );
      });

      test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
          var comparisonExpression = column.notEquals(null);

          expect(comparisonExpression.toString(), '$column IS NOT NULL');
        },
      );

      test(
        'when NOT equals compared to uri then output is NOT equals expression.',
        () {
          var comparisonExpression = column.notEquals(
            Uri.parse('https://serverpod.dev/'),
          );

          expect(
            comparisonExpression.toString(),
            '$column IS DISTINCT FROM \'https://serverpod.dev/\'',
          );
        },
      );

      test(
        'when checking if expression is in value set then output is IN expression.',
        () {
          var comparisonExpression = column.inSet(<Uri>{
            Uri.parse('https://serverpod.dev/'),
            Uri.parse('https://docs.serverpod.dev/'),
          });

          expect(
            comparisonExpression.toString(),
            '$column IN (\'https://serverpod.dev/\', \'https://docs.serverpod.dev/\')',
          );
        },
      );

      test(
        'when checking if expression is in empty value set then output is FALSE expression.',
        () {
          var comparisonExpression = column.inSet(<Uri>{});

          expect(comparisonExpression.toString(), 'FALSE');
        },
      );

      test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
          var comparisonExpression = column.notInSet(<Uri>{
            Uri.parse('https://serverpod.dev/'),
            Uri.parse('https://docs.serverpod.dev/'),
          });

          expect(
            comparisonExpression.toString(),
            '($column NOT IN (\'https://serverpod.dev/\', \'https://docs.serverpod.dev/\') OR $column IS NULL)',
          );
        },
      );

      test(
        'when checking if expression is NOT in empty value set then output is TRUE expression.',
        () {
          var comparisonExpression = column.notInSet(<Uri>{});

          expect(comparisonExpression.toString(), 'TRUE');
        },
      );
    });
  });
}
