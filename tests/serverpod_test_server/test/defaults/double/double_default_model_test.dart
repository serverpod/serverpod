import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then the "doubleDefaultModel" field should match the default value',
        () {
          var object = DoubleDefaultModel();
          expect(object.doubleDefaultModel, equals(10.5));
        },
      );

      test(
        'when an object of the class is created, then the "doubleDefaultModelNull" field should match the default value',
        () {
          var object = DoubleDefaultModel();
          expect(object.doubleDefaultModelNull, equals(20.5));
        },
      );

      test(
        'when an object of the class is created with a specific value for "doubleDefaultModel", then the field value should match the provided value',
        () {
          var object = DoubleDefaultModel(doubleDefaultModel: 15.5);
          expect(object.doubleDefaultModel, equals(15.5));
        },
      );

      test(
        'when an object of the class is created with a specific value for "doubleDefaultModelNull", then the field value should match the provided value',
        () {
          var object = DoubleDefaultModel(doubleDefaultModelNull: 25.5);
          expect(object.doubleDefaultModelNull, equals(25.5));
        },
      );
    },
  );
}
