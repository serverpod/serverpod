import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnDuration expression', () {
    var columnName = 'age';
    var expression = ColumnDuration(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then Duration is returned.', () {
      expect(expression.type, Duration);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to duration value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(const Duration(hours: 10));

      expect(comparisonExpression.toString(), '"$columnName" = \'36000000\'');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to duration value then output is NOT equals expression.',
        () {
      var comparisonExpression =
          expression.notEquals(const Duration(hours: 10));

      expect(comparisonExpression.toString(), '"$columnName" != \'36000000\'');
    });

    test(
        'when checking if expression is in value set then output is IN expression.',
        () {
      var comparisonExpression = expression.inSet(<Duration>{
        const Duration(hours: 10),
        const Duration(hours: 11),
        const Duration(hours: 12),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" IN (\'36000000\', \'39600000\', \'43200000\')');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
      var comparisonExpression = expression.notInSet(<Duration>{
        const Duration(hours: 10),
        const Duration(hours: 11),
        const Duration(hours: 12),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (\'36000000\', \'39600000\', \'43200000\')');
    });
  });
}
