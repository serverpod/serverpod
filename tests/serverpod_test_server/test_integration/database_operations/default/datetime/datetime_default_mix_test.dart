import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  group('Given a class with mixed default fields,', () {
    tearDownAll(
      () async => DateTimeDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "dateTimeDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DateTimeDefaultMix.t.tableName}" ("dateTimeDefaultAndDefaultModel", "dateTimeDefaultAndDefaultPersist", "dateTimeDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DateTimeDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.dateTimeDefaultAndDefaultModel,
          DateTime.parse('2024-05-01T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "dateTimeDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DateTimeDefaultMix.t.tableName}" ("dateTimeDefaultAndDefaultModel", "dateTimeDefaultAndDefaultPersist", "dateTimeDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DateTimeDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.dateTimeDefaultAndDefaultPersist,
          DateTime.parse('2024-05-10T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "dateTimeDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DateTimeDefaultMix.t.tableName}" ("dateTimeDefaultAndDefaultModel", "dateTimeDefaultAndDefaultPersist", "dateTimeDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DateTimeDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.dateTimeDefaultModelAndDefaultPersist,
          DateTime.parse('2024-05-10T22:00:00.000Z'),
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "dateTimeDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-10T22:00:00.000Z');
        var specificObject = DateTimeDefaultMix(
          dateTimeDefaultAndDefaultModel: date,
        );
        var specificDatabaseObject = await DateTimeDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultAndDefaultModel,
          date,
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "dateTimeDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-10T22:00:00.000Z');
        var specificObject = DateTimeDefaultMix(
          dateTimeDefaultAndDefaultPersist: date,
        );
        var specificDatabaseObject = await DateTimeDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultAndDefaultPersist,
          date,
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "dateTimeDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var date = DateTime.parse('2024-05-10T22:00:00.000Z');
        var specificObject = DateTimeDefaultMix(
          dateTimeDefaultModelAndDefaultPersist: date,
        );
        var specificDatabaseObject = await DateTimeDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.dateTimeDefaultModelAndDefaultPersist,
          date,
        );
      },
    );
  });
}
