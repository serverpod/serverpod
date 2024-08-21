import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' Duration fields",
    () {
      test(
        'when an object of the class is created, then the "durationDefault" field should match the default value',
        () {
          var object = DurationDefault();
          var expectedDuration = Duration(
            days: 1,
            hours: 2,
            minutes: 10,
            seconds: 30,
            milliseconds: 100,
          );
          expect(object.durationDefault, equals(expectedDuration));
        },
      );

      test(
        'when an object of the class is created, then the "durationDefaultNull" field should match the default value',
        () {
          var object = DurationDefault();
          var expectedDuration = Duration(
            days: 2,
            hours: 1,
            minutes: 20,
            seconds: 40,
            milliseconds: 100,
          );
          expect(object.durationDefaultNull, equals(expectedDuration));
        },
      );

      test(
        'when an object of the class is created with a specific value for "durationDefault", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 4,
            minutes: 15,
            seconds: 45,
            milliseconds: 500,
          );
          var object = DurationDefault(durationDefault: duration);
          expect(object.durationDefault, equals(duration));
        },
      );

      test(
        'when an object of the class is created with a specific value for "durationDefaultNull", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 5,
            minutes: 25,
            seconds: 50,
            milliseconds: 600,
          );
          var object = DurationDefault(durationDefaultNull: duration);
          expect(object.durationDefaultNull, equals(duration));
        },
      );
    },
  );
}
