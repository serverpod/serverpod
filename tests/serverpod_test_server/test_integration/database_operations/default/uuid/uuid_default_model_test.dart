import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultModel" UUID fields,', () {
    tearDownAll(
      () async => UuidDefaultModel.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultModel=random" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefaultModel();
        var databaseObject = await UuidDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultModelRandom, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultModelRandom.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel=random_v7" UUID field should not be null and should generate a valid UUID',
      () async {
        var object = UuidDefaultModel();
        var databaseObject = await UuidDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.uuidDefaultModelRandomV7, isNotNull);
        expect(
          RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          ).hasMatch(databaseObject.uuidDefaultModelRandomV7.toString()),
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel" UUID field with a string should match the default',
      () async {
        var object = UuidDefaultModel();
        var databaseObject = await UuidDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.uuidDefaultModelStr,
          UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel" UUID field with a string should match the default',
      () async {
        var object = UuidDefaultModel();
        var databaseObject = await UuidDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.uuidDefaultModelStrNull,
          UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultModelRandom" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefaultModel(
          uuidDefaultModelRandom: uuid,
        );
        var specificDatabaseObject = await UuidDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultModelRandom,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultModelRandomV7" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');
        var specificObject = UuidDefaultModel(
          uuidDefaultModelRandomV7: uuid,
        );
        var specificDatabaseObject = await UuidDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultModelRandomV7,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultModelStr" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultModel(
          uuidDefaultModelStr: uuid,
        );
        var specificDatabaseObject = await UuidDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultModelStr,
          uuid,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "uuidDefaultModelStrNull" field value should match the provided value',
      () async {
        var uuid = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        var specificObject = UuidDefaultModel(
          uuidDefaultModelStrNull: uuid,
        );
        var specificDatabaseObject = await UuidDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.uuidDefaultModelStrNull,
          uuid,
        );
      },
    );
  });
}
