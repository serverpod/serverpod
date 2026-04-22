import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  group('Given a Decimal value', () {
    test(
      'when serialized to JSON, then it is encoded as a String.',
      () {
        var decimal = Decimal.parse('123.456');
        var encoded = SerializationManager.encode(decimal);
        expect(encoded, '"123.456"');
      },
    );

    test(
      'when deserialized from a String, then the Decimal is restored.',
      () {
        var decimal = protocol.deserialize<Decimal>('123.456');
        expect(decimal, equals(Decimal.parse('123.456')));
      },
    );

    test(
      'when deserialized from null for nullable type, then returns null.',
      () {
        var decimal = protocol.deserialize<Decimal?>(null);
        expect(decimal, isNull);
      },
    );

    test(
      'when round-tripped through JSON extension, then precision is preserved.',
      () {
        var original = Decimal.parse(
          '99999999999999999999.99999999999999999999',
        );
        var json = original.toJson();
        var restored = DecimalJsonExtension.fromJson(json);
        expect(restored, equals(original));
      },
    );

    test(
      'when getClassNameForObject is called, then returns "Decimal".',
      () {
        var decimal = Decimal.parse('1.5');
        var name = protocol.getClassNameForObject(decimal);
        expect(name, 'Decimal');
      },
    );

    test(
      'when deserialized by class name, then the Decimal is restored.',
      () {
        var result = protocol.deserializeByClassName(
          {'className': 'Decimal', 'data': '42.5'},
        );
        expect(result, equals(Decimal.parse('42.5')));
      },
    );

    test(
      'when a high-precision Decimal is round-tripped through JSON, then all digits are preserved.',
      () {
        var original = Decimal.parse('12345678.12345678');
        var encoded = SerializationManager.encode(original);
        var decoded = protocol.deserialize<Decimal>(jsonDecode(encoded));
        expect(decoded, equals(original));
      },
    );

    test(
      'when a negative Decimal is serialized, then the sign is preserved.',
      () {
        var decimal = Decimal.parse('-999.99');
        var encoded = SerializationManager.encode(decimal);
        var decoded = protocol.deserialize<Decimal>(jsonDecode(encoded));
        expect(decoded, equals(decimal));
      },
    );

    test(
      'when zero Decimal is round-tripped, then it stays zero.',
      () {
        var decimal = Decimal.parse('0');
        var json = decimal.toJson();
        var restored = DecimalJsonExtension.fromJson(json);
        expect(restored, equals(decimal));
        expect(restored.toString(), '0');
      },
    );
  });
}
