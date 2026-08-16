import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(
      () async => BoolDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=true" field should be true',
      () async {
        var object = BoolDefaultPersist();
        var databaseObject = await BoolDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.boolDefaultPersistTrue, isTrue);
      },
    );

    test(
      'when creating a record in the database, then the "defaultPersist=false" field should be false',
      () async {
        var object = BoolDefaultPersist();
        var databaseObject = await BoolDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.boolDefaultPersistFalse, isFalse);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=true" field should be true',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${BoolDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await BoolDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.boolDefaultPersistTrue, isTrue);
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=false" field should be false',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${BoolDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await BoolDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.boolDefaultPersistFalse, isFalse);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultPersistTrue" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultPersist(
          boolDefaultPersistTrue: false,
        );
        var specificDatabaseObject = await BoolDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultPersistTrue, isFalse);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultPersistFalse" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultPersist(
          boolDefaultPersistFalse: true,
        );
        var specificDatabaseObject = await BoolDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultPersistFalse, isTrue);
      },
    );
  });
}
