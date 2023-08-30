import 'package:serverpod/src/database/expressions.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given two columns right combined using two part expressions when retrieving nodes',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression = firstColumn & (secondColumn | firstColumn);

    List<Expression> expressions = expression.nodes;

    test('then all expressions are represented.', () {
      expect(expressions.length, 3);
    });

    test('then first expression is leftmost expression.', () {
      expect(expressions.first, firstColumn);
    }, skip: expressions.length != 3);

    test('then second expression is middle expression.', () {
      expect(expressions[1], secondColumn);
    }, skip: expressions.length != 3);

    test('then last expression is rightmost expression.', () {
      expect(expressions.last, firstColumn);
    }, skip: expressions.length != 3);
  });

  group(
      'Given two columns left combined using two part expressions when retrieving nodes',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression = (secondColumn | firstColumn) & firstColumn;

    List<Expression> expressions = expression.nodes;

    test('then all expressions are represented.', () {
      expect(expressions.length, 3);
    });

    test('then first expression is leftmost expression.', () {
      expect(expressions.first, secondColumn);
    }, skip: expressions.length != 3);

    test('then second expression is middle expression.', () {
      expect(expressions[1], firstColumn);
    }, skip: expressions.length != 3);

    test('then last expression is rightmost expression.', () {
      expect(expressions.last, firstColumn);
    }, skip: expressions.length != 3);
  });

  group('Given column BETWEEN expression when retrieving nodes', () {
    ColumnInt column = ColumnInt('test 1');
    Expression expression = column.between(1, 2);

    List<Expression> expressions = expression.nodes;

    test('then all expressions are represented.', () {
      expect(expressions.length, 3);
    });

    test('then first expression is column.', () {
      expect(expressions.first, column);
    }, skip: expressions.length != 3);

    test('then second expression is min value.', () {
      expect(expressions[1].toString(), '1');
    }, skip: expressions.length != 3);
    test('then third expression is max value.', () {
      expect(expressions[2].toString(), '2');
    }, skip: expressions.length != 3);
  });

  group('Given column IN SET expression when retrieving nodes', () {
    ColumnInt column = ColumnInt('test 1');
    Expression expression = column.inSet(<int>{1, 2});

    List<Expression> expressions = expression.nodes;

    test('then all expressions are represented.', () {
      expect(expressions.length, 3);
    });

    test('then first expression is column.', () {
      expect(expressions.first, column);
    }, skip: expressions.length != 3);

    test('then second expression is first value of set.', () {
      expect(expressions[1].toString(), '1');
    }, skip: expressions.length != 3);
    test('then third expression is second value of value.', () {
      expect(expressions[2].toString(), '2');
    }, skip: expressions.length != 3);
  });

  group('Given column in BETWEEN and two part expression when retrieving nodes',
      () {
    ColumnInt column = ColumnInt('test 1');
    Expression constant = Constant(true);
    Expression expression = column.between(1, 2) & constant;

    List<Expression> expressions = expression.nodes;

    test('then all expressions are represented.', () {
      expect(expressions.length, 4);
    });

    test('then first expression is column.', () {
      expect(expressions.first, column);
    }, skip: expressions.length != 4);

    test('then second expression is min value.', () {
      expect(expressions[1].toString(), '1');
    }, skip: expressions.length != 4);
    test('then third expression is max value.', () {
      expect(expressions[2].toString(), '2');
    }, skip: expressions.length != 4);

    test('then forth expression is constant.', () {
      expect(expressions[3], constant);
    }, skip: expressions.length != 4);
  });
}
