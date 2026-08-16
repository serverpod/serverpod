import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(
      () async => IntDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=10" field should be 10',
      () async {
        var object = IntDefaultPersist();
        var databaseObject = await IntDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.intDefaultPersist, equals(10));
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=10" field should be 10',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${IntDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject = await IntDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.intDefaultPersist, equals(10));
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "intDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = IntDefaultPersist(
          intDefaultPersist: 20,
        );
        var specificDatabaseObject = await IntDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.intDefaultPersist, equals(20));
      },
    );
  });
}
