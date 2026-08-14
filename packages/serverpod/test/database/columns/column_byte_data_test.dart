import 'dart:typed_data';

import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(PostgresValueEncoder());

  group('Given a ColumnByteData', () {
    var columnName = 'configuration';
    var column = ColumnByteData(columnName, Table<int?>(tableName: 'test'));

    test(
      'when toString is called then column name withing double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then ByteData is returned.', () {
      expect(column.type, ByteData);
    });
  });

  group('Given the PostgresValueEncoder', () {
    var encoder = PostgresValueEncoder();
    var column = ColumnByteData('data', Table<int?>(tableName: 'test'));
    var byteData = ByteData.view(
      Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7]).buffer,
    );

    test(
      'when a ByteData value is converted '
      'then a quoted bytea hex literal is returned.',
      () {
        expect(encoder.convert(byteData), "'\\x0001020304050607'");
      },
    );

    test(
      'when a serialized ByteData String is encoded for a ColumnByteData '
      'then a bytea hex literal is returned.',
      () {
        expect(
          encoder.encodeColumnValue(
            column,
            "decode('AAECAwQFBgc=', 'base64')",
          ),
          "'\\x0001020304050607'",
        );
      },
    );

    test(
      'when a ByteData value is encoded for a ColumnByteData '
      'then a bytea hex literal is returned.',
      () {
        expect(
          encoder.encodeColumnValue(column, byteData),
          "'\\x0001020304050607'",
        );
      },
    );

    test(
      'when a String shaped like a decode SQL expression is converted '
      'then it is escaped as an ordinary string literal, not emitted as SQL.',
      () {
        // A single-statement injection payload disguised as serialized ByteData
        const payload =
            "decode('','base64')::text OR 1=1 "
            "OR decode('','base64')=decode('', 'base64')";

        // A quoted literal with single quotes doubled
        expect(
          encoder.convert(payload),
          equals("'${payload.replaceAll("'", "''")}'"),
        );
      },
    );
  });
}
