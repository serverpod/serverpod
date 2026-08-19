import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given Vector with values when created then toString and toList work correctly.',
    () {
      const vec = Vector([1, 2, 3]);
      expect(vec.toString(), equals('[1.0, 2.0, 3.0]'));
      expect(vec.toList(), equals([1, 2, 3]));
    },
  );

  test('Given two Vectors when comparing then equality works correctly.', () {
    const a = Vector([1, 2, 3]);
    const b = Vector([1, 2, 3]);
    const c = Vector([1, 2, 4]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });

  test(
    'Given Vector with known number of elements when accessing length then returns that count.',
    () {
      expect(const Vector([]).length, equals(0));
      expect(const Vector([1.0]).length, equals(1));
      expect(const Vector([1.0, 2.0, 3.0]).length, equals(3));
    },
  );

  test(
    'Given Vector when accessing individual indices then returns correct values.',
    () {
      const vec = Vector([1.0, 2.0, 3.0]);
      expect(vec[0], equals(1.0));
      expect(vec[1], equals(2.0));
      expect(vec[2], equals(3.0));
    },
  );

  test(
    'Given Vector when accessing all indices then agrees with toList().',
    () {
      const vec = Vector([1.0, 2.0, 3.0, 4.0]);
      final list = vec.toList();
      for (var i = 0; i < vec.length; i++) {
        expect(vec[i], equals(list[i]), reason: 'index $i');
      }
    },
  );

  test(
    'Given Vector when accessing negative index then throws RangeError.',
    () {
      expect(
        () => const Vector([1.0, 2.0, 3.0])[-1],
        throwsA(isA<RangeError>()),
      );
    },
  );

  test(
    'Given Vector when accessing index equal to length then throws RangeError.',
    () {
      expect(
        () => const Vector([1.0, 2.0, 3.0])[3],
        throwsA(isA<RangeError>()),
      );
    },
  );

  test(
    'Given Vector when iterating with for-in then yields elements in order.',
    () {
      const vec = Vector([1.0, 2.0, 3.0]);
      expect(vec.toList(), equals([1.0, 2.0, 3.0]));
    },
  );

  test(
    'Given Vector with a matching element when calling any then returns true.',
    () {
      expect(const Vector([1.0, 2.0, 3.0]).any((v) => v > 2), isTrue);
    },
  );

  test(
    'Given Vector where all elements match when calling every then returns true.',
    () {
      expect(const Vector([1.0, 2.0, 3.0]).every((v) => v > 0), isTrue);
    },
  );
}
