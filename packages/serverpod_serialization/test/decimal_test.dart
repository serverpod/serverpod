import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Decimal', () {
    test(
      'when created from a string, then toString returns the same string.',
      () {
        var decimal = Decimal.parse('123.456');
        expect(decimal.toString(), '123.456');
      },
    );

    test(
      'when created from an int, then toString returns the integer as string.',
      () {
        var decimal = Decimal.fromInt(42);
        expect(decimal.toString(), '42');
      },
    );

    test(
      'when created with tryParse on a valid string, then returns a Decimal.',
      () {
        var decimal = Decimal.tryParse('99.99');
        expect(decimal, isNotNull);
        expect(decimal.toString(), '99.99');
      },
    );

    test(
      'when created with tryParse on an invalid string, then returns null.',
      () {
        var decimal = Decimal.tryParse('not-a-number');
        expect(decimal, isNull);
      },
    );

    test(
      'when created with parse on an invalid string, then throws FormatException.',
      () {
        expect(() => Decimal.parse('abc'), throwsFormatException);
      },
    );

    test(
      'when two Decimals have the same value, then they are equal.',
      () {
        var a = Decimal.parse('10.5');
        var b = Decimal.parse('10.5');
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      },
    );

    test(
      'when two Decimals have different values, then they are not equal.',
      () {
        var a = Decimal.parse('10.5');
        var b = Decimal.parse('10.6');
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when created with a negative value, then toString preserves the sign.',
      () {
        var decimal = Decimal.parse('-123.456');
        expect(decimal.toString(), '-123.456');
      },
    );

    test(
      'when created with a very large value, then precision is preserved.',
      () {
        var decimal = Decimal.parse(
          '99999999999999999999.99999999999999999999',
        );
        expect(
          decimal.toString(),
          '99999999999999999999.99999999999999999999',
        );
      },
    );

    test(
      'when created with zero, then toString returns zero.',
      () {
        var decimal = Decimal.parse('0');
        expect(decimal.toString(), '0');
      },
    );

    test(
      'when comparing with Comparable, then ordering is correct.',
      () {
        var a = Decimal.parse('1.5');
        var b = Decimal.parse('2.5');
        var c = Decimal.parse('1.5');
        expect(a.compareTo(b), lessThan(0));
        expect(b.compareTo(a), greaterThan(0));
        expect(a.compareTo(c), equals(0));
      },
    );

    test(
      'when comparing negative Decimals, then ordering is correct.',
      () {
        var a = Decimal.parse('-5.5');
        var b = Decimal.parse('-2.5');
        expect(a.compareTo(b), lessThan(0));
        expect(b.compareTo(a), greaterThan(0));
      },
    );

    test(
      'when comparing Decimals with different fractional lengths, then compareTo and equals are consistent.',
      () {
        var a = Decimal.parse('1.5');
        var b = Decimal.parse('1.50');
        expect(a.compareTo(b), equals(0));
        expect(a, equals(b));
      },
    );

    test(
      'when comparing a negative Decimal to a positive Decimal, then the negative is less.',
      () {
        var negative = Decimal.parse('-5');
        var positive = Decimal.parse('3');
        expect(negative.compareTo(positive), lessThan(0));
        expect(positive.compareTo(negative), greaterThan(0));
      },
    );

    test(
      'when comparing Decimals with different integer lengths, then ordering is correct.',
      () {
        var small = Decimal.parse('9');
        var large = Decimal.parse('10');
        expect(small.compareTo(large), lessThan(0));
        expect(large.compareTo(small), greaterThan(0));
      },
    );

    test(
      'when performing arithmetic, then the result is precise.',
      () {
        var a = Decimal.parse('0.1');
        var b = Decimal.parse('0.2');
        expect(a + b, equals(Decimal.parse('0.3')));
      },
    );
  });
}
