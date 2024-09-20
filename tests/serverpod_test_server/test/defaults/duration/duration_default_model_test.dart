import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' Duration fields",
    () {
      test(
        'when an object of the class is created, then the "durationDefaultModel" field should match the default value',
        () {
          var object = DurationDefaultModel();
          var expectedDuration = Duration(
            days: 1,
            hours: 2,
            minutes: 10,
            seconds: 30,
            milliseconds: 100,
          );
          expect(object.durationDefaultModel, equals(expectedDuration));
        },
      );

      test(
        'when an object of the class is created, then the "durationDefaultModelNull" field should match the default value',
        () {
          var object = DurationDefaultModel();
          var expectedDuration = Duration(
            days: 2,
            hours: 1,
            minutes: 20,
            seconds: 40,
            milliseconds: 100,
          );
          expect(object.durationDefaultModelNull, equals(expectedDuration));
        },
      );

      test(
        'when an object of the class is created with a specific value for "durationDefaultModel", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 4,
            minutes: 15,
            seconds: 45,
            milliseconds: 500,
          );
          var object = DurationDefaultModel(durationDefaultModel: duration);
          expect(object.durationDefaultModel, equals(duration));
        },
      );

      test(
        'when an object of the class is created with a specific value for "durationDefaultModelNull", then the field value should match the provided value',
        () {
          var duration = Duration(
            days: 3,
            hours: 5,
            minutes: 25,
            seconds: 50,
            milliseconds: 600,
          );
          var object = DurationDefaultModel(durationDefaultModelNull: duration);
          expect(object.durationDefaultModelNull, equals(duration));
        },
      );
    },
  );
}
