import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then the "doubleDefault" field should match the default value',
        () {
          var object = DoubleDefault();
          expect(object.doubleDefault, equals(10.5));
        },
      );

      test(
        'when an object of the class is created, then the "doubleDefaultNull" field should match the default value',
        () {
          var object = DoubleDefault();
          expect(object.doubleDefaultNull, equals(20.5));
        },
      );

      test(
        'when an object of the class is created with a specific value for "doubleDefault", then the field value should match the provided value',
        () {
          var object = DoubleDefault(doubleDefault: 15.5);
          expect(object.doubleDefault, equals(15.5));
        },
      );

      test(
        'when an object of the class is created with a specific value for "doubleDefaultNull", then the field value should match the provided value',
        () {
          var object = DoubleDefault(doubleDefaultNull: 25.5);
          expect(object.doubleDefaultNull, equals(25.5));
        },
      );
    },
  );
}
