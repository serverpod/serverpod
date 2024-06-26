import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'default' fields",
    () {
      test(
        'when an object of the class is created, then, except for "default=now", all fields should be in UTC',
        () {
          var object = DateTimeDefault();
          expect(object.dateTimeDefaultNow.isUtc, false);
          expect(object.dateTimeDefaultStr.isUtc, true);
          expect(object.dateTimeDefaultStrNull?.isUtc, true);
        },
      );

      test(
        'when an object of the class is created, then all fields value should match the defaults',
        () {
          var object = DateTimeDefault();

          expect(
            object.dateTimeDefaultNow.difference(DateTime.now()).inSeconds,
            0,
          );

          expect(
            object.dateTimeDefaultStr,
            DateTime.parse('2024-05-34T22:00:00.000Z'),
          );

          expect(
            object.dateTimeDefaultStrNull,
            DateTime.parse('2024-05-34T22:00:00.000Z'),
          );
        },
      );
    },
  );

  group(
    "Given a class with 'defaultModel' fields",
    () {
      test(
        'when an object of the class is created, then, except for "defaultModel=now", all fields should be in UTC',
        () {
          var object = DateTimeDefaultModel();
          expect(object.dateTimeDefaultModelNow.isUtc, false);
          expect(object.dateTimeDefaultModelStr.isUtc, true);
          expect(object.dateTimeDefaultModelStrNull?.isUtc, true);
        },
      );

      test(
        'when an object of the class is created, then all fields value should match the defaults',
        () {
          var object = DateTimeDefaultModel();
          expect(
            object.dateTimeDefaultModelNow.difference(DateTime.now()).inSeconds,
            0,
          );

          expect(
            object.dateTimeDefaultModelStr,
            DateTime.parse("2024-05-34T22:00:00.000Z"),
          );

          expect(
            object.dateTimeDefaultModelStrNull,
            DateTime.parse("2024-05-34T22:00:00.000Z"),
          );
        },
      );
    },
  );

  group(
    "Given a class with 'defaultDatabase' fields",
    () {
      test(
        'when an object of the class is created, then all fields should be null',
        () {
          var object = DateTimeDefaultDatabase();
          expect(object.dateTimeDefaultDatabaseNow, isNull);
          expect(object.dateTimeDefaultDatabaseStr, isNull);
        },
      );
    },
  );

  group(
    "Given a class with mix fields defaults",
    () {
      test(
        'when the field has "default" and "defaultModel", then the field value should be the "defaultModel" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultAndDefaultModel,
            DateTime.parse('2024-05-10T22:00:00.000Z'),
          );
        },
      );

      test(
        'when the field has "default" and "defaultDatabase", then the field value should be the "default" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultAndDefaultDatabase,
            DateTime.parse('2024-05-01T22:00:00.000Z'),
          );
        },
      );

      test(
        'when the field has "defaultModel" and "defaultDatabase", then the field value should be the "defaultModel" value',
        () {
          var object = DateTimeDefaultMix();
          expect(
            object.dateTimeDefaultModelAndDefaultDatabase,
            DateTime.parse('2024-05-01T22:00:00.000Z'),
          );
        },
      );
    },
  );
}
