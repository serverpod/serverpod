import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' UUID fields",
    () {
      test(
        'when an object of the class is created, then the "defaultModel=random" UUID field should not be null',
        () {
          var object = UuidDefaultModel();
          expect(object.uuidDefaultModelRandom, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel=random_7" UUID field should not be null',
        () {
          var object = UuidDefaultModel();
          expect(object.uuidDefaultModelRandomV7, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel=random" UUID field should not be null',
        () {
          var object = UuidDefaultModel();
          expect(object.uuidDefaultModelRandomNull, isNotNull);
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel" UUID field with a string should match the default',
        () {
          var object = UuidDefaultModel();
          expect(
            object.uuidDefaultModelStr,
            UuidValue.fromString("550e8400-e29b-41d4-a716-446655440000"),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel" UUID field with a string should match the default',
        () {
          var object = UuidDefaultModel();
          expect(
            object.uuidDefaultModelStrNull,
            UuidValue.fromString("3f2504e0-4f89-11d3-9a0c-0305e82c3301"),
          );
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel=random" UUID field should generate a valid UUID',
        () {
          var object = UuidDefaultModel();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultModelRandom.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel=random_v7" UUID field should generate a valid UUID',
        () {
          var object = UuidDefaultModel();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultModelRandomV7.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel=random" UUID field should generate a valid UUID',
        () {
          var object = UuidDefaultModel();
          expect(
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            ).hasMatch(object.uuidDefaultModelRandomNull.toString()),
            isTrue,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultModelRandom", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            "3f2504e0-4f89-11d3-9a0c-0305e82c3301",
          );
          var object = UuidDefaultModel(
            uuidDefaultModelRandom: uuid,
          );
          expect(
            object.uuidDefaultModelRandom,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultModelRandomV7", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            "3f2504e0-4f89-11d3-9a0c-0305e82c3301",
          );
          var object = UuidDefaultModel(
            uuidDefaultModelRandomV7: uuid,
          );
          expect(
            object.uuidDefaultModelRandomV7,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultModelStr", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            "550e8400-e29b-41d4-a716-446655440000",
          );
          var object = UuidDefaultModel(
            uuidDefaultModelStr: uuid,
          );
          expect(
            object.uuidDefaultModelStr,
            uuid,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "uuidDefaultModelStrNull", then the field value should match the provided value',
        () {
          var uuid = UuidValue.fromString(
            "550e8400-e29b-41d4-a716-446655440000",
          );
          var object = UuidDefaultModel(
            uuidDefaultModelStrNull: uuid,
          );
          expect(
            object.uuidDefaultModelStrNull,
            uuid,
          );
        },
      );
    },
  );
}
