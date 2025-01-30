import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' BigInt fields",
    () {
      test(
        'when an object of the class is created, then the "defaultModel" BigInt field with a string should match the default',
        () {
          var object = BigIntDefaultModel();
          expect(
            object.bigIntDefaultModelStr,
            BigInt.parse('1234567890123456789099999999'),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel" BigInt field with a string should match the default',
        () {
          var object = BigIntDefaultModel();
          expect(
            object.bigIntDefaultModelStrNull,
            BigInt.parse('-1234567890123456789099999999'),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "bigIntDefaultModelStr", then the field value should match the provided value',
        () {
          var bigInt = BigInt.one;
          var object = BigIntDefaultModel(
            bigIntDefaultModelStr: bigInt,
          );
          expect(
            object.bigIntDefaultModelStr,
            bigInt,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "bigIntDefaultModelStrNull", then the field value should match the provided value',
        () {
          var bigInt = BigInt.one;
          var object = BigIntDefaultModel(
            bigIntDefaultModelStrNull: bigInt,
          );
          expect(
            object.bigIntDefaultModelStrNull,
            bigInt,
          );
        },
      );
    },
  );
}
