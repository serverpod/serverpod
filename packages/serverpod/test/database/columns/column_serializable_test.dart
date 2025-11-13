import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
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
  });
}
