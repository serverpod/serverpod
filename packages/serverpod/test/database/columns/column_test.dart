import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given column with query prefix', () {
    var column = ColumnString('test', queryPrefix: 'citizen');

    test('when toString is called then query prefix is included.', () {
      expect(column.toString(), 'citizen."test"');
    });

    test('when queryAlias is called then column name is not in double quotes.',
        () {
      expect(column.queryAlias, 'citizen.test');
    });
  });

  group('Given expression built by columns with query prefixes', () {
    // Emulating where a citizen has a relation to company through a company
    // field.
    var citizenColumn = ColumnInt('score', queryPrefix: 'citizen');
    var companyColumn =
        ColumnInt('score', queryPrefix: 'citizen_company_company');
    Expression expression = citizenColumn < companyColumn;

    test('when toString is called then query prefixes are included.', () {
      expect(expression.toString(),
          '(citizen."score" < citizen_company_company."score")');
    });
  });
}
