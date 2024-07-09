import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with mixed fields defaults",
    () {
      test(
        'when the field has both "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultAndDefaultModel,
            DateTime.parse('2024-05-10T22:00:00.000Z'),
          );
        },
      );

      test(
        'when the field has both "default" and "defaultPersist", then the field value should be the "default" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultAndDefaultPersist,
            DateTime.parse('2024-05-01T22:00:00.000Z'),
          );
        },
      );

      test(
        'when the field has both "defaultModel" and "defaultPersist", then the field value should be the "defaultModel" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultModelAndDefaultPersist,
            DateTime.parse('2024-05-01T22:00:00.000Z'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultAndDefaultModel", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefaultMix(
            dateTimeDefaultAndDefaultModel: date,
          );
          expect(
            object.dateTimeDefaultAndDefaultModel,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultAndDefaultPersist", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefaultMix(
            dateTimeDefaultAndDefaultPersist: date,
          );
          expect(
            object.dateTimeDefaultAndDefaultPersist,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultModelAndDefaultPersist", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefaultMix(
            dateTimeDefaultModelAndDefaultPersist: date,
          );
          expect(
            object.dateTimeDefaultModelAndDefaultPersist,
            date,
          );
        },
      );
    },
  );
}
