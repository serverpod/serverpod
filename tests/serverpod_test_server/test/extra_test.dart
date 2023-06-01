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

  var uuid = const Uuid().v4();
  var bytes = createByteData(10);

  var a = ExtraDataClass(
    duration: const Duration(seconds: 10),
    object: ExtraDataSimple(),
    list: [
      ExtraDataSimple(num: 10),
    ],
    nullableList: [ExtraDataSimple(num: 10)],
    optionalValueList: [null, ExtraDataSimple(num: 10)],
    testEnum: TestEnum.three,
    nullableEnum: TestEnum.two,
    enumList: [TestEnum.two, TestEnum.one],
    nullableEnumList: [null, TestEnum.three],
    enumListList: [
      [TestEnum.two, TestEnum.one],
      [TestEnum.one, TestEnum.three]
    ],
    dataMap: {'1': ExtraDataSimple(num: 10)},
    intMap: {'1': 10, '2': 10},
    stringMap: {'1': '10', '2': '10'},
    dateTimeMap: {'1': DateTime(10, 10, 10)},
    byteDataMap: {'1': bytes},
    durationMap: {'1': const Duration(hours: 10)},
    uuidMap: {'1': UuidValue(uuid)},
    nullableDataMap: {'1': null, '2': ExtraDataSimple(num: 10)},
    nullableIntMap: {'1': null, '2': 2},
    nullableStringMap: {'1': null, '2': '2'},
    nullableDateTimeMap: {'1': null, '2': DateTime(10, 10, 10)},
    nullableByteDataMap: {'1': null, '3': bytes},
    nullableDurationMap: {'1': null, '2': const Duration(hours: 10)},
    nullableUuidMap: {'1': null, '2': UuidValue(uuid)},
    intIntMap: {1: 10, 2: 10},
  );

  group('client extra "operator=="', () {
    test('ByteData not equal', () {
      var a = createByteData(10);
      var b = createByteData(10);

      expect(a, isNot(b));
    });

    group('ExtraDataSimple', () {
      test('equal', () {
        var a = ExtraDataSimple(num: 10);
        var b = a.copyWith(num: 10);

        expect(a, equals(b));
      });

      test('not equal', () {
        expect(ExtraDataSimple(num: 0), isNot(ExtraDataSimple(num: 10)));
      });
    });

    group('ExtraDataClass', () {
      test('equal + copyWith', () {
        var b = a.copyWith(
          duration: const Duration(seconds: 10),
          object: ExtraDataSimple(),
          list: [
            ExtraDataSimple(num: 10),
          ],
          nullableList: [ExtraDataSimple(num: 10)],
          optionalValueList: [null, ExtraDataSimple(num: 10)],
          testEnum: TestEnum.three,
          nullableEnum: TestEnum.two,
          enumList: [TestEnum.two, TestEnum.one],
          nullableEnumList: [null, TestEnum.three],
          enumListList: [
            [TestEnum.two, TestEnum.one],
            [TestEnum.one, TestEnum.three]
          ],
          dataMap: {'1': ExtraDataSimple(num: 10)},
          intMap: {'1': 10, '2': 10},
          stringMap: {'1': '10', '2': '10'},
          dateTimeMap: {'1': DateTime(10, 10, 10)},
          byteDataMap: {'1': bytes},
          durationMap: {'1': const Duration(hours: 10)},
          uuidMap: {'1': UuidValue(uuid)},
          nullableDataMap: {'1': null, '2': ExtraDataSimple(num: 10)},
          nullableIntMap: {'1': null, '2': 2},
          nullableStringMap: {'1': null, '2': '2'},
          nullableDateTimeMap: {'1': null, '2': DateTime(10, 10, 10)},
          nullableByteDataMap: {'1': null, '3': bytes},
          nullableDurationMap: {'1': null, '2': const Duration(hours: 10)},
          nullableUuidMap: {'1': null, '2': UuidValue(uuid)},
          intIntMap: {1: 10, 2: 10},
        );

        expect(a, equals(b));
      });

      test('not equal + copyWith', () {
        var b = a.copyWith();
        expect(a, equals(b));

        b = a.copyWith(duration: const Duration(seconds: 5));
        expect(a, isNot(b));

        b = a.copyWith(object: ExtraDataSimple(num: 5));
        expect(a, isNot(b));

        // no effect because object is required filed
        b = a.copyWith(object: null);
        expect(a, equals(b));

        b = a.copyWith(list: [ExtraDataSimple(num: 5)]);
        expect(a, isNot(b));

        b = a.copyWith(nullableList: []);
        expect(a, isNot(b));

        b = a.copyWith(nullableList: null);
        expect(a.nullableList, isNotNull);
        expect(b.nullableList, isNull);
        expect(a, isNot(b));

        b = a.copyWith(testEnum: TestEnum.one);
        expect(a, isNot(b));

        b = a.copyWith(nullableEnum: null);
        expect(a.nullableEnum, isNotNull);
        expect(b.nullableEnum, isNull);
        expect(a, isNot(b));

        b = a.copyWith(enumList: TestEnum.values);
        expect(a, isNot(b));

        b = a.copyWith(enumList: TestEnum.values);
        expect(a, isNot(b));

        b = a.copyWith(dataMap: {'1': ExtraDataSimple()});
        expect(a, isNot(b));
      });
    });
  });
}
