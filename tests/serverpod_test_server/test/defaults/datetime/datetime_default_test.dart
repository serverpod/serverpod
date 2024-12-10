import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then the "default=now" field should not be in UTC',
        () {
          var object = DateTimeDefault();
          expect(object.dateTimeDefaultNow.isUtc, isFalse);
        },
      );

      test(
        'when an object of the class is created, then the "default" field with UTC string should be in UTC',
        () {
          var object = DateTimeDefault();
          expect(object.dateTimeDefaultStr.isUtc, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the nullable "default" field with UTC string should be in UTC',
        () {
          var object = DateTimeDefault();
          expect(object.dateTimeDefaultStrNull?.isUtc, isTrue);
        },
      );

      test(
        'when an object of the class is created, then the "default=now" field value should match the current time',
        () {
          var object = DateTimeDefault();
          expect(
            object.dateTimeDefaultNow.difference(DateTime.now()).inSeconds,
            0,
          );
        },
      );

      test(
        'when an object of the class is created, then the "default" field value should match the default',
        () {
          var object = DateTimeDefault();
          expect(
            object.dateTimeDefaultStr,
            DateTime.parse('2024-05-24T22:00:00.000Z'),
          );
        },
      );

      test(
        'when an object of the class is created, then the nullable "default" field value should match the default',
        () {
          var object = DateTimeDefault();
          expect(
            object.dateTimeDefaultStrNull,
            DateTime.parse('2024-05-24T22:00:00.000Z'),
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultNow", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefault(
            dateTimeDefaultNow: date,
          );
          expect(
            object.dateTimeDefaultNow,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultStr", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefault(
            dateTimeDefaultStr: date,
          );
          expect(
            object.dateTimeDefaultStr,
            date,
          );
        },
      );

      test(
        'when an object of the class is created with a value for "dateTimeDefaultStrNull", then the field value should match the provided value',
        () {
          var date = DateTime.parse('2024-05-05T22:00:00.000Z');
          var object = DateTimeDefault(
            dateTimeDefaultStrNull: date,
          );
          expect(
            object.dateTimeDefaultStrNull,
            date,
          );
        },
      );
    },
  );
}
