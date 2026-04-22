import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  const encoder = SqliteValueEncoder();

  group('Given a Decimal value,', () {
    test(
      'when convert is called with a whole number, then it returns the decimal as a quoted TEXT literal',
      () {
        expect(encoder.convert(Decimal.parse('10')), equals("'10'"));
      },
    );

    test(
      'when convert is called with a fractional value, then it returns the canonical decimal as a quoted TEXT literal',
      () {
        expect(encoder.convert(Decimal.parse('10.5')), equals("'10.5'"));
      },
    );

    test(
      'when convert is called with a negative value, then the sign is preserved in the quoted literal',
      () {
        expect(encoder.convert(Decimal.parse('-0.001')), equals("'-0.001'"));
      },
    );

    test(
      'when convert is called with a very large value that would overflow int64, then the value is preserved as TEXT',
      () {
        final huge = Decimal.parse('999999999999999999999.999999');
        expect(
          encoder.convert(huge),
          equals("'999999999999999999999.999999'"),
        );
      },
    );
  });
}
