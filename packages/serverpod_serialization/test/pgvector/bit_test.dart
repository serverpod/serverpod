import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test('works', () {
    var vec = Bit([false, true, false, true, false, false, false, false, true]);
    expect(vec.toString(), equals('010100001'));
    expect(vec.toList(),
        equals([false, true, false, true, false, false, false, false, true]));
  });

  test('equals', () {
    var a = Bit([true, false, true]);
    var b = Bit([true, false, true]);
    var c = Bit([true, false, false]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
