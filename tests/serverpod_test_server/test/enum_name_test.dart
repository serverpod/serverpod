import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an enum serialized by name with one of its values named "name"',
      () {
    group('when calling "toString()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type" '
          'and not the "name" field', () {
        expect(TestByNameEnum.type.toString(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name" '
          'and not any custom field', () {
        expect(TestByNameEnum.name.toString(), 'name');
      });
    });

    group('when calling "toJson()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type" '
          'and not the "name" field', () {
        expect(TestByNameEnum.type.toJson(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name" '
          'and not any custom field', () {
        expect(TestByNameEnum.name.toJson(), 'name');
      });
    });

    group('when serializing and deserializing', () {
      test(
          'the value "type", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(TestByNameEnum.type);
        var decoded = Protocol().decode<TestByNameEnum>(encoded);
        expect(decoded, TestByNameEnum.type);
      });

      test(
          'the value "name", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(TestByNameEnum.name);
        var decoded = Protocol().decode<TestByNameEnum>(encoded);
        expect(decoded, TestByNameEnum.name);
      });
    });
  });

  group('Given an enum serialized by index with one of its values named "name"',
      () {
    group('when calling "toString()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type" '
          'and not the "name" field', () {
        expect(TestByIndexEnum.type.toString(), 'type');
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name" '
          'and not any custom field', () {
        expect(TestByIndexEnum.name.toString(), 'name');
      });
    });

    group('when calling "toJson()"', () {
      test(
          'on the value "type" '
          'then it should return the Dart code name "type" '
          'and not the "name" field', () {
        expect(TestByIndexEnum.type.toJson(), 0);
      });

      test(
          'on the value "name" '
          'then it should return the Dart code name "name" '
          'and not any custom field', () {
        expect(TestByIndexEnum.name.toJson(), 1);
      });
    });

    group('when serializing and deserializing', () {
      test(
          'the value "type", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(TestByIndexEnum.type);
        var decoded = Protocol().decode<TestByIndexEnum>(encoded);
        expect(decoded, TestByIndexEnum.type);
      });

      test(
          'the value "name", '
          'then it should result in the same enum value', () {
        var encoded = SerializationManager.encode(TestByIndexEnum.name);
        var decoded = Protocol().decode<TestByIndexEnum>(encoded);
        expect(decoded, TestByIndexEnum.name);
      });
    });
  });
}
