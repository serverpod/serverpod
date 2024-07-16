import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = IntDefaultMix();
          expect(object.intDefaultAndDefaultModel, equals(20));
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = IntDefaultMix();
          expect(object.intDefaultAndDefaultPersist, equals(10));
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = IntDefaultMix();
          expect(object.intDefaultModelAndDefaultPersist, equals(10));
        },
      );

      test(
        'when an object of the class is created with a value for "intDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var object = IntDefaultMix(intDefaultAndDefaultModel: 15);
          expect(object.intDefaultAndDefaultModel, equals(15));
        },
      );

      test(
        'when an object of the class is created with a value for "intDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = IntDefaultMix(intDefaultAndDefaultPersist: 25);
          expect(object.intDefaultAndDefaultPersist, equals(25));
        },
      );

      test(
        'when an object of the class is created with a value for "intDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var object = IntDefaultMix(intDefaultModelAndDefaultPersist: 30);
          expect(object.intDefaultModelAndDefaultPersist, equals(30));
        },
      );
    },
  );
}
