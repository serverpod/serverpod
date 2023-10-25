import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');
  var relationTable = Table(
    tableName: companyTable.tableName,
    tableRelation: TableRelation([
      TableRelationEntry(
        relationAlias: 'company',
        field: ColumnInt('id', citizenTable),
        foreignField: ColumnInt('id', companyTable),
      )
    ]),
  );

  group('Given a ColumnCount', () {
    var column = ColumnCount(null, relationTable.id);
    var countColumnInExpression =
        column.wrapInOperation(relationTable.id.toString());

    test(
        'when toString is called then column name withing count expression is returned.',
        () {
      expect(column.toString(),
          '"citizen_company_company"."${companyTable.id.columnName}"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, companyTable.id.columnName);
    });

    test('when type is called then int is returned.', () {
      expect(column.type, int);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to int value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(10);

        expect(
            comparisonExpression.toString(), '$countColumnInExpression = 10');
      });

      test(
          'when NOT equals compared to int value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(10);

        expect(
            comparisonExpression.toString(), '$countColumnInExpression != 10');
      });

      test(
          'when checking if expression is between int values then output is between expression.',
          () {
        var comparisonExpression = column.between(10, 20);

        expect(comparisonExpression.toString(),
            '$countColumnInExpression BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is NOT between int value then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(10, 20);

        expect(comparisonExpression.toString(),
            '$countColumnInExpression NOT BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<int>{10, 11, 12});

        expect(comparisonExpression.toString(),
            '$countColumnInExpression IN (10, 11, 12)');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<int>{10, 11, 12});

        expect(comparisonExpression.toString(),
            '$countColumnInExpression NOT IN (10, 11, 12)');
      });
    });

    group('with _ColumnNumberOperations mixin', () {
      test(
          'when checking if expression is between int values then output is between expression.',
          () {
        var comparisonExpression = column.between(10, 20);

        expect(comparisonExpression.toString(),
            '$countColumnInExpression BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is NOT between int values then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(10, 20);

        expect(comparisonExpression.toString(),
            '$countColumnInExpression NOT BETWEEN 10 AND 20');
      });

      test(
          'when greater than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column > const Expression('10');

        expect(
            comparisonExpression.toString(), '$countColumnInExpression > 10');
      });

      test(
          'when greater than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column > 10;

        expect(
            comparisonExpression.toString(), '$countColumnInExpression > 10');
      });

      test(
          'when greater than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column > column;

        expect(comparisonExpression.toString(),
            '$countColumnInExpression > $column');
      });

      test(
          'when greater than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column > 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$countColumnInExpression > \'string is unhandled\'');
      });

      test(
          'when greater or equal than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column >= const Expression('10');

        expect(
            comparisonExpression.toString(), '$countColumnInExpression >= 10');
      });

      test(
          'when greater or equal than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column >= 10;

        expect(
            comparisonExpression.toString(), '$countColumnInExpression >= 10');
      });

      test(
          'when greater or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column >= column;

        expect(comparisonExpression.toString(),
            '$countColumnInExpression >= $column');
      });

      test(
          'when greater or equal than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column >= 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$countColumnInExpression >= \'string is unhandled\'');
      });

      test(
          'when less than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column < const Expression('10');

        expect(
            comparisonExpression.toString(), '$countColumnInExpression < 10');
      });

      test(
          'when less than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column < 10;

        expect(
            comparisonExpression.toString(), '$countColumnInExpression < 10');
      });

      test(
          'when less than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column < column;

        expect(comparisonExpression.toString(),
            '$countColumnInExpression < $column');
      });

      test(
          'when less than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column < 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$countColumnInExpression < \'string is unhandled\'');
      });

      test(
          'when less or equal than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column <= const Expression('10');

        expect(
            comparisonExpression.toString(), '$countColumnInExpression <= 10');
      });

      test(
          'when less or equal than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column <= 10;

        expect(
            comparisonExpression.toString(), '$countColumnInExpression <= 10');
      });

      test(
          'when less or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column <= column;

        expect(comparisonExpression.toString(),
            '$countColumnInExpression <= $column');
      });

      test(
          'when less or equal than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column <= 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$countColumnInExpression <= \'string is unhandled\'');
      });
    });
  });
}
