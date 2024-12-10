import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' fields",
    () {
      test(
        'when an object of the class is created, then the "stringDefaultPersist" field should be null',
        () {
          var object = StringDefaultPersist();
          expect(object.stringDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersist", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
            stringDefaultPersist: 'A specific value',
          );
          expect(
            object.stringDefaultPersist,
            equals('A specific value'),
          );
        },
      );
    },
  );
}
