import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test('works', () {
    const vec = HalfVector([1, 2, 3]);
    expect(vec.toString(), equals('[1.0, 2.0, 3.0]'));
    expect(vec.toList(), equals([1, 2, 3]));
  });

  test('equals', () {
    const a = HalfVector([1, 2, 3]);
    const b = HalfVector([1, 2, 3]);
    const c = HalfVector([1, 2, 4]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
