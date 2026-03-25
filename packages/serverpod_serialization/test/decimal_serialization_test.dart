import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  test(
    'Given a Decimal when encoding then output preserves the exact string representation.',
    () {
      var value = Decimal.parse('0.1');

      var encoded = SerializationManager.encode(value);

      expect(encoded, '"0.1"');
      expect(encoded, isNot(contains('0.10000000000000001')));
    },
  );

  test(
    'Given a high precision Decimal when encoding with type and decoding then output matches input.',
    () {
      var value = Decimal.parse('123456789.123456789012345678');

      var encoded = protocol.encodeWithType(value);
      var decoded = protocol.decodeWithType(encoded);

      expect(decoded, value);
    },
  );

  test(
    'Given a Decimal JSON string when deserializing then output is parsed as Decimal.',
    () {
      var decoded = protocol.deserialize<Decimal>('9999999999999.0000000001');

      expect(decoded, Decimal.parse('9999999999999.0000000001'));
    },
  );
}
