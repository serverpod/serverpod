import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

Future<void> setupTestData(Client client) async {
  await client.basicDatabase.deleteAllSimpleTestData();
  await client.basicDatabase.createSimpleTestData(100);
}

void main() {
  var client = Client(serverUrl);

  group('Database', () {
    test('Write and read', () async {
      var dateTime = DateTime.utc(1976, 9, 10, 2, 10);
      var duration = const Duration(seconds: 1);
      var uuid = UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');
      var bigInt = BigInt.parse('18446744073709551615999');

      // TODO: Support ByteData in database store
      var types = Types(
        aBool: true,
        aDouble: 1.5,
        anInt: 42,
        aDateTime: dateTime,
        aDuration: duration,
        aString: 'Foo',
        aUuid: uuid,
        aBigInt: bigInt,
        // aByteData: _createByteData(),
      );

      var count = await client.basicDatabase.countTypesRows();
      expect(count, isNotNull);

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var newCount = await client.basicDatabase.countTypesRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(types.id));

        expect(storedTypes.aBool, equals(true));
        expect(storedTypes.anInt, equals(42));
        expect(storedTypes.aDouble, equals(1.5));
        expect(storedTypes.aString, equals('Foo'));
        expect(storedTypes.aDateTime, equals(dateTime));
        expect(storedTypes.aDuration, equals(duration));
        expect(storedTypes.aUuid, equals(uuid));
        expect(storedTypes.aBigInt, equals(bigInt));
        // expect(storedTypes.aByteData!.lengthInBytes, equals(256));
      }
    });

    test('Write and read null values', () async {
      var types = Types();

      var count = await client.basicDatabase.countTypesRows();
      expect(count, isNotNull);

      types = await client.basicDatabase.insertTypes(types);
      expect(types.id, isNotNull);

      var newCount = await client.basicDatabase.countTypesRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      var storedTypes = await client.basicDatabase.getTypes(types.id!);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(types.id));

        expect(storedTypes.aBool, isNull);
        expect(storedTypes.anInt, isNull);
        expect(storedTypes.aDouble, isNull);
        expect(storedTypes.aString, isNull);
        expect(storedTypes.aDateTime, isNull);
        expect(storedTypes.aDuration, isNull);
        expect(storedTypes.aUuid, isNull);
      }
    });

    test('Write and read enums', () async {
      var object =
          ObjectWithEnum(testEnum: TestEnum.two, nullableEnum: null, enumList: [
        TestEnum.one,
        TestEnum.two,
        TestEnum.three
      ], nullableEnumList: [
        TestEnum.one,
        null,
        TestEnum.three
      ], enumListList: [
        [TestEnum.one, TestEnum.two],
        [TestEnum.two, TestEnum.one]
      ]);

      object = await client.basicDatabase.storeObjectWithEnum(object);
      expect(object.id, isNotNull);

      var returnedObject =
          await client.basicDatabase.getObjectWithEnum(object.id!);
      expect(returnedObject, isNotNull);
      expect(returnedObject!.testEnum, equals(TestEnum.two));
      expect(returnedObject.enumListList.length, equals(2));
      expect(returnedObject.enumListList[0].length, equals(2));
      expect(returnedObject.enumListList[0][0], equals(TestEnum.one));
      expect(returnedObject.enumListList[0][1], equals(TestEnum.two));
      expect(returnedObject.enumListList[1].length, equals(2));
      expect(returnedObject.enumListList[1][0], equals(TestEnum.two));
      expect(returnedObject.enumListList[1][1], equals(TestEnum.one));
    });

    test('Raw query', () async {
      var types = Types();
      types = await client.basicDatabase.insertTypes(types);

      expect(types.id, isNotNull);

      var storedId = await client.basicDatabase.getTypesRawQuery(types.id!);
      expect(storedId, equals(types.id));
    });

    test('Delete all', () async {
      var removedRows = await client.basicDatabase.deleteAllInTypes();
      expect(removedRows, isNotEmpty);

      var count = await client.basicDatabase.countTypesRows();
      expect(count, equals(0));
    });

    test('Delete where', () async {
      await setupTestData(client);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, equals(100));

      await client.basicDatabase.deleteSimpleTestDataLessThan(50);
      count = await client.basicDatabase.countSimpleData();
      expect(count, equals(50));
    });

    test('Delete single row', () async {
      await setupTestData(client);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, equals(100));

      await client.basicDatabase.findAndDeleteSimpleTestData(50);

      count = await client.basicDatabase.countSimpleData();
      expect(count, equals(99));
    });

    test('Update row', () async {
      await setupTestData(client);

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

    test('Simple transaction', () async {
      await setupTestData(client);

      await client.transactionsDatabase.removeRow(50);

      var count = await client.basicDatabase.countSimpleData();
      expect(count, isNotNull);
      expect(count, equals(99));
    });

    test('Complex transaction', () async {
      await setupTestData(client);

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

    test('Store object with object', () async {
      var object = ObjectWithObject(
        data: SimpleData(num: 42),
        dataList: [SimpleData(num: 10), SimpleData(num: 20)],
        listWithNullableData: [SimpleData(num: 10), null],
      );

      object = await client.basicDatabase.storeObjectWithObject(object);
      expect(object.id, isNotNull);

      var result = await client.basicDatabase.getObjectWithObject(object.id!);

      expect(result, isNotNull);
      expect(result!.data.num, equals(42));
      expect(result.nullableData, isNull);

      expect(result.dataList.length, equals(2));
      expect(result.dataList[0].num, equals(10));
      expect(result.dataList[1].num, equals(20));

      expect(result.listWithNullableData.length, equals(2));
      expect(result.listWithNullableData[0]!.num, equals(10));
      expect(result.listWithNullableData[1], isNull);

      expect(result.nullableDataList, isNull);
      expect(result.nullableListWithNullableData, isNull);
    });

    test('Field scopes', () async {
      var object = ObjectFieldScopes(
        normal: 'test normal',
        api: 'test api',
      );

      await client.fieldScopes.storeObject(object);

      var result = await client.fieldScopes.retrieveObject();

      expect(result, isNotNull);
      expect(result!.normal, equals('test normal'));
      expect(result.api, isNull);
    });

    test('Write and read ByteData', () async {
      var result = await client.basicDatabase.testByteDataStore();

      expect(result, equals(true));
    });
  });
}
