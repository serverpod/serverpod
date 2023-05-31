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

  group('client model "operator=="', () {
    test('ByteData not equal', () {
      var a = createByteData(2);
      var b = createByteData(2);

      expect(a, isNot(b));
    });

    group('SimpleData', () {
      test('equal', () {
        expect(SimpleData(num: 0), equals(SimpleData(num: 0)));
        expect(SimpleData(num: 1, id: 1), equals(SimpleData(num: 1, id: 1)));
      });

      test('not equal', () {
        expect(SimpleData(num: 0), isNot(SimpleData(num: 10)));
        expect(SimpleData(num: 1, id: 1), isNot(SimpleData(num: 2, id: 2)));
      });
    });

    group('SimpleDataList', () {
      var a = SimpleDataList(rows: [
        SimpleData(id: 1, num: 1),
      ]);

      test('equal', () {
        var b = a.copyWith(rows: [
          SimpleData(id: 1, num: 1),
        ]);

        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(rows: [
          SimpleData(id: 2, num: 2),
        ]);
        expect(a, isNot(b));
      });
    });

    group('ObjectWithObject', () {
      var a = ObjectWithObject(
        id: 1,
        data: SimpleData(num: 2, id: 2),
        dataList: [SimpleData(num: 3, id: 3)],
        listWithNullableData: [null, SimpleData(num: 4, id: 4)],
      );
      test('equal', () {
        var b = a.copyWith(
          id: 1,
          data: SimpleData(num: 2, id: 2),
          listWithNullableData: [null, SimpleData(num: 4, id: 4)],
        );

        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(
          id: 1,
          data: SimpleData(num: 2, id: 2),
          listWithNullableData: [null],
        );

        expect(a, isNot(b));
      });
    });

    group('ObjectWithMaps', () {
      var uuid = const Uuid().v4();
      var bytes = createByteData(20);

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
      test('equal', () {
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

      test('not equal', () {
        var b = a.copyWith(
          intIntMap: {1: 1},
        );

        expect(a, isNot(b));
      });
    });

    group('ObjectWithEnum', () {
      var a = ObjectWithEnum(
        testEnum: TestEnum.three,
        enumList: [TestEnum.two, TestEnum.one],
        nullableEnumList: [null, TestEnum.three],
        enumListList: [
          [TestEnum.two, TestEnum.one],
          [TestEnum.one, TestEnum.three]
        ],
      );
      test('equal', () {
        var b = a.copyWith(
          nullableEnumList: [null, TestEnum.three],
          enumListList: [
            [TestEnum.two, TestEnum.one],
            [TestEnum.one, TestEnum.three]
          ],
        );

        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(
          nullableEnumList: [null, TestEnum.three],
          enumListList: [
            [TestEnum.two, TestEnum.three],
            [TestEnum.one, TestEnum.three]
          ],
        );

        expect(a, isNot(b));
      });
    });

    group('ObjectWithByteData', () {
      var bytes = createByteData(100);
      var a = ObjectWithByteData(id: 1, byteData: bytes);
      test('equal', () {
        var b = a.copyWith(byteData: bytes);

        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(id: 2);

        expect(a, isNot(b));
      });
    });

    group('ObjectWithIndex', () {
      var a = ObjectWithIndex(id: 1, indexed: 1, indexed2: 2);
      test('equal', () {
        var b = a.copyWith(id: 1, indexed2: 2);

        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(id: 1, indexed2: 3);

        expect(a, isNot(b));
      });
    });

    group('ObjectFieldScopes', () {
      var a = ObjectFieldScopes(id: 1, api: 'api', normal: 'normal');

      test('equal', () {
        var b = a.copyWith(api: 'api', normal: 'normal');
        expect(a, equals(b));
      });

      test('not equal', () {
        var b = a.copyWith(id: 10);
        expect(a, isNot(b));
      });
    });
  });

  group('client model "copyWith"', () {
    test('', () {
      var a = ObjectWithObject(
        id: 1,
        data: SimpleData(num: 2, id: 2),
        dataList: [SimpleData(num: 3, id: 3)],
        listWithNullableData: [null, SimpleData(num: 4, id: 4)],
      );

      var b = a.copyWith(
        id: 2,
        data: SimpleData(num: 3, id: 3),
        dataList: [SimpleData(num: 4, id: 4)],
        listWithNullableData: [SimpleData(num: 5, id: 5)],
      );

      expect(b.id, equals(2));
      expect(b.data, equals(SimpleData(num: 3, id: 3)));
      expect(b.dataList, equals([SimpleData(num: 4, id: 4)]));
      expect(b.listWithNullableData, equals([SimpleData(num: 5, id: 5)]));
    });
  });
}
