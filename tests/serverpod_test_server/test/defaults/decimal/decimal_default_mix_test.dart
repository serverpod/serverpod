import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with mixed Decimal default fields,', () {
    test(
      'when "default" and "defaultModel" are set, then "defaultModel" takes precedence.',
      () {
        var object = DecimalDefaultMix();
        expect(
          object.decimalDefaultAndDefaultModel,
          equals(Decimal.parse('20.5')),
        );
      },
    );

    test(
      'when "default" and "defaultPersist" are set, then "default" is used for the model.',
      () {
        var object = DecimalDefaultMix();
        expect(
          object.decimalDefaultAndDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when "defaultModel" and "defaultPersist" are set, then "defaultModel" is used for the model.',
      () {
        var object = DecimalDefaultMix();
        expect(
          object.decimalDefaultModelAndDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when an object of the class is created with a value for "decimalDefaultAndDefaultModel", then the field value should match the provided value.',
      () {
        var object = DecimalDefaultMix(
          decimalDefaultAndDefaultModel: Decimal.parse('15.5'),
        );
        expect(
          object.decimalDefaultAndDefaultModel,
          equals(Decimal.parse('15.5')),
        );
      },
    );

    test(
      'when an object of the class is created with a value for "decimalDefaultAndDefaultPersist", then the field value should match the provided value.',
      () {
        var object = DecimalDefaultMix(
          decimalDefaultAndDefaultPersist: Decimal.parse('25.5'),
        );
        expect(
          object.decimalDefaultAndDefaultPersist,
          equals(Decimal.parse('25.5')),
        );
      },
    );

    test(
      'when an object of the class is created with a value for "decimalDefaultModelAndDefaultPersist", then the field value should match the provided value.',
      () {
        var object = DecimalDefaultMix(
          decimalDefaultModelAndDefaultPersist: Decimal.parse('30.5'),
        );
        expect(
          object.decimalDefaultModelAndDefaultPersist,
          equals(Decimal.parse('30.5')),
        );
      },
    );
  });
}
