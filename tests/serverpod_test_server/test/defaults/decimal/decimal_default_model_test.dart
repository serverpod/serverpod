import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with "defaultModel" Decimal fields,', () {
    test(
      'when an object is created, then the "decimalDefaultModelStr" field should be Decimal(10.5).',
      () {
        var object = DecimalDefaultModel();
        expect(
          object.decimalDefaultModelStr,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when an object is created, then the nullable "decimalDefaultModelStrNull" field should be Decimal(20.5).',
      () {
        var object = DecimalDefaultModel();
        expect(
          object.decimalDefaultModelStrNull,
          equals(Decimal.parse('20.5')),
        );
      },
    );
  });
}
