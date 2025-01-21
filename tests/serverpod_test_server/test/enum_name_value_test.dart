import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an enum serialized by name with one of its values named "name"',
      () {
    group('when calling "toString()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type"', () {
        expect(ByNameEnumWithNameValue.type.toString(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name"', () {
        expect(ByNameEnumWithNameValue.name.toString(), 'name');
      });
    });

    group('when calling "toJson()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type"', () {
        expect(ByNameEnumWithNameValue.type.toJson(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name"', () {
        expect(ByNameEnumWithNameValue.name.toJson(), 'name');
      });
    });

    group('when serializing and deserializing', () {
      test(
          'the value "type", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(ByNameEnumWithNameValue.type);
        var decoded = Protocol().decode<ByNameEnumWithNameValue>(encoded);
        expect(decoded, ByNameEnumWithNameValue.type);
      });

      test(
          'the value "name", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(ByNameEnumWithNameValue.name);
        var decoded = Protocol().decode<ByNameEnumWithNameValue>(encoded);
        expect(decoded, ByNameEnumWithNameValue.name);
      });
    });
  });

  group('Given an enum serialized by index with one of its values named "name"',
      () {
    group('when calling "toString()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type"', () {
        expect(ByIndexEnumWithNameValue.type.toString(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name"', () {
        expect(ByIndexEnumWithNameValue.name.toString(), 'name');
      });
    });

    group('when calling "toJson()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type"', () {
        expect(ByIndexEnumWithNameValue.type.toJson(), 0);
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name"', () {
        expect(ByIndexEnumWithNameValue.name.toJson(), 1);
      });
    });

    group('when serializing and deserializing', () {
      test(
          'the value "type", '
          'then it should result in the same enum value', () {
        var encoded =
            SerializationManager.encode(ByIndexEnumWithNameValue.type);
        var decoded = Protocol().decode<ByIndexEnumWithNameValue>(encoded);
        expect(decoded, ByIndexEnumWithNameValue.type);
      });

      test(
          'the value "name", '
          'then it should result in the same enum value', () {
        var encoded =
            SerializationManager.encode(ByIndexEnumWithNameValue.name);
        var decoded = Protocol().decode<ByIndexEnumWithNameValue>(encoded);
        expect(decoded, ByIndexEnumWithNameValue.name);
      });
    });
  });
}
