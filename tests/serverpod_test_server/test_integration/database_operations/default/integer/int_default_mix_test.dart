import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default fields,', () {
    tearDownAll(
      () async => IntDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "intDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${IntDefaultMix.t.tableName}" ("intDefaultAndDefaultModel", "intDefaultAndDefaultPersist", "intDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await IntDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.intDefaultAndDefaultModel, 10);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "intDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${IntDefaultMix.t.tableName}" ("intDefaultAndDefaultModel", "intDefaultAndDefaultPersist", "intDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await IntDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.intDefaultAndDefaultPersist, 20);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "intDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${IntDefaultMix.t.tableName}" ("intDefaultAndDefaultModel", "intDefaultAndDefaultPersist", "intDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await IntDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.intDefaultModelAndDefaultPersist, 20);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "intDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var specificObject = IntDefaultMix(
          intDefaultAndDefaultModel: 30,
        );
        var specificDatabaseObject = await IntDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.intDefaultAndDefaultModel, 30);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "intDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = IntDefaultMix(
          intDefaultAndDefaultPersist: 40,
        );
        var specificDatabaseObject = await IntDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.intDefaultAndDefaultPersist, 40);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "intDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = IntDefaultMix(
          intDefaultModelAndDefaultPersist: 50,
        );
        var specificDatabaseObject = await IntDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.intDefaultModelAndDefaultPersist, 50);
      },
    );
  });
}
