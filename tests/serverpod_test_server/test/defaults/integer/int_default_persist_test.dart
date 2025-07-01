import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' fields",
    () {
      test(
        'when an object of the class is created, then the "intDefaultPersist" field should be null',
        () {
          var object = IntDefaultPersist();
          expect(object.intDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "intDefaultPersist", then the field value should match the provided value',
        () {
          var object = IntDefaultPersist(intDefaultPersist: 15);
          expect(object.intDefaultPersist, equals(15));
        },
      );
    },
  );
}
