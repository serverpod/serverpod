import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultModel" fields,', () {
    tearDownAll(
      () async => DoubleDefaultModel.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultModel=10.5" field value should be 10.5',
      () async {
        var object = DoubleDefaultModel();
        var databaseObject = await DoubleDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.doubleDefaultModel, 10.5);
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel=20.5" field value should be 20.5',
      () async {
        var object = DoubleDefaultModel();
        var databaseObject = await DoubleDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(databaseObject.doubleDefaultModelNull, 20.5);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "doubleDefaultModel" field value should match the provided value',
      () async {
        var specificObject = DoubleDefaultModel(
          doubleDefaultModel: 30.5,
        );
        var specificDatabaseObject = await DoubleDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.doubleDefaultModel, 30.5);
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "doubleDefaultModelNull" field value should match the provided value',
      () async {
        var specificObject = DoubleDefaultModel(
          doubleDefaultModelNull: 40.5,
        );
        var specificDatabaseObject = await DoubleDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(specificDatabaseObject.doubleDefaultModelNull, 40.5);
      },
    );
  });
}
