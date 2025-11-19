import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' UUID fields",
    () {
      test(
        'when an object of the class is created, then the "default=random" UUID field should not be null',
        () {
          var object = UuidDefault();
          expect(object.uuidDefaultRandom, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the "default=random_v7 UUID field should not be null',
        () {
          var object = UuidDefault();
          expect(object.uuidDefaultRandomV7, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the nullable "default=random" UUID field should not be null',
        () {
          var object = UuidDefault();
          expect(object.uuidDefaultRandomNull, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the "default" UUID field with a string should match the default',
        () {
          var object = UuidDefault();
          expect(
            object.uuidDefaultStr,
            UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "default" UUID field with a string should match the default',
        () {
          var object = UuidDefault();
          expect(
            object.uuidDefaultStrNull,
            UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301'),
          );
        },
      );

      test(
        'when an object of the class is created, then the "default=random" UUID field should generate a valid UUID',
        () {
          var object = UuidDefault();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultRandom.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created, then the "default=random_v7" UUID field should generate a valid UUID',
        () {
          var object = UuidDefault();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultRandomV7.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "default=random" UUID field should generate a valid UUID',
        () {
          var object = UuidDefault();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultRandomNull.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultRandom", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefault(
            uuidDefaultRandom: uuid,
          );
          expect(
            object.uuidDefaultRandom,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultRandomV7", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefault(
            uuidDefaultRandomV7: uuid,
          );
          expect(
            object.uuidDefaultRandomV7,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultRandomNull", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
          );
          var object = UuidDefault(
            uuidDefaultRandomNull: uuid,
          );
          expect(
            object.uuidDefaultRandomNull,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultStr", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '550e8400-e29b-41d4-a716-446655440000',
          );
          var object = UuidDefault(
            uuidDefaultStr: uuid,
          );
          expect(
            object.uuidDefaultStr,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "uuidDefaultStrNull", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            '550e8400-e29b-41d4-a716-446655440000',
          );
          var object = UuidDefault(
            uuidDefaultStrNull: uuid,
          );
          expect(
            object.uuidDefaultStrNull,
            uuid,
          );
        },
      );
    },
  );
}
