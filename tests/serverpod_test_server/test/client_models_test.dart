import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

ByteData createByteData(int len) {
  var data = Uint8List(len);
  for (var i = 0; i < len; i++) {
    data[i] = i % 256;
  }
  return ByteData.view(data.buffer);
}

void main() {
  setUp(() {});

  group('copyWith', () {});

  group('operator==', () {
    test('SimpleData', () {
      expect(SimpleData(num: 10), equals(SimpleData(num: 10)));
      expect(SimpleData(num: 2, id: 200), equals(SimpleData(num: 2, id: 200)));
      expect(SimpleData(num: 2, id: 3), equals(SimpleData(num: 2, id: 3)));
    });

    test('ObjectWithObject', () {});

    test('ObjectWithObject', () {
      var a = ObjectWithObject(
        id: 1,
        data: SimpleData(num: 2, id: 2),
        dataList: [SimpleData(num: 3, id: 3)],
        listWithNullableData: [null, SimpleData(num: 4, id: 4)],
      );

      var b = a.copyWith();

      expect(a, equals(b));
    });

    test('ObjectWithMaps', () {
      var uuid = const Uuid().v4();
      var bytes = createByteData(1);
      var a = ObjectWithMaps(
        dataMap: {'1': SimpleData(num: 40, id: 501)},
        intMap: {'1': 1, '2': 2},
        stringMap: {'1': '1', '2': '2'},
        dateTimeMap: {'1': DateTime(2000, 12, 10)},
        byteDataMap: {'1': bytes},
        durationMap: {'1': const Duration(hours: 300)},
        uuidMap: {'1': UuidValue(uuid)},
        nullableDataMap: {'1': null, '2': SimpleData(num: 1, id: 12)},
        nullableIntMap: {'1': null, '2': 2},
        nullableStringMap: {'1': null, '2': '2'},
        nullableDateTimeMap: {'1': null, '2': DateTime(2000, 12, 10)},
        nullableByteDataMap: {'1': null, '3': bytes},
        nullableDurationMap: {'1': null, '2': const Duration(hours: 300)},
        nullableUuidMap: {'1': null, '2': UuidValue(uuid)},
        intIntMap: {1: 1, 2: 2},
      );

      var b = a.copyWith(
        nullableDataMap: {'1': null, '2': SimpleData(num: 1, id: 12)},
        nullableIntMap: {'1': null, '2': 2},
        nullableStringMap: {'1': null, '2': '2'},
        nullableDateTimeMap: {'1': null, '2': DateTime(2000, 12, 10)},
        nullableByteDataMap: {'1': null, '3': bytes},
        nullableDurationMap: {'1': null, '2': const Duration(hours: 300)},
        nullableUuidMap: {'1': null, '2': UuidValue(uuid)},
        intIntMap: {1: 1, 2: 2},
      );

      expect(a, equals(b));
    });

    test('notEqual ', () async {
      expect(
        ObjectWithObject(
          id: 1,
          data: SimpleData(num: 2, id: 2),
          dataList: [SimpleData(num: 3, id: 3)],
          listWithNullableData: [null, SimpleData(num: 4, id: 4)],
        ),
        isNot(
          ObjectWithObject(
            id: 1,
            data: SimpleData(num: 2, id: 2),
            dataList: [SimpleData(num: 3, id: 3)],
            listWithNullableData: [null],
          ),
        ),
      );
    });
  });
}
