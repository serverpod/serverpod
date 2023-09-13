import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Copy behavior', () {
    group('Given an object with an int when copying with a new value', () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith(anInt: 2);

      test('then the original object is unmodified.', () {
        expect(types.anInt, 1);
      });

      test('then the copy has the new value.', () {
        expect(typesCopy.anInt, 2);
      });

      test('then the copy is not the same object as the original.', () {
        expect(identical(types, typesCopy), false);
      });
    });

    test(
        'Given an object with an int when copying the object without giving a new value then the copy has the same value.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith();

      expect(typesCopy.anInt, 1);
    });

    test(
        'Given an object with a nullable int when copying the object setting it to null then the copy is null but not the original.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith(anInt: null);

      expect(typesCopy.anInt, isNull);
      expect(types.anInt, 1);
    });
  });

  group('mutability', () {
    test(
        'Given an object with an int and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith();
      types.anInt = 3;

      expect(typesCopy.anInt, 1);
    });

    test(
        'Given an object with an double and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aDouble: 1);
      var typesCopy = types.copyWith();
      types.aDouble = 3;

      expect(typesCopy.aDouble, 1.0);
    });

    test(
        'Given an object with an bool and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aBool: false);
      var typesCopy = types.copyWith();
      types.aBool = true;

      expect(typesCopy.aBool, false);
    });

    test(
        'Given an object with an String and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aString: 'hello');
      var typesCopy = types.copyWith();
      types.aString = 'world';

      expect(typesCopy.aString, 'hello');
    });

    test(
        'Given an object with an Duration and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aDuration: Duration(seconds: 1));
      var typesCopy = types.copyWith();
      types.aDuration = Duration(seconds: 3);

      expect(
        typesCopy.aDuration?.inMilliseconds,
        Duration(seconds: 1).inMilliseconds,
      );
    });

    test(
        'Given an object with an Uuid and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var uuid = UuidValue(Uuid.NAMESPACE_NIL);

      var types = Types(aUuid: uuid);
      var typesCopy = types.copyWith();
      types.aUuid = UuidValue(Uuid().v4());

      expect(typesCopy.aUuid?.uuid, UuidValue(Uuid.NAMESPACE_NIL).uuid);
    });

    test(
        'Given an object with an DateTime and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);

      var types = Types(aDateTime: dateTime);
      var typesCopy = types.copyWith();
      types.aDateTime = DateTime.fromMillisecondsSinceEpoch(3000);

      expect(
        typesCopy.aDateTime?.millisecondsSinceEpoch,
        DateTime.fromMillisecondsSinceEpoch(1000).millisecondsSinceEpoch,
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt8(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Uint64List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt64(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asUint64List(),
        Uint64List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Float32List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt64(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asFloat32List(),
        Float32List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with a List and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var list = [SimpleData(num: 1), SimpleData(num: 2)];

      var listData = SimpleDataList(rows: list);
      var listDataCopy = listData.copyWith();
      listData.rows.add(SimpleData(num: 3));

      // Inspecting each value as the expect compares the references otherwise.
      expect(listDataCopy.rows, hasLength(2));
      expect(listDataCopy.rows[0].num, 1);
      expect(listDataCopy.rows[0].id, null);
      expect(listDataCopy.rows[1].num, 2);
      expect(listDataCopy.rows[1].id, null);
    });

    test(
        'Given an object with a List and a copy of that object when mutating an object in the list then the copy is unmodified.',
        () {
      var list = [SimpleData(num: 1), SimpleData(num: 2)];

      var listData = SimpleDataList(rows: list);
      var listDataCopy = listData.copyWith();
      listData.rows[0].num = 3;

      // Inspecting each value as the expect compares the references otherwise.
      expect(listDataCopy.rows, hasLength(2));
      expect(listDataCopy.rows[0].num, 1);
      expect(listDataCopy.rows[0].id, null);
      expect(listDataCopy.rows[1].num, 2);
      expect(listDataCopy.rows[1].id, null);
    });

    test(
        'Given an object with a Map and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var map = {'a': SimpleData(num: 1), 'b': SimpleData(num: 2)};

      var mapData = SimpleDataMap(data: map);
      var mapDataCopy = mapData.copyWith();
      mapData.data['c'] = SimpleData(num: 3);

      expect(mapDataCopy.data, hasLength(2));
      expect(mapDataCopy.data['a']?.num, 1);
      expect(mapDataCopy.data['a']?.id, null);
      expect(mapDataCopy.data['b']?.num, 2);
      expect(mapDataCopy.data['b']?.id, null);
    });

    test(
        'Given an object with a Map and a copy of that object when mutating an object in the map then the copy is unmodified.',
        () {
      var map = {'a': SimpleData(num: 1), 'b': SimpleData(num: 2)};

      var mapData = SimpleDataMap(data: map);
      var mapDataCopy = mapData.copyWith();
      mapData.data['a']?.num = 3;

      expect(mapDataCopy.data, hasLength(2));
      expect(mapDataCopy.data['a']?.num, 1);
      expect(mapDataCopy.data['a']?.id, null);
      expect(mapDataCopy.data['b']?.num, 2);
      expect(mapDataCopy.data['b']?.id, null);
    });
  });
}
