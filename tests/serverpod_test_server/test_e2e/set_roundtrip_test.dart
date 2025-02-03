import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

ByteData createByteData() {
  var ints = Uint8List(256);
  for (var i = 0; i < 256; i++) {
    ints[i] = i;
  }
  return ByteData.view(ints.buffer);
}

void main() {
  var client = Client(serverUrl);

  test(
      'Given a Set<int>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {0, 1, 2};
    var result = await client.setParameters.returnIntSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<Set<int>>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      {0},
      {1, 2},
    };
    var result = await client.setParameters.returnIntSetSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<List<int>>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      [0],
      [1, 2],
    };
    var result = await client.setParameters.returnIntListSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a non-null Set<int>?, when sending it to the echo server, it is returned unmodified',
      () async {
    Set<int>? set = {1, 2};
    var result = await client.setParameters.returnIntSetNullable(set);

    expect(result, equals(set));
  });

  test(
      'Given a `null` Set<int>?, when sending it to the echo server, it is returned unmodified',
      () async {
    var result = await client.setParameters.returnIntSetNullable(null);

    expect(result, isNull);
  });

  test(
      'Given a Set<Set<int>?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      {0},
      null,
      {1, 2},
    };
    var result = await client.setParameters.returnIntSetNullableSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<Set<int>>?, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      {0},
      {1, 2},
    };
    var result = await client.setParameters.returnIntSetSetNullable(set);

    expect(result, equals(set));
  });

  test(
      'Given a `null` Set<Set<int>>?, when sending it to the echo server, it is returned unmodified',
      () async {
    var result = await client.setParameters.returnIntSetSetNullable(null);

    expect(result, isNull);
  });

  test(
      'Given a Set<int?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {0, null, 1, 2};
    var result = await client.setParameters.returnIntSetNullableInts(set);

    expect(result, equals(set));
  });

  test(
      'Given a `null` Set<int?>?, when sending it to the echo server, it is returned unmodified',
      () async {
    var result =
        await client.setParameters.returnNullableIntSetNullableInts(null);

    expect(result, isNull);
  });

  test(
      'Given a Set<double>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {1.2, 3.4};
    var result = await client.setParameters.returnDoubleSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<double?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {1.2, null, 3.4};
    var result = await client.setParameters.returnDoubleSetNullableDoubles(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<bool>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      true,
      false,
    };
    var result = await client.setParameters.returnBoolSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<bool?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {
      true,
      null,
      false,
    };
    var result = await client.setParameters.returnBoolSetNullableBools(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<String>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {'hello', 'world'};
    var result = await client.setParameters.returnStringSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<String?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {'hello', null, 'null', 'world'};
    var result = await client.setParameters.returnStringSetNullableStrings(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<DateTime>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {DateTime.utc(2022), DateTime.now().toUtc()};
    var result = await client.setParameters.returnDateTimeSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<DateTime?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {DateTime.utc(2022), null, DateTime.now().toUtc()};
    var result =
        await client.setParameters.returnDateTimeSetNullableDateTimes(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<ByteData>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {createByteData(), createByteData()};
    var result = await client.setParameters.returnByteDataSet(set);

    expect(result, hasLength(2));
    expect(result.first.lengthInBytes, 256);
    expect(result.last.lengthInBytes, 256);
  });

  test(
      'Given a Set<ByteData?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {createByteData(), null};
    var result =
        await client.setParameters.returnByteDataSetNullableByteDatas(set);

    expect(result, hasLength(2));
    expect(result.first!.lengthInBytes, 256);
    expect(result.last, isNull);
  });

  test(
      'Given a Set<SimpleData>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {SimpleData(num: 1), SimpleData(num: 2)};
    var result = await client.setParameters.returnSimpleDataSet(set);

    expect(result, hasLength(2));
    expect(result.first.num, 1);
    expect(result.last.num, 2);
  });

  test(
      'Given a Set<SimpleData?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {SimpleData(num: 1), null, SimpleData(num: 3)};
    var result =
        await client.setParameters.returnSimpleDataSetNullableSimpleData(set);

    expect(result, hasLength(3));
    expect(result.first!.num, 1);
    expect(result.elementAt(1), isNull);
    expect(result.last!.num, 3);
  });

  test(
      'Given a Set<Duration>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {Duration.zero, Duration(milliseconds: 1000)};
    var result = await client.setParameters.returnDurationSet(set);

    expect(result, equals(set));
  });

  test(
      'Given a Set<Duration?>, when sending it to the echo server, it is returned unmodified',
      () async {
    var set = {Duration.zero, null, Duration(milliseconds: 1000)};
    var result =
        await client.setParameters.returnDurationSetNullableDurations(set);

    expect(result, equals(set));
  });

  // test('List<List<int>> parameter and return type', () async {
  //   var result = await client.setParameters.returnIntListSet([
  //     [0, 1, 2],
  //     [3, 4, 5]
  //   ]);
  //   expect(result.length, equals(2));
  //   expect(result[0].length, equals(3));
  //   expect(result[0][0], equals(0));
  //   expect(result[0][1], equals(1));
  //   expect(result[0][2], equals(2));
  //   expect(result[1].length, equals(3));
  //   expect(result[1][0], equals(3));
  //   expect(result[1][1], equals(4));
  //   expect(result[1][2], equals(5));
  // });

  // test('List<int>? parameter and return type', () async {
  //   var result = await client.setParameters.returnIntListNullable([0, 1, 2]);
  //   expect(result, isNotNull);
  //   expect(result!.length, equals(3));
  //   expect(result[0], equals(0));
  //   expect(result[1], equals(1));
  //   expect(result[2], equals(2));

  //   result = await client.setParameters.returnIntListNullable(null);
  //   expect(result, isNull);
  // });

  // test('List<List<int>?> parameter and return type', () async {
  //   var result = await client.setParameters.returnIntListNullableSet([
  //     [0, 1, 2],
  //     null
  //   ]);
  //   expect(result.length, equals(2));
  //   expect(result[0], isNotNull);
  //   expect(result[0]!.length, equals(3));
  //   expect(result[0]![0], equals(0));
  //   expect(result[0]![1], equals(1));
  //   expect(result[0]![2], equals(2));
  //   expect(result[1], isNull);
  // });

  // test('List<List<int>>? parameter and return type', () async {
  //   var result = await client.setParameters.returnIntListListNullable([
  //     [0, 1, 2],
  //     [3, 4, 5]
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result!.length, equals(2));
  //   expect(result[0].length, equals(3));
  //   expect(result[0][0], equals(0));
  //   expect(result[0][1], equals(1));
  //   expect(result[0][2], equals(2));
  //   expect(result[1].length, equals(3));
  //   expect(result[1][0], equals(3));
  //   expect(result[1][1], equals(4));
  //   expect(result[1][2], equals(5));

  //   result = await client.setParameters.returnIntListListNullable(null);
  //   expect(result, isNull);
  // });

  // test('List<int?> parameter and return type', () async {
  //   var result =
  //       await client.setParameters.returnIntListNullableInts([0, null, 2]);
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(0));
  //   expect(result[1], isNull);
  //   expect(result[2], equals(2));
  // });

  // test('List<int?>? parameter and return type', () async {
  //   var result = await client.setParameters
  //       .returnNullableIntListNullableInts([0, null, 2]);
  //   expect(result, isNotNull);
  //   expect(result!.length, equals(3));
  //   expect(result[0], equals(0));
  //   expect(result[1], isNull);
  //   expect(result[2], equals(2));

  //   result = await client.setParameters.returnNullableIntListNullableInts(null);
  //   expect(result, isNull);
  // });

  // test('List<double> parameter and return type', () async {
  //   var result = await client.setParameters.returnDoubleSet([0.0, 1.0, 2.0]);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(0.0));
  //   expect(result[1], equals(1.0));
  //   expect(result[2], equals(2.0));
  // });

  // test('List<double?> parameter and return type', () async {
  //   var result = await client.setParameters.returnDoubleListNullableDoubles(
  //     [0.0, null, 2.0],
  //   );
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(0.0));
  //   expect(result[1], isNull);
  //   expect(result[2], equals(2.0));
  // });

  // test('List<bool> parameter and return type', () async {
  //   var result = await client.setParameters.returnBoolSet([false, true]);
  //   expect(result.length, equals(2));
  //   expect(result[0], equals(false));
  //   expect(result[1], equals(true));
  // });

  // test('List<bool?> parameter and return type', () async {
  //   var result = await client.setParameters.returnBoolListNullableBools(
  //     [false, null, true],
  //   );
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(false));
  //   expect(result[1], isNull);
  //   expect(result[2], equals(true));
  // });

  // test('List<String> parameter and return type', () async {
  //   var result = await client.setParameters.returnStringSet(
  //     ['A', 'B', 'C'],
  //   );
  //   expect(result.length, equals(3));
  //   expect(result[0], equals('A'));
  //   expect(result[1], equals('B'));
  //   expect(result[2], equals('C'));
  // });

  // test('List<String?> parameter and return type', () async {
  //   var result = await client.setParameters.returnStringListNullableStrings(
  //     ['A', null, 'C'],
  //   );
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals('A'));
  //   expect(result[1], isNull);
  //   expect(result[2], equals('C'));
  // });

  // test('List<DateTime> parameter and return type', () async {
  //   var result = await client.setParameters.returnDateTimeSet([
  //     DateTime.utc(2020),
  //     DateTime.utc(2021),
  //     DateTime.utc(2022),
  //   ]);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(DateTime.utc(2020)));
  //   expect(result[1], equals(DateTime.utc(2021)));
  //   expect(result[2], equals(DateTime.utc(2022)));
  // });

  // test('List<DateTime?> parameter and return type', () async {
  //   var result =
  //       await client.setParameters.returnDateTimeListNullableDateTimes([
  //     DateTime.utc(2020),
  //     null,
  //     DateTime.utc(2022),
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0], equals(DateTime.utc(2020)));
  //   expect(result[1], isNull);
  //   expect(result[2], equals(DateTime.utc(2022)));
  // });

  // test('List<ByteData> parameter and return type', () async {
  //   var result = await client.setParameters.returnByteDataSet([
  //     createByteData(),
  //     createByteData(),
  //     createByteData(),
  //   ]);
  //   expect(result.length, equals(3));
  //   expect(result[0].lengthInBytes, equals(256));
  //   expect(result[1].lengthInBytes, equals(256));
  //   expect(result[2].lengthInBytes, equals(256));
  // });

  // test('List<ByteData?> parameter and return type', () async {
  //   var result =
  //       await client.setParameters.returnByteDataListNullableByteDatas([
  //     createByteData(),
  //     null,
  //     createByteData(),
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0]!.lengthInBytes, equals(256));
  //   expect(result[1], isNull);
  //   expect(result[2]!.lengthInBytes, equals(256));
  // });

  // test('List<SimpleData> parameter and return type', () async {
  //   var result = await client.setParameters.returnSimpleDataSet([
  //     SimpleData(num: 0),
  //     SimpleData(num: 1),
  //     SimpleData(num: 2),
  //   ]);
  //   expect(result.length, equals(3));
  //   expect(result[0].num, equals(0));
  //   expect(result[1].num, equals(1));
  //   expect(result[2].num, equals(2));
  // });

  // test('List<SimpleData?> parameter and return type', () async {
  //   var result =
  //       await client.setParameters.returnSimpleDataListNullableSimpleData([
  //     SimpleData(num: 0),
  //     null,
  //     SimpleData(num: 2),
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result.length, equals(3));
  //   expect(result[0]!.num, equals(0));
  //   expect(result[1], isNull);
  //   expect(result[2]!.num, equals(2));
  // });

  // test('List<SimpleData>? parameter and return type', () async {
  //   var result = await client.setParameters.returnSimpleDataListNullable([
  //     SimpleData(num: 0),
  //     SimpleData(num: 1),
  //     SimpleData(num: 2),
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result!.length, equals(3));
  //   expect(result[0].num, equals(0));
  //   expect(result[1].num, equals(1));
  //   expect(result[2].num, equals(2));

  //   result = await client.setParameters.returnSimpleDataListNullable(null);
  //   expect(result, isNull);
  // });

  // test('List<SimpleData?>? parameter and return type', () async {
  //   var result = await client.setParameters
  //       .returnNullableSimpleDataListNullableSimpleData([
  //     SimpleData(num: 0),
  //     null,
  //     SimpleData(num: 2),
  //   ]);
  //   expect(result, isNotNull);
  //   expect(result!.length, equals(3));
  //   expect(result[0]!.num, equals(0));
  //   expect(result[1], isNull);
  //   expect(result[2]!.num, equals(2));

  //   result = await client.setParameters
  //       .returnNullableSimpleDataListNullableSimpleData(null);
  //   expect(result, isNull);
  // });
}
