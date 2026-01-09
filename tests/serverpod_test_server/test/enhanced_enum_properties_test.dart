import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an enhanced enum with custom properties', () {
    test('when accessing shortName property then it returns correct value', () {
      expect(TestEnumEnhanced.one.shortName, '1');
      expect(TestEnumEnhanced.two.shortName, '2');
      expect(TestEnumEnhanced.three.shortName, '3');
    });

    test(
      'when accessing description property then it returns correct value',
      () {
        expect(TestEnumEnhanced.one.description, 'The first value');
        expect(TestEnumEnhanced.two.description, 'The second value');
        expect(TestEnumEnhanced.three.description, 'The third value');
      },
    );

    test('when accessing priority property then default value is used', () {
      expect(TestEnumEnhanced.one.priority, 10);
      expect(TestEnumEnhanced.two.priority, 0); // default value
      expect(TestEnumEnhanced.three.priority, 0); // default value
    });

    test('when calling toString then it returns the enum value name', () {
      expect(TestEnumEnhanced.one.toString(), 'one');
      expect(TestEnumEnhanced.two.toString(), 'two');
      expect(TestEnumEnhanced.three.toString(), 'three');
    });

    test('when calling toJson then it returns the index', () {
      expect(TestEnumEnhanced.one.toJson(), 0);
      expect(TestEnumEnhanced.two.toJson(), 1);
      expect(TestEnumEnhanced.three.toJson(), 2);
    });

    test(
      'when serializing and deserializing then properties are preserved',
      () {
        var encoded = SerializationManager.encode(TestEnumEnhanced.one);
        var decoded = Protocol().decode<TestEnumEnhanced>(encoded);
        expect(decoded, TestEnumEnhanced.one);
        expect(decoded.shortName, '1');
        expect(decoded.priority, 10);
      },
    );

    test('when deserializing then default property values are preserved', () {
      var encoded = SerializationManager.encode(TestEnumEnhanced.two);
      var decoded = Protocol().decode<TestEnumEnhanced>(encoded);
      expect(decoded, TestEnumEnhanced.two);
      expect(decoded.priority, 0); // default value
    });
  });
}
