import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then the "defaultModel=now" field should not be in UTC',
        () {
          var object = DateTimeDefaultModel();
          expect(object.dateTimeDefaultModelNow.isUtc, isFalse);
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel" field with UTC string should be in UTC',
        () {
          var object = DateTimeDefaultModel();
          expect(object.dateTimeDefaultModelStr.isUtc, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel" field with UTC string should be in UTC',
        () {
          var object = DateTimeDefaultModel();
          expect(object.dateTimeDefaultModelStrNull?.isUtc, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel=now" field value should match the current time',
        () {
          var object = DateTimeDefaultModel();
          expect(
            object.dateTimeDefaultModelNow.difference(DateTime.now()).inSeconds,
            0,
          );
        },
      );

      test(
        'when an object of the class is created, then the "defaultModel" field value should match the default',
        () {
          var object = DateTimeDefaultModel();
          expect(
            object.dateTimeDefaultModelStr,
            DateTime.parse("2024-05-24T22:00:00.000Z"),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "defaultModel" field value should match the default',
        () {
          var object = DateTimeDefaultModel();
          expect(
            object.dateTimeDefaultModelStrNull,
            DateTime.parse("2024-05-24T22:00:00.000Z"),
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "dateTimeDefaultModelNow", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-01T22:00:00.000Z');
          var object = DateTimeDefaultModel(
            dateTimeDefaultModelNow: date,
          );
          expect(
            object.dateTimeDefaultModelNow,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "dateTimeDefaultModelStr", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefaultModel(
            dateTimeDefaultModelStr: date,
          );
          expect(
            object.dateTimeDefaultModelStr,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a specific value for "dateTimeDefaultModelStrNull", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefaultModel(
            dateTimeDefaultModelStrNull: date,
          );
          expect(
            object.dateTimeDefaultModelStrNull,
            date,
          );
        },
      );
    },
  );
}
