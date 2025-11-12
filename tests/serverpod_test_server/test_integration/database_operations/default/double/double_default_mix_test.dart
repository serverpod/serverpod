import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default fields,', () {
    tearDownAll(
      () async => DoubleDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "doubleDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DoubleDefaultMix.t.tableName}" ("doubleDefaultAndDefaultModel", "doubleDefaultAndDefaultPersist", "doubleDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DoubleDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.doubleDefaultAndDefaultModel, 10.5);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "doubleDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DoubleDefaultMix.t.tableName}" ("doubleDefaultAndDefaultModel", "doubleDefaultAndDefaultPersist", "doubleDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DoubleDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.doubleDefaultAndDefaultPersist, 20.5);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "doubleDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${DoubleDefaultMix.t.tableName}" ("doubleDefaultAndDefaultModel", "doubleDefaultAndDefaultPersist", "doubleDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await DoubleDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.doubleDefaultModelAndDefaultPersist, 20.5);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "doubleDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var specificObject = DoubleDefaultMix(
          doubleDefaultAndDefaultModel: 30.5,
        );
        var specificDatabaseObject = await DoubleDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.doubleDefaultAndDefaultModel, 30.5);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "doubleDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = DoubleDefaultMix(
          doubleDefaultAndDefaultPersist: 40.5,
        );
        var specificDatabaseObject = await DoubleDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.doubleDefaultAndDefaultPersist, 40.5);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "doubleDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = DoubleDefaultMix(
          doubleDefaultModelAndDefaultPersist: 50.5,
        );
        var specificDatabaseObject = await DoubleDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.doubleDefaultModelAndDefaultPersist,
          50.5,
        );
      },
    );
  });
}
