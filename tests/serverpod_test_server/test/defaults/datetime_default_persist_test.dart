import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' fields",
    () {
      test(
        'when an object of the class is created, then the "defaultPersist=now" field should be null',
        () {
          var object = DateTimeDefaultPersist();
          expect(object.dateTimeDefaultPersistNow, isNull);
        },
      );

      test(
        'when an object of the class is created, then the "defaultPersist" field with UTC string should be null',
        () {
          var object = DateTimeDefaultPersist();
          expect(object.dateTimeDefaultPersistStr, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "dateTimeDefaultPersistNow", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-01T22:00:00.000Z');
          var object = DateTimeDefaultPersist(
            dateTimeDefaultPersistNow: date,
          );
          expect(
            object.dateTimeDefaultPersistNow,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "dateTimeDefaultPersistStr", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-01T22:00:00.000Z');
          var object = DateTimeDefaultPersist(
            dateTimeDefaultPersistStr: date,
          );
          expect(
            object.dateTimeDefaultPersistStr,
            date,
          );
        },
      );
    },
  );
}
