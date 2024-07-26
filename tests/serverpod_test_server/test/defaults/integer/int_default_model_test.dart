import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then the "intDefaultModel" field should match the default value',
        () {
          var object = IntDefaultModel();
          expect(object.intDefaultModel, equals(10));
        },
      );

      test(
        'when an object of the class is created, then the "intDefaultModelNull" field should match the default value',
        () {
          var object = IntDefaultModel();
          expect(object.intDefaultModelNull, equals(20));
        },
      );

      test(
        'when an object of the class is created with a specific value for "intDefaultModel", then the field value should match the provided value',
        () {
          var object = IntDefaultModel(intDefaultModel: 15);
          expect(object.intDefaultModel, equals(15));
        },
      );

      test(
        'when an object of the class is created with a specific value for "intDefaultModelNull", then the field value should match the provided value',
        () {
          var object = IntDefaultModel(intDefaultModelNull: 25);
          expect(object.intDefaultModelNull, equals(25));
        },
      );
    },
  );
}
