import 'package:serverpod/src/database/expressions.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given two columns right combined using two part expressions when retrieving columns',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression = firstColumn & (secondColumn | firstColumn);

    List<Column> columns = expression.columns;

    test('then all columns are represented.', () {
      expect(columns.length, 3);
    });

    test('then first columns is leftmost column.', () {
      expect(columns.first, firstColumn);
    }, skip: columns.length != 3);

    test('then second column is middle column.', () {
      expect(columns[1], secondColumn);
    }, skip: columns.length != 3);

    test('then last column is rightmost column.', () {
      expect(columns.last, firstColumn);
    }, skip: columns.length != 3);
  });

  group(
      'Given two columns left combined using two part expressions when retrieving columns',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression = (secondColumn | firstColumn) & firstColumn;

    List<Column> columns = expression.columns;

    test('then all columns are represented.', () {
      expect(columns.length, 3);
    });

    test('then first column is leftmost expression.', () {
      expect(columns.first, secondColumn);
    }, skip: columns.length != 3);

    test('then second expression is middle expression.', () {
      expect(columns[1], firstColumn);
    }, skip: columns.length != 3);

    test('then last expression is rightmost expression.', () {
      expect(columns.last, firstColumn);
    }, skip: columns.length != 3);
  });

  group('Given column BETWEEN expression when retrieving columns', () {
    ColumnInt column = ColumnInt('test 1');
    Expression expression = column.between(1, 2);

    List<Column> columns = expression.columns;

    test('then column is represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });

  group('Given column IN SET expression when retrieving columns', () {
    ColumnInt column = ColumnInt('test 1');
    Expression expression = column.inSet(<int>{1, 2});

    List<Column> columns = expression.columns;

    test('then column is represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });

  group(
      'Given column in BETWEEN and two part expression when retrieving columns',
      () {
    ColumnInt column = ColumnInt('test 1');
    Expression constant = Constant(true);
    Expression expression = column.between(1, 2) & constant;

    List<Column> columns = expression.columns;

    test('then all columns are represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });
}
