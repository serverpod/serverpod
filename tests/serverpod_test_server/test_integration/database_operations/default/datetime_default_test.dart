import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" fields,', () {
    tearDownAll(() async => DateTimeDefault.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    test(
      'when creating a record in the database, then the "default=now" field should be in UTC',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultNow.isUtc, true);
      },
    );

    test(
      'when creating a record in the database, then the "default" field with UTC string should be in UTC',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultStr.isUtc, true);
      },
    );

    test(
      'when creating a record in the database, then the nullable "default" field with UTC string should be in UTC',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultStrNull?.isUtc, true);
      },
    );

    test(
      'when creating a record in the database, then the "default=now" field value should match the current time',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultNow
              .difference(DateTime.now())
              .inSeconds,
          0,
        );
      },
    );

    test(
      'when creating a record in the database, then the "default" field value should match the default',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultStr,
          DateTime.parse('2024-05-24T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default" field value should match the default',
      () async {
        var object = DateTimeDefault();
        var databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultStrNull,
          DateTime.parse('2024-05-24T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultNow" field value should match the provided value',
      () async {
        var specificObject = DateTimeDefault(
          dateTimeDefaultNow: DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
        var specificDatabaseObject = await DateTimeDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultNow,
          DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultStr" field value should match the provided value',
      () async {
        var specificObject = DateTimeDefault(
          dateTimeDefaultStr: DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
        var specificDatabaseObject = await DateTimeDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultStr,
          DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultStrNull" field value should match the provided value',
      () async {
        var specificObject = DateTimeDefault(
          dateTimeDefaultStrNull: DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
        var specificDatabaseObject = await DateTimeDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultStrNull,
          DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
      },
    );
  });
}
