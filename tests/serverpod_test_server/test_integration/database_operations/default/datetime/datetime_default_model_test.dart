import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultModel" fields,', () {
    tearDownAll(
      () async => DateTimeDefaultModel.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultModel=now" field should be in UTC',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultModelNow.isUtc, isTrue);
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel" field with UTC string should be in UTC',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultModelStr.isUtc, isTrue);
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel" field with UTC string should be in UTC',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.dateTimeDefaultModelStrNull?.isUtc, isTrue);
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel=now" field value should match the current time',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultModelNow
              .difference(DateTime.now())
              .inSeconds,
          0,
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel" field value should match the default',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultModelStr,
          DateTime.parse('2024-05-24T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel" field value should match the default',
      () async {
        var object = DateTimeDefaultModel();
        var databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.dateTimeDefaultModelStrNull,
          DateTime.parse('2024-05-24T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultModelNow" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-05T22:00:00.000Z');
        var specificObject = DateTimeDefaultModel(
          dateTimeDefaultModelNow: date,
        );
        var specificDatabaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultModelNow,
          date,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultModelStr" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-05T22:00:00.000Z');
        var specificObject = DateTimeDefaultModel(
          dateTimeDefaultModelStr: date,
        );
        var specificDatabaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultModelStr,
          date,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "dateTimeDefaultModelStrNull" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-05T22:00:00.000Z');
        var specificObject = DateTimeDefaultModel(
          dateTimeDefaultModelStrNull: date,
        );
        var specificDatabaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultModelStrNull,
          date,
        );
      },
    );
  });
}
