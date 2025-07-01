import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_shared/serverpod_test_shared.dart';
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
  var client = Client(serverUrl);

  group('Calls', () {
    test(
        'Given the test server, when the global int is set to 10 and 1 is added, then 11 is returned',
        () async {
      await client.simple.setGlobalInt(10);
      await client.simple.addToGlobalInt();
      var value = await client.simple.getGlobalInt();
      expect(value, equals(11));
    });

    test('Named parameters basic call', () async {
      var result = await client.namedParameters.namedParametersMethod(
        namedInt: 42,
        intWithDefaultValue: 42,
      );
      expect(result, equals(true));
    });

    test('Named parameters equal', () async {
      var result = await client.namedParameters.namedParametersMethodEqualInts(
        namedInt: 42,
        nullableInt: 42,
      );
      expect(result, equals(true));
    });

    test('Named parameters not equal', () async {
      var result = await client.namedParameters.namedParametersMethodEqualInts(
        namedInt: 42,
      );
      expect(result, equals(false));

      result = await client.namedParameters.namedParametersMethodEqualInts(
        namedInt: 42,
        nullableInt: 1337,
      );
      expect(result, equals(false));
    });

    test('Optional parameters ignored', () async {
      var result = await client.optionalParameters.returnOptionalInt();
      expect(result, isNull);
    });

    test('Optional parameters set to value', () async {
      var result = await client.optionalParameters.returnOptionalInt(42);
      expect(result, 42);
    });

    test('Optional parameters set to null', () async {
      var result = await client.optionalParameters.returnOptionalInt(null);
      expect(result, null);
    });

    test('List<int> parameter and return type', () async {
      var result = await client.listParameters.returnIntList([0, 1, 2]);
      expect(result.length, equals(3));
      expect(result[0], equals(0));
      expect(result[1], equals(1));
      expect(result[2], equals(2));
    });

    test('List<List<int>> parameter and return type', () async {
      var result = await client.listParameters.returnIntListList([
        [0, 1, 2],
        [3, 4, 5]
      ]);
      expect(result.length, equals(2));
      expect(result[0].length, equals(3));
      expect(result[0][0], equals(0));
      expect(result[0][1], equals(1));
      expect(result[0][2], equals(2));
      expect(result[1].length, equals(3));
      expect(result[1][0], equals(3));
      expect(result[1][1], equals(4));
      expect(result[1][2], equals(5));
    });

    test('List<int>? parameter and return type', () async {
      var result = await client.listParameters.returnIntListNullable([0, 1, 2]);
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result[0], equals(0));
      expect(result[1], equals(1));
      expect(result[2], equals(2));

      result = await client.listParameters.returnIntListNullable(null);
      expect(result, isNull);
    });

    test('List<List<int>?> parameter and return type', () async {
      var result = await client.listParameters.returnIntListNullableList([
        [0, 1, 2],
        null
      ]);
      expect(result.length, equals(2));
      expect(result[0], isNotNull);
      expect(result[0]!.length, equals(3));
      expect(result[0]![0], equals(0));
      expect(result[0]![1], equals(1));
      expect(result[0]![2], equals(2));
      expect(result[1], isNull);
    });

    test('List<List<int>>? parameter and return type', () async {
      var result = await client.listParameters.returnIntListListNullable([
        [0, 1, 2],
        [3, 4, 5]
      ]);
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result[0].length, equals(3));
      expect(result[0][0], equals(0));
      expect(result[0][1], equals(1));
      expect(result[0][2], equals(2));
      expect(result[1].length, equals(3));
      expect(result[1][0], equals(3));
      expect(result[1][1], equals(4));
      expect(result[1][2], equals(5));

      result = await client.listParameters.returnIntListListNullable(null);
      expect(result, isNull);
    });

    test('List<int?> parameter and return type', () async {
      var result =
          await client.listParameters.returnIntListNullableInts([0, null, 2]);
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0], equals(0));
      expect(result[1], isNull);
      expect(result[2], equals(2));
    });

    test('List<int?>? parameter and return type', () async {
      var result = await client.listParameters
          .returnNullableIntListNullableInts([0, null, 2]);
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result[0], equals(0));
      expect(result[1], isNull);
      expect(result[2], equals(2));

      result =
          await client.listParameters.returnNullableIntListNullableInts(null);
      expect(result, isNull);
    });

    test('List<double> parameter and return type', () async {
      var result =
          await client.listParameters.returnDoubleList([0.0, 1.0, 2.0]);
      expect(result.length, equals(3));
      expect(result[0], equals(0.0));
      expect(result[1], equals(1.0));
      expect(result[2], equals(2.0));
    });

    test('List<double?> parameter and return type', () async {
      var result = await client.listParameters.returnDoubleListNullableDoubles(
        [0.0, null, 2.0],
      );
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0], equals(0.0));
      expect(result[1], isNull);
      expect(result[2], equals(2.0));
    });

    test('List<bool> parameter and return type', () async {
      var result = await client.listParameters.returnBoolList([false, true]);
      expect(result.length, equals(2));
      expect(result[0], equals(false));
      expect(result[1], equals(true));
    });

    test('List<bool?> parameter and return type', () async {
      var result = await client.listParameters.returnBoolListNullableBools(
        [false, null, true],
      );
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0], equals(false));
      expect(result[1], isNull);
      expect(result[2], equals(true));
    });

    test('List<String> parameter and return type', () async {
      var result = await client.listParameters.returnStringList(
        ['A', 'B', 'C'],
      );
      expect(result.length, equals(3));
      expect(result[0], equals('A'));
      expect(result[1], equals('B'));
      expect(result[2], equals('C'));
    });

    test('List<String?> parameter and return type', () async {
      var result = await client.listParameters.returnStringListNullableStrings(
        ['A', null, 'C'],
      );
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0], equals('A'));
      expect(result[1], isNull);
      expect(result[2], equals('C'));
    });

    test('List<DateTime> parameter and return type', () async {
      var result = await client.listParameters.returnDateTimeList([
        DateTime.utc(2020),
        DateTime.utc(2021),
        DateTime.utc(2022),
      ]);
      expect(result.length, equals(3));
      expect(result[0], equals(DateTime.utc(2020)));
      expect(result[1], equals(DateTime.utc(2021)));
      expect(result[2], equals(DateTime.utc(2022)));
    });

    test('List<DateTime?> parameter and return type', () async {
      var result =
          await client.listParameters.returnDateTimeListNullableDateTimes([
        DateTime.utc(2020),
        null,
        DateTime.utc(2022),
      ]);
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0], equals(DateTime.utc(2020)));
      expect(result[1], isNull);
      expect(result[2], equals(DateTime.utc(2022)));
    });

    test('List<ByteData> parameter and return type', () async {
      var result = await client.listParameters.returnByteDataList([
        createByteData(),
        createByteData(),
        createByteData(),
      ]);
      expect(result.length, equals(3));
      expect(result[0].lengthInBytes, equals(256));
      expect(result[1].lengthInBytes, equals(256));
      expect(result[2].lengthInBytes, equals(256));
    });

    test('List<ByteData?> parameter and return type', () async {
      var result =
          await client.listParameters.returnByteDataListNullableByteDatas([
        createByteData(),
        null,
        createByteData(),
      ]);
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0]!.lengthInBytes, equals(256));
      expect(result[1], isNull);
      expect(result[2]!.lengthInBytes, equals(256));
    });

    test('List<SimpleData> parameter and return type', () async {
      var result = await client.listParameters.returnSimpleDataList([
        SimpleData(num: 0),
        SimpleData(num: 1),
        SimpleData(num: 2),
      ]);
      expect(result.length, equals(3));
      expect(result[0].num, equals(0));
      expect(result[1].num, equals(1));
      expect(result[2].num, equals(2));
    });

    test('List<SimpleData?> parameter and return type', () async {
      var result =
          await client.listParameters.returnSimpleDataListNullableSimpleData([
        SimpleData(num: 0),
        null,
        SimpleData(num: 2),
      ]);
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0]!.num, equals(0));
      expect(result[1], isNull);
      expect(result[2]!.num, equals(2));
    });

    test('List<SimpleData>? parameter and return type', () async {
      var result = await client.listParameters.returnSimpleDataListNullable([
        SimpleData(num: 0),
        SimpleData(num: 1),
        SimpleData(num: 2),
      ]);
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result[0].num, equals(0));
      expect(result[1].num, equals(1));
      expect(result[2].num, equals(2));

      result = await client.listParameters.returnSimpleDataListNullable(null);
      expect(result, isNull);
    });

    test('List<SimpleData?>? parameter and return type', () async {
      var result = await client.listParameters
          .returnNullableSimpleDataListNullableSimpleData([
        SimpleData(num: 0),
        null,
        SimpleData(num: 2),
      ]);
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result[0]!.num, equals(0));
      expect(result[1], isNull);
      expect(result[2]!.num, equals(2));

      result = await client.listParameters
          .returnNullableSimpleDataListNullableSimpleData(null);
      expect(result, isNull);
    });

    test('Map<String, int> parameter and return type', () async {
      var result = await client.mapParameters.returnIntMap({
        '0': 0,
        '1': 1,
        '2': 2,
      });
      expect(result.length, equals(3));
      expect(result['0'], equals(0));
      expect(result['1'], equals(1));
      expect(result['2'], equals(2));
    });

    test('Map<String, Map<String, int>> parameter and return type', () async {
      var result = await client.mapParameters.returnNestedIntMap({
        'a': {
          '0': 0,
          '1': 1,
        },
        'b': {
          '2': 2,
          '3': 3,
        },
      });
      expect(result.length, equals(2));
      expect(result['a']!.length, equals(2));
      expect(result['a']!['0'], equals(0));
      expect(result['a']!['1'], equals(1));
      expect(result['b']!.length, equals(2));
      expect(result['b']!['2'], equals(2));
      expect(result['b']!['3'], equals(3));
    });

    test('Map<String, int>? parameter and return type', () async {
      var result = await client.mapParameters.returnIntMapNullable({
        '0': 0,
        '1': 1,
        '2': 2,
      });
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result['0'], equals(0));
      expect(result['1'], equals(1));
      expect(result['2'], equals(2));

      result = await client.mapParameters.returnIntMapNullable(null);
      expect(result, isNull);
    });

    test('Map<String, int?> parameter and return type', () async {
      var result = await client.mapParameters.returnIntMapNullableInts({
        '0': 0,
        '1': null,
        '2': 2,
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0'], equals(0));
      expect(result['1'], isNull);
      expect(result['2'], equals(2));
    });

    test('Map<String, int?>? parameter and return type', () async {
      var result = await client.mapParameters.returnNullableIntMapNullableInts({
        '0': 0,
        '1': null,
        '2': 2,
      });
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result['0'], equals(0));
      expect(result['1'], isNull);
      expect(result['2'], equals(2));

      result =
          await client.mapParameters.returnNullableIntMapNullableInts(null);
      expect(result, isNull);
    });

    test('Map<int, int> parameter and return type', () async {
      var result = await client.mapParameters.returnIntIntMap({
        0: 0,
        10: 1,
        20: 2,
      });
      expect(result.length, equals(3));
      expect(result[0], equals(0));
      expect(result[10], equals(1));
      expect(result[20], equals(2));
    });

    test('Map<TestEnum, int> parameter and return type', () async {
      var result = await client.mapParameters.returnEnumIntMap({
        TestEnum.one: 1,
        TestEnum.two: 2,
        TestEnum.three: 3,
      });
      expect(result.length, equals(3));
      expect(result[TestEnum.one], equals(1));
      expect(result[TestEnum.two], equals(2));
      expect(result[TestEnum.three], equals(3));
    });

    test('Map<String, TestEnum> parameter and return type', () async {
      var result = await client.mapParameters.returnEnumMap({
        'one': TestEnum.one,
        'two': TestEnum.two,
        'three': TestEnum.three,
      });
      expect(result.length, equals(3));
      expect(result['one'], equals(TestEnum.one));
      expect(result['two'], equals(TestEnum.two));
      expect(result['three'], equals(TestEnum.three));
    });

    test('Map<String, double> parameter and return type', () async {
      var result = await client.mapParameters.returnDoubleMap({
        '0': 0.0,
        '1': 1.0,
        '2': 2.0,
      });
      expect(result.length, equals(3));
      expect(result['0'], equals(0.0));
      expect(result['1'], equals(1.0));
      expect(result['2'], equals(2.0));
    });

    test('Map<String, double?> parameter and return type', () async {
      var result = await client.mapParameters.returnDoubleMapNullableDoubles({
        '0': 0.0,
        '1': null,
        '2': 2.0,
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0'], equals(0.0));
      expect(result['1'], isNull);
      expect(result['2'], equals(2.0));
    });

    test('Map<String, bool> parameter and return type', () async {
      var result = await client.mapParameters.returnBoolMap({
        '0': false,
        '1': false,
        '2': true,
      });
      expect(result.length, equals(3));
      expect(result['0'], equals(false));
      expect(result['1'], equals(false));
      expect(result['2'], equals(true));
    });

    test('Map<String, bool?> parameter and return type', () async {
      var result = await client.mapParameters.returnBoolMapNullableBools({
        '0': false,
        '1': null,
        '2': true,
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0'], equals(false));
      expect(result['1'], isNull);
      expect(result['2'], equals(true));
    });

    test('Map<String, String> parameter and return type', () async {
      var result = await client.mapParameters.returnStringMap({
        '0': 'String 0',
        '1': 'String 1',
        '2': 'String 2',
      });
      expect(result.length, equals(3));
      expect(result['0'], equals('String 0'));
      expect(result['1'], equals('String 1'));
      expect(result['2'], equals('String 2'));
    });

    test('Map<String, String?> parameter and return type', () async {
      var result = await client.mapParameters.returnStringMapNullableStrings({
        '0': 'String 0',
        '1': null,
        '2': 'null',
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0'], equals('String 0'));
      expect(result['1'], isNull);
      expect(result['2'], equals('null'));
    });

    test('Map<String, DateTime> parameter and return type', () async {
      var result = await client.mapParameters.returnDateTimeMap({
        '2020': DateTime.utc(2020),
        '2021': DateTime.utc(2021),
        '2022': DateTime.utc(2022),
      });
      expect(result.length, equals(3));
      expect(result['2020'], equals(DateTime.utc(2020)));
      expect(result['2021'], equals(DateTime.utc(2021)));
      expect(result['2022'], equals(DateTime.utc(2022)));
    });

    test('Map<String, DateTime?> parameter and return type', () async {
      var result =
          await client.mapParameters.returnDateTimeMapNullableDateTimes({
        '2020': DateTime.utc(2020),
        '2021': null,
        '2022': DateTime.utc(2022),
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['2020'], equals(DateTime.utc(2020)));
      expect(result['2021'], isNull);
      expect(result['2022'], equals(DateTime.utc(2022)));
    });

    test('Map<String, ByteData> parameter and return type', () async {
      var result = await client.mapParameters.returnByteDataMap({
        '0': createByteData(),
        '1': createByteData(),
        '2': createByteData(),
      });
      expect(result.length, equals(3));
      expect(result['0']!.lengthInBytes, equals(256));
      expect(result['1']!.lengthInBytes, equals(256));
      expect(result['2']!.lengthInBytes, equals(256));
    });

    test('Map<String, ByteData?> parameter and return type', () async {
      var result =
          await client.mapParameters.returnByteDataMapNullableByteDatas({
        '0': createByteData(),
        '1': null,
        '2': createByteData(),
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0']!.lengthInBytes, equals(256));
      expect(result['1'], isNull);
      expect(result['2']!.lengthInBytes, equals(256));
    });

    test('Map<String, SimpleData> parameter and return type', () async {
      var result = await client.mapParameters.returnSimpleDataMap({
        '0': SimpleData(num: 0),
        '1': SimpleData(num: 1),
        '2': SimpleData(num: 2),
      });
      expect(result.length, equals(3));
      expect(result['0']!.num, equals(0));
      expect(result['1']!.num, equals(1));
      expect(result['2']!.num, equals(2));
    });

    test('Map<String, SimpleData>? parameter and return type', () async {
      var result = await client.mapParameters.returnSimpleDataMapNullable({
        '0': SimpleData(num: 0),
        '1': SimpleData(num: 1),
        '2': SimpleData(num: 2),
      });
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result['0']!.num, equals(0));
      expect(result['1']!.num, equals(1));
      expect(result['2']!.num, equals(2));

      result = await client.mapParameters.returnSimpleDataMapNullable(null);
      expect(result, isNull);
    });

    test('Map<String, SimpleData?> parameter and return type', () async {
      var result =
          await client.mapParameters.returnSimpleDataMapNullableSimpleData({
        '0': SimpleData(num: 0),
        '1': null,
        '2': SimpleData(num: 2),
      });
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result['0']!.num, equals(0));
      expect(result['1'], isNull);
      expect(result['2']!.num, equals(2));
    });

    test('Map<String, SimpleData?>? parameter and return type', () async {
      var result = await client.mapParameters
          .returnNullableSimpleDataMapNullableSimpleData({
        '0': SimpleData(num: 0),
        '1': null,
        '2': SimpleData(num: 2),
      });
      expect(result, isNotNull);
      expect(result!.length, equals(3));
      expect(result['0']!.num, equals(0));
      expect(result['1'], isNull);
      expect(result['2']!.num, equals(2));

      result = await client.mapParameters
          .returnNullableSimpleDataMapNullableSimpleData(null);
      expect(result, isNull);
    });

    test('CustomClass parameter and return type', () async {
      var result = await client.customTypes
          .returnCustomClass(CustomClass('customClassText'));

      expect(result, isNotNull);
      expect(result.value, 'customClassText');
    });

    test('CustomClass? parameter and return type', () async {
      var result = await client.customTypes
          .returnCustomClassNullable(CustomClass('customClassText'));

      expect(result, isNotNull);
      expect(result!.value, 'customClassText');

      result = await client.customTypes.returnCustomClassNullable(null);

      expect(result, isNull);
    });

    test('CustomClass2 parameter and return type', () async {
      var result = await client.customTypes
          .returnCustomClass2(const CustomClass2('text'));

      expect(result, isNotNull);
      expect(result.value, 'text');
    });

    test('CustomClass2? parameter and return type', () async {
      var result = await client.customTypes
          .returnCustomClass2Nullable(const CustomClass2('text'));

      expect(result, isNotNull);
      expect(result!.value, 'text');

      result = await client.customTypes.returnCustomClass2Nullable(null);

      expect(result, isNull);
    });

    test('ExternalCustomClass parameter and return type', () async {
      var result = await client.customTypes
          .returnExternalCustomClass(const ExternalCustomClass('text'));

      expect(result, isNotNull);
      expect(result.value, 'text');
    });

    test('ExternalCustomClass parameter and return type', () async {
      var result = await client.customTypes
          .returnExternalCustomClassNullable(const ExternalCustomClass('text'));

      expect(result, isNotNull);
      expect(result!.value, 'text');

      result = await client.customTypes.returnExternalCustomClassNullable(null);

      expect(result, isNull);
    });

    test('FreezedCustomClass parameter and return type', () async {
      var result = await client.customTypes.returnFreezedCustomClass(
        const FreezedCustomClass(
          firstName: 'First',
          lastName: 'Last',
          age: 42,
        ),
      );

      expect(result, isNotNull);
      expect(result.firstName, 'First');
    });

    test('ExternalCustomClass parameter and return type', () async {
      var result = await client.customTypes.returnFreezedCustomClassNullable(
        const FreezedCustomClass(
          firstName: 'First',
          lastName: 'Last',
          age: 42,
        ),
      );

      expect(result, isNotNull);
      expect(result!.firstName, 'First');

      result = await client.customTypes.returnFreezedCustomClassNullable(null);

      expect(result, isNull);
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

  group('Failed calls', () {
    test('Exception in call', () async {
      ServerpodClientException? clientException;
      try {
        await client.failedCalls.failedCall();
      } catch (e) {
        clientException = e as ServerpodClientException?;
      }

      expect(clientException, isNotNull);
      expect(clientException!.statusCode, equals(500));
    });

    test('Exception in call from database', () async {
      ServerpodClientException? clientException;
      try {
        await client.failedCalls.failedDatabaseQuery();
      } catch (e) {
        clientException = e as ServerpodClientException?;
      }

      expect(clientException, isNotNull);
      expect(clientException!.statusCode, equals(500));
    });

    test('Exception in call from database being caught', () async {
      var result =
          await client.failedCalls.failedDatabaseQueryCaughtException();
      expect(result, equals(true));
    });

    test('Slow call', () async {
      await client.failedCalls.slowCall();
    });
  });

  group('Sub directories', () {
    test('Endpoint in sub directory', () async {
      var result = await client.subDirTest.testMethod();
      expect(result, 'subDir');
    });
    test('Endpoint in nested sub directory', () async {
      var result = await client.subSubDirTest.testMethod();
      expect(result, 'subSubDir');
    });
  });
}
