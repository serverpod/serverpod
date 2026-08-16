import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultModel" fields,', () {
    tearDownAll(
      () async => BoolDefaultModel.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultModel=true" field value should be true',
      () async {
        var object = BoolDefaultModel();
        var databaseObject = await BoolDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.boolDefaultModelTrue, isTrue);
      },
    );

    test(
      'when creating a record in the database, then the "defaultModel=false" field value should be false',
      () async {
        var object = BoolDefaultModel();
        var databaseObject = await BoolDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.boolDefaultModelFalse, isFalse);
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel=false" field value should be false',
      () async {
        var object = BoolDefaultModel();
        var databaseObject = await BoolDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.boolDefaultModelNullFalse, isFalse);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultModelTrue" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultModel(
          boolDefaultModelTrue: false,
        );
        var specificDatabaseObject = await BoolDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultModelTrue, isFalse);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultModelFalse" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultModel(
          boolDefaultModelFalse: true,
        );
        var specificDatabaseObject = await BoolDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultModelFalse, isTrue);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "boolDefaultModelNullFalse" field value should match the provided value',
      () async {
        var specificObject = BoolDefaultModel(
          boolDefaultModelNullFalse: true,
        );
        var specificDatabaseObject = await BoolDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.boolDefaultModelNullFalse, isTrue);
      },
    );
  });
}
