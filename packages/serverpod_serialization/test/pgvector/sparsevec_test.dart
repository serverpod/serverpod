import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given SparseVector with non-zero values when created then properties are correctly set',
    () {
      var vec = SparseVector([1, 0, 2, 0, 3, 0]);
      expect(vec.toString(), equals('{1:1.0,3:2.0,5:3.0}/6'));
      expect(vec.toList(), equals([1, 0, 2, 0, 3, 0]));
      expect(vec.dimensions, equals(6));
      expect(vec.indices, equals([0, 2, 4]));
      expect(vec.values, equals([1, 2, 3]));
    },
  );

  test(
    'Given map of indices to values when creating SparseVector then properties are correctly set',
    () {
      var vec = SparseVector.fromMap({3: 2.0, 5: 3.0, 1: 1.0, 4: 0.0}, 6);
      expect(vec.toString(), equals('{1:1.0,3:2.0,5:3.0}/6'));
      expect(vec.toList(), equals([1, 0, 2, 0, 3, 0]));
      expect(vec.dimensions, equals(6));
      expect(vec.indices, equals([0, 2, 4]));
      expect(vec.values, equals([1, 2, 3]));
    },
  );

  test(
    'Given map with index 0 when creating SparseVector then ArgumentError is thrown',
    () {
      expect(() => SparseVector.fromMap({0: 1.0}, 1), throwsArgumentError);
    },
  );

  test(
    'Given two SparseVectors when comparing then equality works correctly',
    () {
      var a = SparseVector([1, 2, 3]);
      var b = SparseVector([1, 2, 3]);
      var c = SparseVector([1, 2, 4]);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    },
  );

  test(
    'Given SparseVector when converting to string then returns correct representation.',
    () {
      var vec1 = SparseVector([1, 0, 2, 0, 3]);
      var vec2 = SparseVector([0, 0, 0, 4]);
      var vec3 = SparseVector([1, 2, 3, 4]);

      expect(vec1.toString(), equals('{1:1.0,3:2.0,5:3.0}/5'));
      expect(vec2.toString(), equals('{4:4.0}/4'));
      expect(vec3.toString(), equals('{1:1.0,2:2.0,3:3.0,4:4.0}/4'));
    },
  );

  test(
    'Given valid string when creating SparseVector from string then creates correct SparseVector.',
    () {
      var vec1 = SparseVector.fromString('{1:1.0,3:2.0,5:3.0}/5');
      var vec2 = SparseVector.fromString('{4:4.0}/4');
      var vec3 = SparseVector.fromString('{1:1.0,2:2.0,3:3.0,4:4.0}/4');
      var vec4 = SparseVector.fromString('{}/4');

      expect(vec1.toList(), equals([1, 0, 2, 0, 3]));
      expect(vec2.toList(), equals([0, 0, 0, 4]));
      expect(vec3.toList(), equals([1, 2, 3, 4]));
      expect(vec4.toList(), equals([0, 0, 0, 0]));
    },
  );

  test(
    'Given invalid string when creating SparseVector from string then throws FormatException.',
    () {
      final invalidStrings = [
        '',
        'invalid',
        '{1:1.0}/',
        '1:1.0}/5',
        '{1:1.0/5',
      ];

      for (final value in invalidStrings) {
        expect(
          () => SparseVector.fromString(value),
          throwsA(isA<FormatException>()),
        );
      }
    },
  );

  test(
    'Given SparseVector with all zeros when created then properties are correctly set',
    () {
      var vec = SparseVector([0, 0, 0, 0]);
      expect(vec.toString(), equals('{}/4'));
      expect(vec.toList(), equals([0, 0, 0, 0]));
      expect(vec.dimensions, equals(4));
      expect(vec.indices, isEmpty);
      expect(vec.values, isEmpty);
    },
  );

  test(
    'Given SparseVector with known dimensions when accessing length then returns dimension count.',
    () {
      expect(SparseVector([]).length, equals(0));
      expect(SparseVector([1.0]).length, equals(1));
      expect(SparseVector([1.0, 0.0, 2.0]).length, equals(3));
    },
  );

  test(
    'Given SparseVector when accessing a stored non-zero index then returns the value.',
    () {
      final vec = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      expect(vec[0], equals(1.0));
      expect(vec[2], equals(2.0));
      expect(vec[4], equals(3.0));
    },
  );

  test(
    'Given SparseVector when accessing a zero-valued index then returns 0.0.',
    () {
      final vec = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      expect(vec[1], equals(0.0));
      expect(vec[3], equals(0.0));
    },
  );

  test(
    'Given SparseVector when accessing all indices then agrees with toList().',
    () {
      final vec = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      final list = vec.toList();
      for (var i = 0; i < vec.length; i++) {
        expect(vec[i], equals(list[i]), reason: 'index $i');
      }
    },
  );

  test(
    'Given SparseVector when accessing negative index then throws RangeError.',
    () {
      expect(
        () => SparseVector([1.0, 2.0, 3.0])[-1],
        throwsA(isA<RangeError>()),
      );
    },
  );

  test(
    'Given SparseVector when accessing index equal to dimensions then throws RangeError.',
    () {
      expect(
        () => SparseVector([1.0, 2.0, 3.0])[3],
        throwsA(isA<RangeError>()),
      );
    },
  );

  test(
    'Given SparseVector when iterating with for-in then yields all elements in order.',
    () {
      final vec = SparseVector([1.0, 0.0, 2.0]);
      expect(vec.toList(), equals([1.0, 0.0, 2.0]));
    },
  );

  test(
    'Given SparseVector with a matching element when calling any then returns true.',
    () {
      expect(SparseVector([0.0, 0.0, 3.0]).any((v) => v > 0), isTrue);
    },
  );

  test(
    'Given SparseVector with all non-negative values when calling every then returns true.',
    () {
      expect(SparseVector([1.0, 0.0, 2.0]).every((v) => v >= 0), isTrue);
    },
  );
}
