import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default fields,', () {
    tearDownAll(
      () async => BoolDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "boolDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${BoolDefaultMix.t.tableName}" ("boolDefaultAndDefaultModel", "boolDefaultAndDefaultPersist", "boolDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await BoolDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.boolDefaultAndDefaultModel, isTrue);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "boolDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${BoolDefaultMix.t.tableName}" ("boolDefaultAndDefaultModel", "boolDefaultAndDefaultPersist", "boolDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await BoolDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.boolDefaultAndDefaultPersist, isFalse);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "boolDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${BoolDefaultMix.t.tableName}" ("boolDefaultAndDefaultModel", "boolDefaultAndDefaultPersist", "boolDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await BoolDefaultMix.db.findFirstRow(session);
        expect(databaseObject?.boolDefaultModelAndDefaultPersist, isFalse);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "boolDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultMix(
          boolDefaultAndDefaultModel: false,
        );
        var specificDatabaseObject = await BoolDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultAndDefaultModel, isFalse);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "boolDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultMix(
          boolDefaultAndDefaultPersist: true,
        );
        var specificDatabaseObject = await BoolDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultAndDefaultPersist, isTrue);
      },
    );

    test(
      'when creating a record in the database with specific values, then the "boolDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultMix(
          boolDefaultModelAndDefaultPersist: false,
        );
        var specificDatabaseObject = await BoolDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.boolDefaultModelAndDefaultPersist,
          isFalse,
        );
      },
    );
  });
}
