import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' UUID fields",
    () {
      test(
        'when an object of the class is created, then the "defaultPersist=random" UUID field should be null',
        () {
          var object = UuidDefaultPersist();
          expect(object.uuidDefaultPersistRandom, isNull);
        },
      );
      test(
        'when an object of the class is created, then the "defaultPersist=random_v7" UUID field should be null',
        () {
          var object = UuidDefaultPersist();
          expect(object.uuidDefaultPersistRandomV7, isNull);
        },
      );

      test(
        'when an object of the class is created, then the "defaultPersist" UUID field with a string should be null',
        () {
          var object = UuidDefaultPersist();
          expect(object.uuidDefaultPersistStr, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultPersistRandom", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefaultPersist(
            uuidDefaultPersistRandom: uuid,
          );
          expect(
            object.uuidDefaultPersistRandom,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultPersistRandomV7", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefaultPersist(
            uuidDefaultPersistRandomV7: uuid,
          );
          expect(
            object.uuidDefaultPersistRandomV7,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultPersistStr", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '550e8400-e29b-41d4-a716-446655440000',
          );
          var object = UuidDefaultPersist(
            uuidDefaultPersistStr: uuid,
          );
          expect(
            object.uuidDefaultPersistStr,
            uuid,
          );
        },
      );
    },
  );
}
