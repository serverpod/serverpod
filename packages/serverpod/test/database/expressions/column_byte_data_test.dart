import 'dart:typed_data';

import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnByteData expression', () {
    var columnName = 'configuration';
    var expression = ColumnByteData(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then ByteData is returned.', () {
      expect(expression.type, ByteData);
    });
  });
}
