import 'dart:typed_data';

import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnByteData', () {
    var columnName = 'configuration';
    var column = ColumnByteData(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then ByteData is returned.', () {
      expect(column.type, ByteData);
    });
  });
}
