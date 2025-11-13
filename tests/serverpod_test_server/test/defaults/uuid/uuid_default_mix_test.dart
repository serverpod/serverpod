import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed UUID fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = UuidDefaultMix();
          expect(
            object.uuidDefaultAndDefaultModel,
            UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = UuidDefaultMix();
          expect(
            object.uuidDefaultAndDefaultPersist,
            UuidValue.fromString('6fa459ea-ee8a-3ca4-894e-db77e160355e'),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = UuidDefaultMix();
          expect(
            object.uuidDefaultModelAndDefaultPersist,
            UuidValue.fromString('d9428888-122b-11e1-b85c-61cd3cbb3210'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefaultMix(
            uuidDefaultAndDefaultModel: uuid,
          );
          expect(
            object.uuidDefaultAndDefaultModel,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefaultMix(
            uuidDefaultAndDefaultPersist: uuid,
          );
          expect(
            object.uuidDefaultAndDefaultPersist,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefaultMix(
            uuidDefaultModelAndDefaultPersist: uuid,
          );
          expect(
            object.uuidDefaultModelAndDefaultPersist,
            uuid,
          );
        },
      );
    },
  );
}
