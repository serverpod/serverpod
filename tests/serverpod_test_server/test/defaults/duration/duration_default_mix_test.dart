import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = DurationDefaultMix();
          expect(
            object.durationDefaultAndDefaultModel,
            equals(
              Duration(
                days: 2,
                hours: 1,
                minutes: 20,
                seconds: 40,
                milliseconds: 100,
              ),
            ),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = DurationDefaultMix();
          expect(
            object.durationDefaultAndDefaultPersist,
            equals(
              Duration(
                days: 1,
                hours: 2,
                minutes: 10,
                seconds: 30,
                milliseconds: 100,
              ),
            ),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = DurationDefaultMix();
          expect(
            object.durationDefaultModelAndDefaultPersist,
            equals(
              Duration(
                days: 1,
                hours: 2,
                minutes: 10,
                seconds: 30,
                milliseconds: 100,
              ),
            ),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "durationDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 4,
            minutes: 15,
            seconds: 45,
            milliseconds: 500,
          );
          var object = DurationDefaultMix(
            durationDefaultAndDefaultModel: duration,
          );
          expect(
            object.durationDefaultAndDefaultModel,
            equals(duration),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "durationDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 5,
            minutes: 25,
            seconds: 50,
            milliseconds: 600,
          );
          var object = DurationDefaultMix(
            durationDefaultAndDefaultPersist: duration,
          );
          expect(
            object.durationDefaultAndDefaultPersist,
            equals(duration),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "durationDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 4,
            hours: 6,
            minutes: 30,
            seconds: 55,
            milliseconds: 700,
          );
          var object = DurationDefaultMix(
            durationDefaultModelAndDefaultPersist: duration,
          );
          expect(
            object.durationDefaultModelAndDefaultPersist,
            equals(duration),
          );
        },
      );
    },
  );
}
