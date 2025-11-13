import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" UUID fields,', () {
    tearDownAll(
      () async => UuidDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=random" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefault();
        var databaseObject = await UuidDefault.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultRandom, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultRandom.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "default=random_v7" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefault();
        var databaseObject = await UuidDefault.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultRandomV7, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultRandomV7.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "default" UUID field with a string should match the default',
      () async {
        var object = UuidDefault();
        var databaseObject = await UuidDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.uuidDefaultStr,
          UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default" UUID field with a string should match the default',
      () async {
        var object = UuidDefault();
        var databaseObject = await UuidDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.uuidDefaultStrNull,
          UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultRandom" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefault(
          uuidDefaultRandom: uuid,
        );
        var specificDatabaseObject = await UuidDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultRandom,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultRandomV7" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefault(
          uuidDefaultRandomV7: uuid,
        );
        var specificDatabaseObject = await UuidDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultRandomV7,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultStr" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefault(
          uuidDefaultStr: uuid,
        );
        var specificDatabaseObject = await UuidDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultStr,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultStrNull" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefault(
          uuidDefaultStrNull: uuid,
        );
        var specificDatabaseObject = await UuidDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultStrNull,
          uuid,
        );
      },
    );
  });
}
