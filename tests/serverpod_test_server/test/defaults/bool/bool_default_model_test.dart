import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then the "boolDefaultModelTrue" field should be true',
        () {
          var object = BoolDefaultModel();
          expect(object.boolDefaultModelTrue, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the "boolDefaultModelFalse" field should be false',
        () {
          var object = BoolDefaultModel();
          expect(object.boolDefaultModelFalse, isFalse);
        },
      );

      test(
        'when an object of the class is created, then the "boolDefaultModelNullFalse" field should be false',
        () {
          var object = BoolDefaultModel();
          expect(object.boolDefaultModelNullFalse, isFalse);
        },
      );

      test(
        'when an object of the class is created with a specific value for "boolDefaultModelTrue", then the field value should match the provided value',
        () {
          var object = BoolDefaultModel(boolDefaultModelTrue: false);
          expect(object.boolDefaultModelTrue, isFalse);
        },
      );

      test(
        'when an object of the class is created with a specific value for "boolDefaultModelFalse", then the field value should match the provided value',
        () {
          var object = BoolDefaultModel(boolDefaultModelFalse: true);
          expect(object.boolDefaultModelFalse, isTrue);
        },
      );

      test(
        'when an object of the class is created with a specific value for "boolDefaultModelNullFalse", then the field value should match the provided value',
        () {
          var object = BoolDefaultModel(boolDefaultModelNullFalse: true);
          expect(object.boolDefaultModelNullFalse, isTrue);
        },
      );
    },
  );
}
