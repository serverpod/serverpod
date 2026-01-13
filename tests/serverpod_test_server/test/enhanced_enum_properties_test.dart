import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an enhanced enum serialized by index', () {
    test('when accessing properties then they return correct values', () {
      expect(TestEnumEnhanced.one.shortName, '1');
      expect(TestEnumEnhanced.one.description, 'The first value');
      expect(TestEnumEnhanced.one.priority, 10);
    });

    test('when accessing property with default then default is used', () {
      expect(TestEnumEnhanced.two.priority, 0); // default value
    });

    test('when calling toJson then it returns the index', () {
      expect(TestEnumEnhanced.one.toJson(), 0);
      expect(TestEnumEnhanced.two.toJson(), 1);
      expect(TestEnumEnhanced.three.toJson(), 2);
    });

    test(
      'when serializing and deserializing then properties are preserved',
      () {
        final encoded = SerializationManager.encode(TestEnumEnhanced.one);
        final decoded = Protocol().decode<TestEnumEnhanced>(encoded);
        expect(decoded, TestEnumEnhanced.one);
        expect(decoded.shortName, '1');
        expect(decoded.priority, 10);
      },
    );
  });

  group('Given an enhanced enum serialized by name', () {
    test('when accessing properties then they return correct values', () {
      expect(TestEnumEnhancedByName.one.shortName, '1');
      expect(TestEnumEnhancedByName.one.description, 'The first value');
      expect(TestEnumEnhancedByName.one.priority, 10);
    });

    test('when accessing property with default then default is used', () {
      expect(TestEnumEnhancedByName.two.priority, 0); // default value
    });

    test('when calling toJson then it returns the name as string', () {
      expect(TestEnumEnhancedByName.one.toJson(), 'one');
      expect(TestEnumEnhancedByName.two.toJson(), 'two');
      expect(TestEnumEnhancedByName.three.toJson(), 'three');
    });

    test(
      'when serializing and deserializing then properties are preserved',
      () {
        final encoded = SerializationManager.encode(TestEnumEnhancedByName.one);
        final decoded = Protocol().decode<TestEnumEnhancedByName>(encoded);
        expect(decoded, TestEnumEnhancedByName.one);
        expect(decoded.shortName, '1');
        expect(decoded.priority, 10);
      },
    );
  });
}
