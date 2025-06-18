import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given Vector with values when created then toString and toList work correctly.',
      () {
    const vec = Vector([1, 2, 3]);
    expect(vec.toString(), equals('[1.0, 2.0, 3.0]'));
    expect(vec.toList(), equals([1, 2, 3]));
  });

  test('Given two Vectors when comparing then equality works correctly.', () {
    const a = Vector([1, 2, 3]);
    const b = Vector([1, 2, 3]);
    const c = Vector([1, 2, 4]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
