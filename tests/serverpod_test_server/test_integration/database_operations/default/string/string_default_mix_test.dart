import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default fields,', () {
    tearDownAll(
      () async => StringDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${StringDefaultMix.t.tableName}" ("stringDefaultAndDefaultModel", "stringDefaultAndDefaultPersist", "stringDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.stringDefaultAndDefaultModel,
          'This is a default value',
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${StringDefaultMix.t.tableName}" ("stringDefaultAndDefaultModel", "stringDefaultAndDefaultPersist", "stringDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.stringDefaultAndDefaultPersist,
          'This is a default persist value',
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${StringDefaultMix.t.tableName}" ("stringDefaultAndDefaultModel", "stringDefaultAndDefaultPersist", "stringDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.stringDefaultModelAndDefaultPersist,
          'This is a default persist value',
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "stringDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var specificObject = StringDefaultMix(
          stringDefaultAndDefaultModel: 'A specific default model value',
        );
        var specificDatabaseObject = await StringDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultAndDefaultModel,
          'A specific default model value',
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "stringDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = StringDefaultMix(
          stringDefaultAndDefaultPersist: 'A specific default persist value',
        );
        var specificDatabaseObject = await StringDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultAndDefaultPersist,
          'A specific default persist value',
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "stringDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = StringDefaultMix(
          stringDefaultModelAndDefaultPersist:
              'A specific default model and persist value',
        );
        var specificDatabaseObject = await StringDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultModelAndDefaultPersist,
          'A specific default model and persist value',
        );
      },
    );
  });
}
