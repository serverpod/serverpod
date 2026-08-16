import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" fields,', () {
    tearDownAll(
      () async => BoolDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=true" field value should be true',
      () async {
        var object = BoolDefault();
        var databaseObject = await BoolDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.boolDefaultTrue,
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database, then the "default=false" field value should be false',
      () async {
        var object = BoolDefault();
        var databaseObject = await BoolDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.boolDefaultFalse,
          isFalse,
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default=false" field value should be false',
      () async {
        var object = BoolDefault();
        var databaseObject = await BoolDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.boolDefaultNullFalse,
          isFalse,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultTrue" field value should match the provided value',
      () async {
        var specificObject = BoolDefault(
          boolDefaultTrue: false,
        );
        var specificDatabaseObject = await BoolDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.boolDefaultTrue,
          isFalse,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultFalse" field value should match the provided value',
      () async {
        var specificObject = BoolDefault(
          boolDefaultFalse: true,
        );
        var specificDatabaseObject = await BoolDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.boolDefaultFalse,
          isTrue,
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultNullFalse" field value should match the provided value',
      () async {
        var specificObject = BoolDefault(
          boolDefaultNullFalse: true,
        );
        var specificDatabaseObject = await BoolDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.boolDefaultNullFalse,
          isTrue,
        );
      },
    );
  });
}
