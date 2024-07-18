import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(() async => StringDefaultPersist.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    test(
      'when creating a record in the database, then the "defaultPersist=\'This is a default persist value\'" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.stringDefaultPersist,
            equals('This is a default persist value'));
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=\'This is a default persist value\'" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject =
            await StringDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.stringDefaultPersist,
            equals('This is a default persist value'));
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersist: 'A specific persist value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.stringDefaultPersist,
            equals('A specific persist value'));
      },
    );
  });
}
