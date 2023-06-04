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

  group('Client extra methods:', () {
    test('ByteData not equal', () {
      var a = createByteData(10);
      var b = createByteData(10);

      expect(a, isNot(b));
    });

    test('simple class equal', () {
      expect(ExtraDataSimple(num: 10), equals(ExtraDataSimple(num: 10)));
    });

    test('not equal', () {
      expect(ExtraDataSimple(num: 0), isNot(ExtraDataSimple(num: 10)));
    });

    test('empty withCopy: equals', () {
      var b = a.copyWith();
      expect(a, equals(b));
    });

    test('duration equals', () {
      var b = a.copyWith(duration: const Duration(seconds: 10));
      expect(a, equals(b));
    });

    test('duration is not equal', () {
      var b = a.copyWith(duration: const Duration(seconds: 5));
      expect(a, isNot(b));
    });

    test('object equals', () {
      var b = a.copyWith(object: ExtraDataSimple());
      expect(a, equals(b));
    });

    test('object is not equal', () {
      var b = a.copyWith(object: ExtraDataSimple(num: 5));
      expect(a, isNot(b));
    });

    test('list equals', () {
      var b = a.copyWith(list: [ExtraDataSimple(num: 10)]);
      expect(a, equals(b));
    });

    test('list is not equal', () {
      var b = a.copyWith(list: [ExtraDataSimple()]);
      expect(a, isNot(b));
    });

    test('nullableList equals', () {
      var b = a.copyWith(nullableList: [ExtraDataSimple(num: 10)]);
      expect(a, equals(b));
    });

    test('nullableList is not equal', () {
      var b = a.copyWith(nullableList: [ExtraDataSimple()]);
      expect(a, isNot(b));
    });

    test('nullableList set to null', () {
      expect(a.nullableList, isNotNull);
      var b = a.copyWith(nullableList: null);
      expect(b.nullableList, isNull);
    });

    test('optionalValueList equals', () {
      var b = a.copyWith(optionalValueList: [null, ExtraDataSimple(num: 10)]);
      expect(a, equals(b));
    });

    test('optionalValueList is not equal', () {
      var b = a.copyWith(optionalValueList: [ExtraDataSimple()]);
      expect(a, isNot(b));
    });

    test('testEnum equals', () {
      var b = a.copyWith(testEnum: TestEnum.three);
      expect(a, equals(b));
    });

    test('testEnum is not equal', () {
      var b = a.copyWith(testEnum: TestEnum.one);
      expect(a, isNot(b));
    });

    test('nullableEnum equals', () {
      var b = a.copyWith(nullableEnum: TestEnum.two);
      expect(a, equals(b));
    });

    test('nullableEnum is not equal', () {
      var b = a.copyWith(nullableEnum: TestEnum.one);
      expect(a, isNot(b));
    });

    test('nullableEnum set to null', () {
      expect(a.nullableEnum, isNotNull);
      var b = a.copyWith(nullableEnum: null);
      expect(b.nullableEnum, isNull);
    });

    test('enumList equals', () {
      var b = a.copyWith(enumList: [TestEnum.two, TestEnum.one]);
      expect(a, equals(b));
    });

    test('enumList is not equal', () {
      var b = a.copyWith(enumList: [TestEnum.three]);
      expect(a, isNot(b));
    });

    test('nullableEnumList equals', () {
      var b = a.copyWith(nullableEnumList: [null, TestEnum.three]);
      expect(a, equals(b));
    });

    test('nullableEnumList is not equal', () {
      var b = a.copyWith(nullableEnumList: [TestEnum.three]);
      expect(a, isNot(b));
    });

    test('enumListList equals', () {
      var b = a.copyWith(
        enumListList: [
          [TestEnum.two, TestEnum.one],
          [TestEnum.one, TestEnum.three]
        ],
      );
      expect(a, equals(b));
    });

    test('enumListList is not equal', () {
      var b = a.copyWith(
        enumListList: [
          [TestEnum.two, TestEnum.two],
          [TestEnum.one, TestEnum.three]
        ],
      );
      expect(a, isNot(b));
    });

    test('dataMap equals', () {
      var b = a.copyWith(dataMap: {'1': ExtraDataSimple(num: 10)});
      expect(a, equals(b));
    });

    test('dataMap is not equal', () {
      var b = a.copyWith(dataMap: {'2': ExtraDataSimple(num: 10)});
      expect(a, isNot(b));
    });

    test('intMap equals', () {
      var b = a.copyWith(intMap: {'1': 10, '2': 10});
      expect(a, equals(b));
    });

    test('intMap is not equal', () {
      var b = a.copyWith(intMap: {'1': 10, '2': 3});
      expect(a, isNot(b));
    });

    test('stringMap equals', () {
      var b = a.copyWith(stringMap: {'1': '10', '2': '10'});
      expect(a, equals(b));
    });

    test('stringMap is not equal', () {
      var b = a.copyWith(stringMap: {'4': '10', '2': '10'});
      expect(a, isNot(b));
    });

    test('dateTimeMap equals', () {
      var b = a.copyWith(dateTimeMap: {'1': DateTime(10, 10, 10)});
      expect(a, equals(b));
    });

    test('dateTimeMap is not equal', () {
      var b = a.copyWith(dateTimeMap: {'1': DateTime(2023, 10, 10)});
      expect(a, isNot(b));
    });

    test('byteDataMap equals', () {
      var b = a.copyWith(byteDataMap: {'1': bytes});
      expect(a, equals(b));
    });

    test('byteDataMap is not equal', () {
      var b = a.copyWith(byteDataMap: {'1': createByteData(10)});
      expect(a, isNot(b));
    });

    test('durationMap equals', () {
      var b = a.copyWith(durationMap: {'1': const Duration(hours: 10)});
      expect(a, equals(b));
    });

    test('durationMap is not equal', () {
      var b = a.copyWith(durationMap: {'1': const Duration(seconds: 10)});
      expect(a, isNot(b));
    });

    test('uuidMap equals', () {
      var b = a.copyWith(uuidMap: {'1': UuidValue(uuid)});
      expect(a, equals(b));
    });

    test('uuidMap is not equal', () {
      var b = a.copyWith(uuidMap: {'1': UuidValue(const Uuid().v4())});
      expect(a, isNot(b));
    });

    test('nullableDataMap equals', () {
      var b = a.copyWith(
        nullableDataMap: {'1': null, '2': ExtraDataSimple(num: 10)},
      );
      expect(a, equals(b));
    });

    test('nullableDataMap is not equal', () {
      var b = a.copyWith(nullableDataMap: {'1': null});
      expect(a, isNot(b));
    });

    test('nullableIntMap equals', () {
      var b = a.copyWith(nullableIntMap: {'1': null, '2': 2});
      expect(a, equals(b));
    });

    test('nullableIntMap is not equal', () {
      var b = a.copyWith(nullableIntMap: {'1': null, '2': 3});
      expect(a, isNot(b));
    });

    test('nullableStringMap equals', () {
      var b = a.copyWith(nullableStringMap: {'1': null, '2': '2'});
      expect(a, equals(b));
    });

    test('nullableStringMap is not equal', () {
      var b = a.copyWith(nullableStringMap: {'1': '1', '2': 'null'});
      expect(a, isNot(b));
    });

    test('nullableDateTimeMap equals', () {
      var b = a.copyWith(
        nullableDateTimeMap: {'1': null, '2': DateTime(10, 10, 10)},
      );
      expect(a, equals(b));
    });

    test('nullableDateTimeMap is not equal', () {
      var b = a.copyWith(
        nullableDateTimeMap: {'1': null, '2': DateTime(2023, 10, 10)},
      );
      expect(a, isNot(b));
    });

    test('nullableByteDataMap equals', () {
      var b = a.copyWith(
        nullableByteDataMap: {'1': null, '3': bytes},
      );
      expect(a, equals(b));
    });

    test('nullableByteDataMap is not equal', () {
      var b = a.copyWith(
        nullableByteDataMap: {'1': bytes, '3': bytes},
      );
      expect(a, isNot(b));
    });

    test('nullableDurationMap equals', () {
      var b = a.copyWith(
        nullableDurationMap: {'1': null, '2': const Duration(hours: 10)},
      );
      expect(a, equals(b));
    });

    test('nullableDurationMap is not equal', () {
      var b = a.copyWith(
        nullableDurationMap: {'1': null, '2': const Duration(seconds: 10)},
      );
      expect(a, isNot(b));
    });

    test('nullableUuidMap equals', () {
      var b = a.copyWith(
        nullableUuidMap: {'1': null, '2': UuidValue(uuid)},
      );
      expect(a, equals(b));
    });

    test('nullableUuidMap is not equal', () {
      var b = a.copyWith(
        nullableUuidMap: {'1': null, '2': UuidValue(const Uuid().v4())},
      );
      expect(a, isNot(b));
    });

    test('intIntMap equals', () {
      var b = a.copyWith(intIntMap: {1: 10, 2: 10});
      expect(a, equals(b));
    });

    test('intIntMap is not equal', () {
      var b = a.copyWith(intIntMap: {1: 10, 2: 5});
      expect(a, isNot(b));
    });

    test('all fields together equals', () {
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
  });
}
