import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnSerializable', () {
    var columnName = 'configuration';
    var column = ColumnSerializable(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then String is returned.', () {
      expect(column.type, String);
    });
  });
}
