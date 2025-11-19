import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = DoubleDefaultMix();
          expect(object.doubleDefaultAndDefaultModel, equals(20.5));
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = DoubleDefaultMix();
          expect(object.doubleDefaultAndDefaultPersist, equals(10.5));
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = DoubleDefaultMix();
          expect(object.doubleDefaultModelAndDefaultPersist, equals(10.5));
        },
      );

      test(
        'when an object of the class is created with a value for "doubleDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var object = DoubleDefaultMix(doubleDefaultAndDefaultModel: 15.5);
          expect(object.doubleDefaultAndDefaultModel, equals(15.5));
        },
      );

      test(
        'when an object of the class is created with a value for "doubleDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = DoubleDefaultMix(doubleDefaultAndDefaultPersist: 25.5);
          expect(object.doubleDefaultAndDefaultPersist, equals(25.5));
        },
      );

      test(
        'when an object of the class is created with a value for "doubleDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = DoubleDefaultMix(
            doubleDefaultModelAndDefaultPersist: 30.5,
          );
          expect(object.doubleDefaultModelAndDefaultPersist, equals(30.5));
        },
      );
    },
  );
}
