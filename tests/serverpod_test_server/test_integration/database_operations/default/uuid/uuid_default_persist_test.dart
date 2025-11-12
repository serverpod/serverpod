import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" UUID fields,', () {
    tearDownAll(
      () async => UuidDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=random" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefaultPersist();
        var databaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultPersistRandom, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultPersistRandom.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultPersist=random_v7" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefaultPersist();
        var databaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultPersistRandomV7, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultPersistRandomV7.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultPersist" UUID field with a string should match the default',
      () async {
        var object = UuidDefaultPersist();
        var databaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.uuidDefaultPersistStr,
          UuidValue.fromString("550e8400-e29b-41d4-a716-446655440000"),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=random" UUID field should generate a valid UUID',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${UuidDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.uuidDefaultPersistRandom, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject!.uuidDefaultPersistRandom.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=random_v7" UUID field should generate a valid UUID',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${UuidDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultPersist.db.findFirstRow(session);
        expect(databaseObject?.uuidDefaultPersistRandomV7, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject!.uuidDefaultPersistRandomV7.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist" UUID field with a string should match the default',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${UuidDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultPersist.db.findFirstRow(session);
        expect(
          databaseObject!.uuidDefaultPersistStr,
          UuidValue.fromString("550e8400-e29b-41d4-a716-446655440000"),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultPersistRandom" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefaultPersist(
          uuidDefaultPersistRandom: uuid,
        );
        var specificDatabaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultPersistRandom,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultPersistRandomV7" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefaultPersist(
          uuidDefaultPersistRandomV7: uuid,
        );
        var specificDatabaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultPersistRandomV7,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultPersistStr" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultPersist(
          uuidDefaultPersistStr: uuid,
        );
        var specificDatabaseObject = await UuidDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultPersistStr,
          uuid,
        );
      },
    );
  });
}
