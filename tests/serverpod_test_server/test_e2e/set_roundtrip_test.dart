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
    },
  );

  test(
    'Given a Set<Set<int>>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {
        {0},
        {1, 2},
      };
      var result = await client.setParameters.returnIntSetSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<List<int>>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {
        [0],
        [1, 2],
      };
      var result = await client.setParameters.returnIntListSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a non-null Set<int>?, when sending it to the echo server, it is returned unmodified',
    () async {
      Set<int>? set = {1, 2};
      var result = await client.setParameters.returnIntSetNullable(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a `null` Set<int>?, when sending it to the echo server, it is returned unmodified',
    () async {
      var result = await client.setParameters.returnIntSetNullable(null);

      expect(result, isNull);
    },
  );

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
    },
  );

  test(
    'Given a Set<Set<int>>?, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {
        {0},
        {1, 2},
      };
      var result = await client.setParameters.returnIntSetSetNullable(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a `null` Set<Set<int>>?, when sending it to the echo server, it is returned unmodified',
    () async {
      var result = await client.setParameters.returnIntSetSetNullable(null);

      expect(result, isNull);
    },
  );

  test(
    'Given a Set<int?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {0, null, 1, 2};
      var result = await client.setParameters.returnIntSetNullableInts(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a `null` Set<int?>?, when sending it to the echo server, it is returned unmodified',
    () async {
      var result = await client.setParameters.returnNullableIntSetNullableInts(
        null,
      );

      expect(result, isNull);
    },
  );

  test(
    'Given a Set<double>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {1.2, 3.4};
      var result = await client.setParameters.returnDoubleSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<double?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {1.2, null, 3.4};
      var result = await client.setParameters.returnDoubleSetNullableDoubles(
        set,
      );

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<bool>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {
        true,
        false,
      };
      var result = await client.setParameters.returnBoolSet(set);

      expect(result, equals(set));
    },
  );

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
    },
  );

  test(
    'Given a Set<String>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {'hello', 'world'};
      var result = await client.setParameters.returnStringSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<String?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {'hello', null, 'null', 'world'};
      var result = await client.setParameters.returnStringSetNullableStrings(
        set,
      );

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<DateTime>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {DateTime.utc(2022), DateTime.now().toUtc()};
      var result = await client.setParameters.returnDateTimeSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<DateTime?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {DateTime.utc(2022), null, DateTime.now().toUtc()};
      var result = await client.setParameters
          .returnDateTimeSetNullableDateTimes(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<ByteData>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {createByteData(), createByteData()};
      var result = await client.setParameters.returnByteDataSet(set);

      expect(result, hasLength(2));
      expect(result.first.lengthInBytes, 256);
      expect(result.last.lengthInBytes, 256);
    },
  );

  test(
    'Given a Set<ByteData?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {createByteData(), null};
      var result = await client.setParameters
          .returnByteDataSetNullableByteDatas(set);

      expect(result, hasLength(2));
      expect(result.first!.lengthInBytes, 256);
      expect(result.last, isNull);
    },
  );

  test(
    'Given a Set<SimpleData>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {SimpleData(num: 1), SimpleData(num: 2)};
      var result = await client.setParameters.returnSimpleDataSet(set);

      expect(result, hasLength(2));
      expect(result.first.num, 1);
      expect(result.last.num, 2);
    },
  );

  test(
    'Given a Set<SimpleData?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {SimpleData(num: 1), null, SimpleData(num: 3)};
      var result = await client.setParameters
          .returnSimpleDataSetNullableSimpleData(set);

      expect(result, hasLength(3));
      expect(result.first!.num, 1);
      expect(result.elementAt(1), isNull);
      expect(result.last!.num, 3);
    },
  );

  test(
    'Given a Set<Duration>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {Duration.zero, Duration(milliseconds: 1000)};
      var result = await client.setParameters.returnDurationSet(set);

      expect(result, equals(set));
    },
  );

  test(
    'Given a Set<Duration?>, when sending it to the echo server, it is returned unmodified',
    () async {
      var set = {Duration.zero, null, Duration(milliseconds: 1000)};
      var result = await client.setParameters
          .returnDurationSetNullableDurations(set);

      expect(result, equals(set));
    },
  );
}
