import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed BigInt fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = BigIntDefaultMix();
          expect(
            object.bigIntDefaultAndDefaultModel,
            BigInt.two,
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = BigIntDefaultMix();
          expect(
            object.bigIntDefaultAndDefaultPersist,
            BigInt.parse('-12345678901234567890'),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = BigIntDefaultMix();
          expect(
            object.bigIntDefaultModelAndDefaultPersist,
            BigInt.parse('1234567890123456789099999999'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "bigIntDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var bigInt = BigInt.parse('18446744073709551615');
          var object = BigIntDefaultMix(
            bigIntDefaultAndDefaultModel: bigInt,
          );
          expect(
            object.bigIntDefaultAndDefaultModel,
            bigInt,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "bigIntDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var bigInt = BigInt.parse('18446744073709551615');
          var object = BigIntDefaultMix(
            bigIntDefaultAndDefaultPersist: bigInt,
          );
          expect(
            object.bigIntDefaultAndDefaultPersist,
            bigInt,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "bigIntDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var bigInt = BigInt.parse('18446744073709551615');
          var object = BigIntDefaultMix(
            bigIntDefaultModelAndDefaultPersist: bigInt,
          );
          expect(
            object.bigIntDefaultModelAndDefaultPersist,
            bigInt,
          );
        },
      );
    },
  );
}
