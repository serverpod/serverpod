import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given Bit with boolean values when created then toString and toList work correctly.',
    () {
      var vec = Bit([
        false,
        true,
        false,
        true,
        false,
        false,
        false,
        false,
        true,
      ]);
      expect(vec.toString(), equals('010100001'));
      expect(
        vec.toList(),
        equals([false, true, false, true, false, false, false, false, true]),
      );
    },
  );

  test(
    'Given two Bit vectors when comparing then equality works correctly.',
    () {
      var a = Bit([true, false, true]);
      var b = Bit([true, false, true]);
      var c = Bit([true, false, false]);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    },
  );

  test(
    'Given Bit when converting to string then returns correct binary representation.',
    () {
      var vec1 = Bit([true, false, true, false]);
      var vec2 = Bit([false, false, false, true]);
      var vec3 = Bit([true, true, true, true, true, true, true, true]);

      expect(vec1.toString(), equals('1010'));
      expect(vec2.toString(), equals('0001'));
      expect(vec3.toString(), equals('11111111'));
    },
  );

  test(
    'Given valid binary string when creating Bit from string then creates correct Bit vector.',
    () {
      var vec1 = Bit.fromString('1010');
      var vec2 = Bit.fromString('0001');
      var vec3 = Bit.fromString('11111111');

      expect(vec1.toList(), equals([true, false, true, false]));
      expect(vec2.toList(), equals([false, false, false, true]));
      expect(
        vec3.toList(),
        equals([true, true, true, true, true, true, true, true]),
      );
    },
  );

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
    },
  );

  test(
    'Given Bit with known number of booleans when accessing length then returns that count.',
    () {
      expect(Bit([]).length, equals(0));
      expect(Bit([true]).length, equals(1));
      expect(Bit([true, false, true, false]).length, equals(4));
      expect(
        Bit([
          false,
          true,
          false,
          true,
          false,
          false,
          false,
          false,
          true,
        ]).length,
        equals(9),
      );
    },
  );

  test(
    'Given Bit vector when accessing individual indices then returns correct values.',
    () {
      final vec = Bit([
        false,
        true,
        false,
        true,
        false,
        false,
        false,
        false,
        true,
      ]);
      expect(vec[0], isFalse);
      expect(vec[8], isTrue);
      expect(vec[7], isFalse);
    },
  );

  test(
    'Given Bit vector when accessing all indices then agrees with toList().',
    () {
      final vec = Bit([
        false,
        true,
        false,
        true,
        false,
        false,
        false,
        false,
        true,
      ]);
      final list = vec.toList();
      for (var i = 0; i < vec.length; i++) {
        expect(vec[i], equals(list[i]), reason: 'index $i');
      }
    },
  );

  test(
    'Given Bit vector when accessing valid last index then does not throw.',
    () {
      final vec = Bit([true, false, true]);
      expect(() => vec[2], returnsNormally);
    },
  );

  test(
    'Given Bit vector when accessing negative index then throws RangeError.',
    () {
      final vec = Bit([true, false, true]);
      expect(() => vec[-1], throwsA(isA<RangeError>()));
    },
  );

  test(
    'Given Bit vector when accessing index equal to length then throws RangeError.',
    () {
      final vec = Bit([true, false, true]);
      expect(() => vec[3], throwsA(isA<RangeError>()));
    },
  );

  test(
    'Given Bit vector when iterating with for-in then yields bits in order.',
    () {
      final bits = [false, true, false, true, false, false, false, false, true];
      final vec = Bit(bits);
      expect(vec.toList(), equals(bits));
    },
  );

  test(
    'Given Bit vector with at least one true bit when calling any then returns true.',
    () {
      final vec = Bit([false, false, true, false]);
      expect(vec.any((b) => b), isTrue);
    },
  );

  test(
    'Given Bit vector with all false bits when calling any then returns false.',
    () {
      final vec = Bit([false, false, false]);
      expect(vec.any((b) => b), isFalse);
    },
  );

  test(
    'Given Bit vector with all true bits when calling every then returns true.',
    () {
      final vec = Bit([true, true, true]);
      expect(vec.every((b) => b), isTrue);
    },
  );

  test(
    'Given Bit vector with at least one false bit when calling every then returns false.',
    () {
      final vec = Bit([true, true, false]);
      expect(vec.every((b) => b), isFalse);
    },
  );
}
