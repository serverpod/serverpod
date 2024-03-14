import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given int and big int column definition', () {
    ColumnDefinition intColumn = ColumnDefinition(
      name: 'id',
      columnType: ColumnType.integer,
      isNullable: false,
      dartType: 'int',
    );

    ColumnDefinition bigIntColumn = ColumnDefinition(
      name: 'id',
      columnType: ColumnType.bigint,
      isNullable: false,
      dartType: 'int',
    );
    test(
        'when like checking int column to big int column then check returns true.',
        () {
      expect(intColumn.like(bigIntColumn), isTrue);
    });

    test(
        'when like checking big int column to int column then check returns true.',
        () {
      expect(bigIntColumn.like(intColumn), isTrue);
    });
  });
}
