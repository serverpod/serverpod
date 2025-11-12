import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default UUID fields,', () {
    tearDownAll(
      () async => UuidDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "uuidDefaultAndDefaultPersist" field value should match the defaultModel value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${UuidDefaultMix.t.tableName}" ("uuidDefaultAndDefaultModel", "uuidDefaultAndDefaultPersist", "uuidDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.uuidDefaultAndDefaultModel,
          UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "uuidDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${UuidDefaultMix.t.tableName}" ("uuidDefaultAndDefaultModel", "uuidDefaultAndDefaultPersist", "uuidDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.uuidDefaultAndDefaultPersist,
          UuidValue.fromString('9e107d9d-372b-4d97-9b27-2f0907d0b1d4'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "uuidDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${UuidDefaultMix.t.tableName}" ("uuidDefaultAndDefaultModel", "uuidDefaultAndDefaultPersist", "uuidDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await UuidDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.uuidDefaultModelAndDefaultPersist,
          UuidValue.fromString('f47ac10b-58cc-4372-a567-0e02b2c3d479'),
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "uuidDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultMix(
          uuidDefaultAndDefaultModel: uuid,
        );
        var specificDatabaseObject = await UuidDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultAndDefaultModel,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "uuidDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultMix(
          uuidDefaultAndDefaultPersist: uuid,
        );
        var specificDatabaseObject = await UuidDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultAndDefaultPersist,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "uuidDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultMix(
          uuidDefaultModelAndDefaultPersist: uuid,
        );
        var specificDatabaseObject = await UuidDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultModelAndDefaultPersist,
          uuid,
        );
      },
    );
  });
}
