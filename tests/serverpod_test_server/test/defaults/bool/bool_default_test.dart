import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then the "boolDefaultTrue" field should be true',
        () {
          var object = BoolDefault();
          expect(object.boolDefaultTrue, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the "boolDefaultFalse" field should be false',
        () {
          var object = BoolDefault();
          expect(object.boolDefaultFalse, isFalse);
        },
      );

      test(
        'when an object of the class is created, then the "boolDefaultNullFalse" field should be false',
        () {
          var object = BoolDefault();
          expect(object.boolDefaultNullFalse, isFalse);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultTrue", then the field value should match the provided value',
        () {
          var object = BoolDefault(boolDefaultTrue: false);
          expect(object.boolDefaultTrue, isFalse);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultFalse", then the field value should match the provided value',
        () {
          var object = BoolDefault(boolDefaultFalse: true);
          expect(object.boolDefaultFalse, isTrue);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultNullFalse", then the field value should match the provided value',
        () {
          var object = BoolDefault(boolDefaultNullFalse: true);
          expect(object.boolDefaultNullFalse, isTrue);
        },
      );
    },
  );
}
