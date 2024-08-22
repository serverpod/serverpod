import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' Duration fields",
    () {
      test(
        'when an object of the class is created, then the "durationDefaultPersist" field should be null',
        () {
          var object = DurationDefaultPersist();
          expect(object.durationDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "durationDefaultPersist", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 4,
            minutes: 15,
            seconds: 45,
            milliseconds: 500,
          );
          var object = DurationDefaultPersist(durationDefaultPersist: duration);
          expect(object.durationDefaultPersist, equals(duration));
        },
      );
    },
  );
}
