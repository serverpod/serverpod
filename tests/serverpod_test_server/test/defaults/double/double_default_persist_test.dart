import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' fields",
    () {
      test(
        'when an object of the class is created, then the "doubleDefaultPersist" field should be null',
        () {
          var object = DoubleDefaultPersist();
          expect(object.doubleDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "doubleDefaultPersist", then the field value should match the provided value',
        () {
          var object = DoubleDefaultPersist(doubleDefaultPersist: 15.5);
          expect(object.doubleDefaultPersist, equals(15.5));
        },
      );
    },
  );
}
