import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' BigInt fields",
    () {
      test(
        'when an object of the class is created, then the "default" BigInt field with a string should match the default',
        () {
          var object = BigIntDefault();
          expect(
            object.bigintDefaultStr,
            BigInt.parse('-1234567890123456789099999999'),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "default" BigInt field with a string should match the default',
        () {
          var object = BigIntDefault();
          expect(
            object.bigintDefaultStrNull,
            BigInt.parse('1234567890123456789099999999'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "bigintDefaultStr", then the field value should match the provided value',
        () {
          var bigInt = BigInt.one;
          ;
          var object = BigIntDefault(
            bigintDefaultStr: bigInt,
          );
          expect(
            object.bigintDefaultStr,
            bigInt,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "bigintDefaultStrNull", then the field value should match the provided value',
        () {
          var bigInt = BigInt.one;
          var object = BigIntDefault(
            bigintDefaultStrNull: bigInt,
          );
          expect(
            object.bigintDefaultStrNull,
            bigInt,
          );
        },
      );
    },
  );
}
