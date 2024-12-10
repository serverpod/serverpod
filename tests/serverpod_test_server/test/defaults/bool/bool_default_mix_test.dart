import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = BoolDefaultMix();
          expect(object.boolDefaultAndDefaultModel, isFalse);
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = BoolDefaultMix();
          expect(object.boolDefaultAndDefaultPersist, isTrue);
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = BoolDefaultMix();
          expect(object.boolDefaultModelAndDefaultPersist, isTrue);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var object = BoolDefaultMix(boolDefaultAndDefaultModel: true);
          expect(object.boolDefaultAndDefaultModel, isTrue);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = BoolDefaultMix(boolDefaultAndDefaultPersist: false);
          expect(object.boolDefaultAndDefaultPersist, isFalse);
        },
      );

      test(
        'when an object of the class is created with a value for "boolDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = BoolDefaultMix(boolDefaultModelAndDefaultPersist: false);
          expect(object.boolDefaultModelAndDefaultPersist, isFalse);
        },
      );
    },
  );
}
