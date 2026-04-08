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
      'when "default" and "defaultPersist" are set, then "default" is used for model.',
      () {
        var object = DecimalDefaultMix();
        expect(
          object.decimalDefaultAndDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when "defaultModel" and "defaultPersist" are set, then "defaultModel" is used for model.',
      () {
        var object = DecimalDefaultMix();
        expect(
          object.decimalDefaultModelAndDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );
  });
}
