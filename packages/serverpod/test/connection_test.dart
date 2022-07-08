import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

Future<void> setupTestData(Client client) async {
  await client.basicDatabase.deleteAllSimpleTestData();
  await client.basicDatabase.createSimpleTestData(100);
}

ByteData createByteData() {
  var ints = Uint8List(256);
  for (var i = 0; i < 256; i++) {
    ints[i] = i;
  }
  return ByteData.view(ints.buffer);
}

void main() {
  var client = Client('http://serverpod_test_server:8080/');

  setUp(() {});

  group('Basic types', () {
    var dateTime = DateTime(1976, 9, 10, 2, 10);

    test('Simple calls', () async {
      await client.simple.setGlobalInt(10);
      await client.simple.addToGlobalInt();
      var value = await client.simple.getGlobalInt();
      expect(value, equals(11));
    });

    test('Type int', () async {
      var result = await client.basicTypes.testInt(10);
      expect(result, equals(10));
    });

    test('Type null int', () async {
      var result = await client.basicTypes.testInt(null);
      expect(result, isNull);
    });

    test('Type double', () async {
      var result = await client.basicTypes.testDouble(10.0);
      expect(result, equals(10.0));
    });

    test('Type null double', () async {
      var result = await client.basicTypes.testDouble(null);
      expect(result, isNull);
    });

    test('Type bool', () async {
      var result = await client.basicTypes.testBool(true);
      expect(result, equals(true));
    });

    test('Type null bool', () async {
      var result = await client.basicTypes.testBool(null);
      expect(result, isNull);
    });

    test('Type String', () async {
      var result = await client.basicTypes.testString('test');
      expect(result, 'test');
    });

    test('Type String with value \'null\'', () async {
      var result = await client.basicTypes.testString('null');
      expect(result, 'null');
    });

    test('Type null String', () async {
      var result = await client.basicTypes.testString(null);
      expect(result, isNull);
    });

    test('Type DateTime', () async {
      var result = await client.basicTypes.testDateTime(dateTime);
      expect(result!.toLocal(), equals(dateTime));
    });

    test('Type null DateTime', () async {
      var result = await client.basicTypes.testDateTime(null);
      expect(result, isNull);
    });

    test('Type ByteData', () async {
      var result = await client.basicTypes.testByteData(createByteData());
      expect(result!.lengthInBytes, equals(256));
    });

    test('Type null ByteData', () async {
      var result = await client.basicTypes.testByteData(null);
      expect(result, isNull);
    });
  });

  group('Database', () {
    test('Write and read', () async {
      var dateTime = DateTime(1976, 9, 10, 2, 10);

      // TODO: Support ByteData in database store
      var types = Types(
        aBool: true,
        aDouble: 1.5,
        anInt: 42,
        aDateTime: dateTime,
        aString: 'Foo',
        // aByteData: createByteData(),
      );

      var count = await client.basicDatabase.countTypesRows();
      expect(count, isNotNull);

      var id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      var newCount = await client.basicDatabase.countTypesRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      var storedTypes = await client.basicDatabase.getTypes(id!);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(id));

        expect(storedTypes.aBool, equals(true));
        expect(storedTypes.anInt, equals(42));
        expect(storedTypes.aDouble, equals(1.5));
        expect(storedTypes.aString, equals('Foo'));
        expect(storedTypes.aDateTime?.toLocal(), equals(dateTime));
        // expect(storedTypes.aByteData!.lengthInBytes, equals(256));
      }
    });

    test('Write and read null values', () async {
      var types = Types();

      var count = await client.basicDatabase.countTypesRows();
      expect(count, isNotNull);

      var id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      var newCount = await client.basicDatabase.countTypesRows();
      expect(newCount, isNotNull);
      expect(newCount, equals(count! + 1));

      var storedTypes = await client.basicDatabase.getTypes(id!);
      expect(storedTypes, isNotNull);

      if (storedTypes != null) {
        expect(storedTypes.id, equals(id));

        expect(storedTypes.aBool, isNull);
        expect(storedTypes.anInt, isNull);
        expect(storedTypes.aDouble, isNull);
        expect(storedTypes.aString, isNull);
        expect(storedTypes.aDateTime, isNull);
      }
    });

    test('Raw query', () async {
      var types = Types();

      var id = await client.basicDatabase.storeTypes(types);
      expect(id, isNotNull);

      var storedId = await client.basicDatabase.getTypesRawQuery(id!);
      expect(storedId, equals(id));
    });

    test('Delete all', () async {
      var removedRows = await client.basicDatabase.deleteAllInTypes();
      expect(removedRows, greaterThan(0));

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

      var success = await client.basicDatabase.findAndDeleteSimpleTestData(50);
      expect(success, equals(true));

      count = await client.basicDatabase.countSimpleData();
      expect(count, equals(99));
    });

    test('Find with limit', () async {
      await setupTestData(client);

      var list = await client.basicDatabase
          .findSimpleDataRowsLessThan(75, 25, 25, true);
      expect(list, isNotNull);
      expect(list!.rows, isNotNull);
      expect(list.rows.length, equals(25));
      expect(list.rows.first.num, equals(49));
      expect(list.rows.last.num, equals(25));

      list = await client.basicDatabase
          .findSimpleDataRowsLessThan(75, 25, 25, false);
      expect(list, isNotNull);
      expect(list!.rows, isNotNull);
      expect(list.rows.length, equals(25));
      expect(list.rows.first.num, equals(25));
      expect(list.rows.last.num, equals(49));

      list = await client.basicDatabase
          .findSimpleDataRowsLessThan(20, 0, 25, false);
      expect(list, isNotNull);
      expect(list!.rows, isNotNull);
      expect(list.rows.length, equals(20));
      expect(list.rows.first.num, equals(0));
      expect(list.rows.last.num, equals(19));
    });

    test('Update row', () async {
      await setupTestData(client);

      var result = await client.basicDatabase.updateSimpleDataRow(0, 1000);
      expect(result, isNotNull);
      expect(result, equals(true));

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

      var id = await client.basicDatabase.storeObjectWithObject(object);
      expect(id, isNotNull);

      var result = await client.basicDatabase.getObjectWithObject(id!);

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
  });

  group('Async tasks', () {
    test('Async database insert', () async {
      await setupTestData(client);

      await client.asyncTasks.insertRowToSimpleDataAfterDelay(1000, 1);
      var numRows = await client.basicDatabase.countSimpleData();
      expect(numRows, isNotNull);
      expect(numRows, equals(100));

      await Future.delayed(const Duration(seconds: 2));

      numRows = await client.basicDatabase.countSimpleData();
      expect(numRows, isNotNull);
      expect(numRows, equals(101));
    });

    test('Exception after delay', () async {
      await client.asyncTasks.throwExceptionAfterDelay(1);
      // TODO: Check that it is recorded in error logs.
    });
  });

  test('Distinct Column Values', () async {
    await client.basicDatabase.deleteAllInTypes();
    var types = [
      Types(id: 81, aString: 'Test', anInt: 1),
      Types(id: 82, aString: 'Test', anInt: 2),
      Types(id: 83, aString: 'Test_1', anInt: 3),
      Types(id: 84, aString: 'Test_1', anInt: 3),
    ];
    await Future.forEach(types,
        (Types type) async => await client.basicDatabase.storeTypes(type));
    var jsonResp = await client.basicDatabase.getDistinctTypesValueOnly();
    expect(
        jsonResp,
        jsonEncode([
          [2, 'Test'],
          [1, 'Test'],
          [3, 'Test_1']
        ]));
    var jsonResp2 = await client.basicDatabase.getDistinctTypesValue();
    expect(
        jsonResp2,
        jsonEncode([
          {
            'types': {'anInt': 2, 'aString': 'Test'}
          },
          {
            'types': {'anInt': 1, 'aString': 'Test'}
          },
          {
            'types': {'anInt': 3, 'aString': 'Test_1'}
          }
        ]));
  });

  test('Regular Expression Where type ', () async {
    var types = Types(aString: 'Anand Subbu');
    await client.basicDatabase.storeTypes(types);
    var type = await client.basicDatabase
        .getRegExTypes('(Anand|Alagu){1}', false, false);
    expect(type, 1);
    var typewithCaseSensitive = await client.basicDatabase
        .getRegExTypes('(anand|alagu){1}', true, false);
    expect(typewithCaseSensitive, 0);
    var typewithCaseSensitiveOpp = await client.basicDatabase
        .getRegExTypes('(Subbu|Alagu){1}', true, true);
    expect(typewithCaseSensitiveOpp! > 0, true);
  });

  test('Get Types With Query For One Column ', () async {
    var types = Types(aString: 'Test');
    var id = await client.basicDatabase.storeTypes(types);
    var count =
        await client.basicDatabase.getTypesWithWhereQuery(' = ANY(array[$id])');
    expect(count, 1);
  });

  test('Optional Where Query', () async {
    var types = Types(aString: 'Test');
    var id = await client.basicDatabase.storeTypes(types);
    var typeResp = await client.basicDatabase.optionalWhereQuery(id, null);
    expect(typeResp!.id, id);
    var typeResp2 =
        await client.basicDatabase.optionalWhereQuery(null, types.aString);
    expect(typeResp2!.aString, types.aString);
  });

  test('Insert/Update Batch of Data', () async {
    // To update test case if it supports list parameter
    var oldCount = await client.basicDatabase.countTypesRows();
    await client.basicDatabase.storeListOfTypes();
    var updatedCount = await client.basicDatabase.countTypesRows();
    expect(updatedCount!, oldCount! + 4);
  });

  group('Failed calls', () {
    test('Exception in call', () async {
      ServerpodClientException? clientException;
      try {
        await client.failedCalls.failedCall();
      } catch (e) {
        clientException = e as ServerpodClientException?;
      }

      expect(clientException, isNotNull);
      if (identical(0, 0.0)) {
        // Cannot always detect status code in web
        expect(clientException!.statusCode, equals(-1));
      } else {
        expect(clientException!.statusCode, equals(500));
      }
    });
  });
}
