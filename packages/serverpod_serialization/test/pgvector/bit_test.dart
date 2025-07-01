import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given Bit with boolean values when created then toString and toList work correctly.',
      () {
    var vec = Bit([false, true, false, true, false, false, false, false, true]);
    expect(vec.toString(), equals('010100001'));
    expect(vec.toList(),
        equals([false, true, false, true, false, false, false, false, true]));
  });

  test('Given two Bit vectors when comparing then equality works correctly.',
      () {
    var a = Bit([true, false, true]);
    var b = Bit([true, false, true]);
    var c = Bit([true, false, false]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });

  test(
      'Given Bit when converting to string then returns correct binary representation.',
      () {
    var vec1 = Bit([true, false, true, false]);
    var vec2 = Bit([false, false, false, true]);
    var vec3 = Bit([true, true, true, true, true, true, true, true]);

    expect(vec1.toString(), equals('1010'));
    expect(vec2.toString(), equals('0001'));
    expect(vec3.toString(), equals('11111111'));
  });

  test(
      'Given valid binary string when creating Bit from string then creates correct Bit vector.',
      () {
    var vec1 = Bit.fromString('1010');
    var vec2 = Bit.fromString('0001');
    var vec3 = Bit.fromString('11111111');

    expect(vec1.toList(), equals([true, false, true, false]));
    expect(vec2.toList(), equals([false, false, false, true]));
    expect(vec3.toList(),
        equals([true, true, true, true, true, true, true, true]));
  });

  test(
      'Given invalid string when creating Bit from string then throws FormatException.',
      () {
    final invalidStrings = [
      '',
      '102',
      'abc',
      '1a0',
    ];

    for (final value in invalidStrings) {
      expect(() => Bit.fromString(value), throwsA(isA<FormatException>()));
    }
  });
}
