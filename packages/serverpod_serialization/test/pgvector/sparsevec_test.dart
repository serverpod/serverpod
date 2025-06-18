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
  });

  test(
      'Given map of indices to values when creating SparseVector then properties are correctly set',
      () {
    var vec = SparseVector.fromMap({3: 2.0, 5: 3.0, 1: 1.0, 4: 0.0}, 6);
    expect(vec.toString(), equals('{1:1.0,3:2.0,5:3.0}/6'));
    expect(vec.toList(), equals([1, 0, 2, 0, 3, 0]));
    expect(vec.dimensions, equals(6));
    expect(vec.indices, equals([0, 2, 4]));
    expect(vec.values, equals([1, 2, 3]));
  });

  test(
      'Given map with index 0 when creating SparseVector then ArgumentError is thrown',
      () {
    expect(() => SparseVector.fromMap({0: 1.0}, 1), throwsArgumentError);
  });

  test('Given two SparseVectors when comparing then equality works correctly',
      () {
    var a = SparseVector([1, 2, 3]);
    var b = SparseVector([1, 2, 3]);
    var c = SparseVector([1, 2, 4]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });

  test(
      'Given SparseVector when converting to string then returns correct representation.',
      () {
    var vec1 = SparseVector([1, 0, 2, 0, 3]);
    var vec2 = SparseVector([0, 0, 0, 4]);
    var vec3 = SparseVector([1, 2, 3, 4]);

    expect(vec1.toString(), equals('{1:1.0,3:2.0,5:3.0}/5'));
    expect(vec2.toString(), equals('{4:4.0}/4'));
    expect(vec3.toString(), equals('{1:1.0,2:2.0,3:3.0,4:4.0}/4'));
  });

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
  });

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
      expect(() => SparseVector.fromString(value),
          throwsA(isA<FormatException>()));
    }
  });

  test(
      'Given SparseVector with all zeros when created then properties are correctly set',
      () {
    var vec = SparseVector([0, 0, 0, 0]);
    expect(vec.toString(), equals('{}/4'));
    expect(vec.toList(), equals([0, 0, 0, 0]));
    expect(vec.dimensions, equals(4));
    expect(vec.indices, isEmpty);
    expect(vec.values, isEmpty);
  });
}
