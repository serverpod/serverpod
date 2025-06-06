import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnUuid', () {
    var columnName = 'id';
    var column = ColumnUuid(columnName, Table<int?>(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then UuidValue is returned.', () {
      expect(column.type, UuidValue);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to uuid value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(
          // ignore: deprecated_member_use
          UuidValue.fromString(Uuid.NAMESPACE_NIL),
        );

        expect(
          comparisonExpression.toString(),
          '$column = \'00000000-0000-0000-0000-000000000000\'',
        );
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to uuid value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(
          // ignore: deprecated_member_use
          UuidValue.fromString(Uuid.NAMESPACE_NIL),
        );

        expect(comparisonExpression.toString(),
            '$column IS DISTINCT FROM \'00000000-0000-0000-0000-000000000000\'');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<UuidValue>{
          UuidValue.fromString('testUuid1'),
          UuidValue.fromString('testUuid2'),
          UuidValue.fromString('testUuid3'),
        });

        expect(comparisonExpression.toString(),
            '$column IN (\'testuuid1\', \'testuuid2\', \'testuuid3\')');
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<UuidValue>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<UuidValue>{
          UuidValue.fromString('testUuid1'),
          UuidValue.fromString('testUuid2'),
          UuidValue.fromString('testUuid3'),
        });

        expect(
          comparisonExpression.toString(),
          '($column NOT IN (\'testuuid1\', \'testuuid2\', \'testuuid3\') OR $column IS NULL)',
        );
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<UuidValue>{});

        expect(comparisonExpression.toString(), 'TRUE');
      });
    });

    test(
        'when greater than compared to expression then output is operator expression.',
        () {
      var comparisonExpression = column > const Expression('10');

      expect(comparisonExpression.toString(), '$column > 10');
    });

    test(
        'when greater than compared to column type then output is operator expression.',
        () {
      var comparisonExpression = column > UuidValue.fromString('testUuid1');

      expect(comparisonExpression.toString(), '$column > \'testuuid1\'');
    });

    test(
        'when greater than compared to column then output is operator expression.',
        () {
      var comparisonExpression = column > column;

      expect(comparisonExpression.toString(), '$column > $column');
    });

    test(
        'when greater than compared to unhandled type then argument error is thrown.',
        () {
      expect(
        () => column > 'string is unhandled',
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Invalid type for comparison: String, allowed types are Expression, UuidValue or Column',
          ),
        ),
      );
    });

    test(
        'when greater or equal than compared to expression then output is operator expression.',
        () {
      var comparisonExpression = column >= const Expression('10');

      expect(comparisonExpression.toString(), '$column >= 10');
    });

    test(
        'when greater or equal than compared to column type then output is operator expression.',
        () {
      var comparisonExpression = column >= UuidValue.fromString('testUuid1');

      expect(comparisonExpression.toString(), '$column >= \'testuuid1\'');
    });

    test(
        'when greater or equal than compared to column then output is operator expression.',
        () {
      var comparisonExpression = column >= column;

      expect(comparisonExpression.toString(), '$column >= $column');
    });

    test(
        'when greater or equal than compared to unhandled type then argument error is thrown.',
        () {
      expect(
        () => column >= 'string is unhandled',
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Invalid type for comparison: String, allowed types are Expression, UuidValue or Column',
          ),
        ),
      );
    });

    test(
        'when less than compared to expression then output is operator expression.',
        () {
      var comparisonExpression = column < const Expression('10');

      expect(comparisonExpression.toString(), '$column < 10');
    });

    test(
        'when less than compared to column type then output is operator expression.',
        () {
      var comparisonExpression = column < UuidValue.fromString('testUuid1');

      expect(comparisonExpression.toString(), '$column < \'testuuid1\'');
    });

    test(
        'when less than compared to column then output is operator expression.',
        () {
      var comparisonExpression = column < column;

      expect(comparisonExpression.toString(), '$column < $column');
    });

    test(
        'when less than compared to unhandled type then argument error is thrown.',
        () {
      expect(
        () => column < 'string is unhandled',
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Invalid type for comparison: String, allowed types are Expression, UuidValue or Column',
          ),
        ),
      );
    });

    test(
        'when less or equal than compared to expression then output is operator expression.',
        () {
      var comparisonExpression = column <= const Expression('10');

      expect(comparisonExpression.toString(), '$column <= 10');
    });

    test(
        'when less or equal than compared to column type then output is operator expression.',
        () {
      var comparisonExpression = column <= UuidValue.fromString('testUuid1');

      expect(comparisonExpression.toString(), '$column <= \'testuuid1\'');
    });

    test(
        'when less or equal than compared to column then output is operator expression.',
        () {
      var comparisonExpression = column <= column;

      expect(comparisonExpression.toString(), '$column <= $column');
    });

    test(
        'when less or equal than compared to unhandled type then argument error is thrown.',
        () {
      expect(
        () => column <= 'string is unhandled',
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Invalid type for comparison: String, allowed types are Expression, UuidValue or Column',
          ),
        ),
      );
    });
  });
}
