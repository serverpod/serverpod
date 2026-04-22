import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with "default" Decimal fields,', () {
    test(
      'when an object is created, then the "decimalDefault" field should be Decimal(10.5).',
      () {
        var object = DecimalDefault();
        expect(object.decimalDefault, equals(Decimal.parse('10.5')));
      },
    );

    test(
      'when an object is created, then the nullable "decimalDefaultNull" field should be Decimal(20.5).',
      () {
        var object = DecimalDefault();
        expect(object.decimalDefaultNull, equals(Decimal.parse('20.5')));
      },
    );

    test(
      'when an object is created with a specific value, then the value should be the provided value.',
      () {
        var object = DecimalDefault(
          decimalDefault: Decimal.parse('99.99'),
        );
        expect(object.decimalDefault, equals(Decimal.parse('99.99')));
      },
    );

    test(
      'when copyWith is called with a new value, then the copy has the new value.',
      () {
        var object = DecimalDefault();
        var copy = object.copyWith(decimalDefault: Decimal.parse('99.99'));
        expect(copy.decimalDefault, equals(Decimal.parse('99.99')));
        expect(object.decimalDefault, equals(Decimal.parse('10.5')));
      },
    );

    test(
      'when copyWith is called without changes, then the copy has the same values.',
      () {
        var object = DecimalDefault(
          decimalDefault: Decimal.parse('42.0'),
          decimalDefaultNull: Decimal.parse('7.5'),
        );
        var copy = object.copyWith();
        expect(copy.decimalDefault, equals(object.decimalDefault));
        expect(copy.decimalDefaultNull, equals(object.decimalDefaultNull));
      },
    );
  });
}
