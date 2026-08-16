import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an enhanced enum with required properties', () {
    test(
      'when accessing a required property then it returns the correct value',
      () {
        expect(TestEnumEnhanced.one.shortName, '1');
        expect(TestEnumEnhanced.one.description, 'The first value');
      },
    );

    test(
      'when calling toJson on byIndex enum then it returns the index',
      () {
        expect(TestEnumEnhanced.one.toJson(), 0);
        expect(TestEnumEnhanced.two.toJson(), 1);
        expect(TestEnumEnhanced.three.toJson(), 2);
      },
    );

    test(
      'when calling toJson on byName enum then it returns the name as string',
      () {
        expect(TestEnumEnhancedByName.one.toJson(), 'one');
        expect(TestEnumEnhancedByName.two.toJson(), 'two');
        expect(TestEnumEnhancedByName.three.toJson(), 'three');
      },
    );

    test(
      'when serializing and deserializing then properties are preserved',
      () {
        final encoded = SerializationManager.encode(TestEnumEnhanced.one);
        final decoded = Protocol().decode<TestEnumEnhanced>(encoded);
        expect(decoded, TestEnumEnhanced.one);
        expect(decoded.shortName, '1');
      },
    );
  });

  group('Given an enhanced enum with properties that have default values', () {
    test(
      'when accessing property with explicitly set value then that value is returned',
      () {
        expect(TestEnumEnhanced.one.priority, 10);
      },
    );

    test(
      'when accessing property with no set value then the default value is used',
      () {
        expect(TestEnumEnhanced.two.priority, 0);
        expect(TestEnumEnhanced.three.priority, 0);
      },
    );

    test(
      'when serializing and deserializing then default values are preserved',
      () {
        final encoded = SerializationManager.encode(TestEnumEnhanced.two);
        final decoded = Protocol().decode<TestEnumEnhanced>(encoded);
        expect(decoded, TestEnumEnhanced.two);
        expect(decoded.priority, 0);
      },
    );
  });
}
