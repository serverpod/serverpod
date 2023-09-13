import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

// Fake objects to verify behavior on.
enum TestEnum {
  one,
  two,
  three,
}

class SimpleData {
  int num;

  SimpleData({required this.num});

  SimpleData copyWith({int? num}) => SimpleData(num: num ?? this.num);
}

void main() {
  group('on ByteData', () {
    test(
        'Given a ByteData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      ByteData byteData =
          Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var copy = byteData.clone();

      byteData.setUint8(0, 9);

      expect(
        copy.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
    });

    group(
        'Given a ByteData when specifying a slice of the buffer and modifying the original after creating a copy',
        () {
      ByteBuffer buffer = Uint8List.fromList([0, 1, 2, 3, 4]).buffer;

      var offsetInBytes = 2;
      var lengthInBytes = 1;

      ByteData byteDataView = ByteData.view(
        buffer,
        offsetInBytes,
        lengthInBytes,
      );

      var clone = byteDataView.clone();

      buffer.asByteData().setUint8(0, 9);

      test('then the copy buffer has the full original data.', () {
        expect(clone.buffer.asUint8List(), Uint8List.fromList([0, 1, 2, 3, 4]));
      });

      test('then the view is preserved.', () {
        expect(clone.getInt8(0), byteDataView.getInt8(0));
      });

      test('then the offsetInBytes is preserved.', () {
        expect(clone.offsetInBytes, offsetInBytes);
      });

      test('then the lengthInBytes is preserved', () {
        expect(clone.lengthInBytes, lengthInBytes);
      });
    });
  });

  group('on List', () {
    test(
        'Given a list of strings when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = ['a', 'b', 'c'];
      var copy = list.clone();

      list.add('d');
      expect(copy, ['a', 'b', 'c']);
    });

    test(
        'Given a list of int when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [1, 2, 3];
      var copy = list.clone();

      list.add(4);
      expect(copy, [1, 2, 3]);
    });

    test(
        'Given a list of doubles when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [1.0, 2.0, 3.0];
      var copy = list.clone();

      list.add(4.0);
      expect(copy, [1.0, 2.0, 3.0]);
    });

    test(
        'Given a list of bool when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [true, false, true];
      var copy = list.clone();

      list.add(false);
      expect(copy, [true, false, true]);
    });

    test(
        'Given a list of DateTime when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [
        DateTime.fromMillisecondsSinceEpoch(1000),
        DateTime.fromMillisecondsSinceEpoch(2000),
        DateTime.fromMillisecondsSinceEpoch(3000),
      ];
      var copy = list.clone();

      list.add(DateTime.fromMillisecondsSinceEpoch(4000));
      expect(
        copy,
        [
          DateTime.fromMillisecondsSinceEpoch(1000),
          DateTime.fromMillisecondsSinceEpoch(2000),
          DateTime.fromMillisecondsSinceEpoch(3000),
        ],
      );
    });

    test(
        'Given a list of Duration when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [
        const Duration(seconds: 1),
        const Duration(seconds: 2),
        const Duration(seconds: 3),
      ];
      var copy = list.clone();

      list.add(const Duration(seconds: 4));
      expect(
        copy,
        [
          const Duration(seconds: 1),
          const Duration(seconds: 2),
          const Duration(seconds: 3),
        ],
      );
    });

    test(
        'Given a list of Uuid when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var expected = [
        UuidValue(const Uuid().v4()),
        UuidValue(const Uuid().v4()),
        UuidValue(const Uuid().v4()),
      ];
      var list = [...expected];
      var copy = list.clone();

      list.add(UuidValue(const Uuid().v4()));

      expect(copy, expected);
    });

    test(
        'Given a list of ByteData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      List<ByteData> list = [
        Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData(),
        Uint8List.fromList([5, 6, 7, 8, 9]).buffer.asByteData(),
      ];
      List<ByteData> copy = list.clone();

      list.add(Uint8List.fromList([10, 11, 12, 13, 14]).buffer.asByteData());

      expect(copy, hasLength(2));
      expect(
        copy[0].buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
      expect(
        copy[1].buffer.asUint8List(),
        Uint8List.fromList([5, 6, 7, 8, 9]),
      );
    });

    test(
        'Given a list of ByteData when modifying the original deep object after creating a copy then the copy is left unmodified',
        () {
      List<ByteData> list = [
        Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData(),
        Uint8List.fromList([5, 6, 7, 8, 9]).buffer.asByteData(),
      ];
      List<ByteData> copy = list.clone();

      list[0].setUint8(0, 9);

      expect(copy, hasLength(2));
      expect(
        copy[0].buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
      expect(
        copy[1].buffer.asUint8List(),
        Uint8List.fromList([5, 6, 7, 8, 9]),
      );
    });

    test(
        'Given a list of SimpleData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [
        SimpleData(num: 1),
        SimpleData(num: 2),
      ];
      var copy = list.clone();

      list.add(SimpleData(num: 3));

      expect(copy, hasLength(2));
      expect(copy[0].num, 1);
      expect(copy[1].num, 2);
    });

    test(
        'Given a list of SimpleData when modifying the deep object the original after creating a copy then the copy is left unmodified',
        () {
      var list = [
        SimpleData(num: 1),
        SimpleData(num: 2),
      ];
      var copy = list.clone();

      list[0].num = 3;

      expect(copy, hasLength(2));
      expect(copy[0].num, 1);
      expect(copy[1].num, 2);
    });

    test(
        'Given a list of enums when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [TestEnum.one, TestEnum.two];
      var copy = list.clone();

      list.add(TestEnum.three);

      expect(copy, [TestEnum.one, TestEnum.two]);
    });

    test(
        'Given a list of null when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var list = [null];
      var copy = list.clone();

      list.add(null);

      expect(copy, [null]);
    });

    test(
        'Given a list of lists when modifying the deep list after creating a copy then the copy is left unmodified',
        () {
      var list = [
        [1, 2, 3],
        [4, 5, 6],
      ];
      var copy = list.clone();

      list[0].add(4);

      expect(copy, [
        [1, 2, 3],
        [4, 5, 6],
      ]);
    });

    test(
        'Given a list of maps when modifying the deep map after creating a copy then the copy is left unmodified',
        () {
      var list = [
        {'a': 1, 'b': 2},
        {'c': 3, 'd': 4},
      ];
      var copy = list.clone();

      list[0]['a'] = 3;

      expect(copy, [
        {'a': 1, 'b': 2},
        {'c': 3, 'd': 4},
      ]);
    });
  });

  group('on Map', () {
    test(
        'Given a map of strings when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {'a': '1', 'b': '2', 'c': '3'};
      var copy = map.clone();

      map['a'] = '4';
      expect(copy, {'a': '1', 'b': '2', 'c': '3'});
    });

    test(
        'Given a map of int when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {'a': 1, 'b': 2, 'c': 3};
      var copy = map.clone();

      map['a'] = 4;
      expect(copy, {'a': 1, 'b': 2, 'c': 3});
    });

    test(
        'Given a map of doubles when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {'a': 1.0, 'b': 2.0, 'c': 3.0};
      var copy = map.clone();

      map['a'] = 4.0;
      expect(copy, {'a': 1.0, 'b': 2.0, 'c': 3.0});
    });

    test(
        'Given a map of bool when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {'a': true, 'b': false, 'c': true};
      var copy = map.clone();

      map['a'] = false;
      expect(copy, {'a': true, 'b': false, 'c': true});
    });

    test(
        'Given a map of DateTimes when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': DateTime.fromMillisecondsSinceEpoch(1000),
        'b': DateTime.fromMillisecondsSinceEpoch(2000),
        'c': DateTime.fromMillisecondsSinceEpoch(3000),
      };
      var copy = map.clone();

      map['a'] = DateTime.fromMillisecondsSinceEpoch(4000);
      expect(
        copy,
        {
          'a': DateTime.fromMillisecondsSinceEpoch(1000),
          'b': DateTime.fromMillisecondsSinceEpoch(2000),
          'c': DateTime.fromMillisecondsSinceEpoch(3000),
        },
      );
    });

    test(
        'Given a map of Duration when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': const Duration(seconds: 1),
        'b': const Duration(seconds: 2),
        'c': const Duration(seconds: 3),
      };
      var copy = map.clone();

      map['a'] = const Duration(seconds: 4);
      expect(
        copy,
        {
          'a': const Duration(seconds: 1),
          'b': const Duration(seconds: 2),
          'c': const Duration(seconds: 3),
        },
      );
    });

    test(
        'Given a map of Uuid when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var uuid = const Uuid();
      var map = {
        'a': UuidValue(Uuid.NAMESPACE_NIL),
        'b': UuidValue(Uuid.NAMESPACE_NIL),
        'c': UuidValue(Uuid.NAMESPACE_NIL),
      };

      var copy = map.clone();

      map['a'] = UuidValue(uuid.v4());

      expect(copy, {
        'a': UuidValue(Uuid.NAMESPACE_NIL),
        'b': UuidValue(Uuid.NAMESPACE_NIL),
        'c': UuidValue(Uuid.NAMESPACE_NIL),
      });
    });

    test(
        'Given a map of ByteData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      Map<String, ByteData> map = {
        'a': Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData(),
        'b': Uint8List.fromList([5, 6, 7, 8, 9]).buffer.asByteData(),
      };
      Map<String, ByteData> copy = map.clone();

      map['a']?.setUint8(0, 9);

      expect(copy, hasLength(2));
      expect(
        copy['a']!.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
      expect(
        copy['b']!.buffer.asUint8List(),
        Uint8List.fromList([5, 6, 7, 8, 9]),
      );
    });

    test(
        'Given a map of SimpleData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': SimpleData(num: 1),
        'b': SimpleData(num: 2),
      };
      var copy = map.clone();

      map['a'] = SimpleData(num: 3);

      expect(copy, hasLength(2));
      expect(copy['a']!.num, 1);
      expect(copy['b']!.num, 2);
    });

    test(
        'Given a map of SimpleData when modifying the deep object the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': SimpleData(num: 1),
        'b': SimpleData(num: 2),
      };
      var copy = map.clone();

      map['a']!.num = 3;

      expect(copy, hasLength(2));
      expect(copy['a']!.num, 1);
      expect(copy['b']!.num, 2);
    });

    test(
        'Given a map of enums when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'x': TestEnum.one,
        'y': TestEnum.two,
      };
      var copy = map.clone();

      map['x'] = TestEnum.three;

      expect(copy, {
        'x': TestEnum.one,
        'y': TestEnum.two,
      });
    });

    test(
        'Given a map with null values when modifying the original after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': null,
      };
      var copy = map.clone();

      map['b'] = null;

      expect(copy, {
        'a': null,
      });
    });

    test(
        'Given a map with lists as values when modifying the deep list after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      };
      var copy = map.clone();

      map['a']!.add(4);

      expect(copy, {
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });
    });

    test(
        'Given a map with maps as values when modifying the deep map after creating a copy then the copy is left unmodified',
        () {
      var map = {
        'x': {'a': 1, 'b': 2},
        'y': {'c': 3, 'd': 4},
      };
      var copy = map.clone();

      map['x']!['a'] = 3;

      expect(copy, {
        'x': {'a': 1, 'b': 2},
        'y': {'c': 3, 'd': 4},
      });
    });
  });
}
