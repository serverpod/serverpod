import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

Future<void> _setupTestData(Client client) async {
  await client.basicDatabase.deleteAllSimpleTestData();
  await client.basicDatabase.createSimpleTestData(100);
}

void main() {
  var client = Client(serverUrl);

  group('Given the database-roundtrip/echo server', () {
    test(
        'When inserting a new object, then it can be read via a raw query on the server',
        () async {
      var types = Types();
      types = await client.basicDatabase.insertTypes(types);

      expect(types.id, isNotNull);

      var storedId = await client.basicDatabase.getTypesRawQuery(types.id!);
      expect(storedId, equals(types.id));
    });

    test('When all "Type" objects are removed, then the count will be 0',
        () async {
      var removedRows = await client.basicDatabase.deleteAllInTypes();
      expect(removedRows, isNotEmpty);

      var count = await client.basicDatabase.countTypesRows();
      expect(count, equals(0));
    });

    test(
        'When half of the test data are deleted using `WHERE`, then the count will be halved',
        () async {
      await _setupTestData(client);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, equals(100));

      await client.basicDatabase.deleteSimpleTestDataLessThan(50);
      count = await client.basicDatabase.countSimpleData();
      expect(count, equals(50));
    });

    test(
        'When a single object is deleted by ID, then the count is reduced by 1',
        () async {
      await _setupTestData(client);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, equals(100));

      await client.basicDatabase.findAndDeleteSimpleTestData(50);

      count = await client.basicDatabase.countSimpleData();
      expect(count, equals(99));
    });

    test('When a single row is updated, then the count is unaffected',
        () async {
      await _setupTestData(client);

      var oldRow = await client.basicDatabase.findFirstRowSimpleData(0);
      expect(oldRow, isNotNull);

      var newRow = oldRow!.copyWith(num: 1000);
      var result = await client.basicDatabase.updateRowSimpleData(newRow);
      expect(result.id, isNotNull);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, isNotNull);
      expect(count, equals(100));

      var list = await client.basicDatabase
          .findSimpleDataRowsLessThan(100, 0, 100, true);
      expect(list, isNotNull);
      expect(list!.rows.length, equals(99));
    });

    test(
        'When a single item is removed in a transaction, then the count is reduced by one',
        () async {
      await _setupTestData(client);

      await client.transactionsDatabase.removeRow(50);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, isNotNull);
      expect(count, equals(99));
    });

    test(
        'When many items are modified in a single transaction, then the operation succeeds',
        () async {
      await _setupTestData(client);

      bool? result =
          await client.transactionsDatabase.updateInsertDelete(50, 500, 0);
      expect(result, isNotNull);
      expect(result, equals(true));

      var list = await client.basicDatabase
          .findSimpleDataRowsLessThan(10000, 0, 200, false);
      expect(list, isNotNull);
      expect(list!.rows.length, equals(100));

      expect(list.rows.first.num, equals(1));
      expect(list.rows[98].num, equals(500));
      expect(list.rows.last.num, equals(1000));
    });
  });
}
