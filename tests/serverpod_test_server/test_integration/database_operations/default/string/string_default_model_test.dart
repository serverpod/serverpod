import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultModel" fields,', () {
    tearDownAll(
      () async => StringDefaultModel.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultModel=\'This is a default model value\'" field value should match the default value',
      () async {
        var object = StringDefaultModel();
        var databaseObject = await StringDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultModel,
          'This is a default model value',
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "defaultModel=\'This is a default model null value\'" field value should match the default value',
      () async {
        var object = StringDefaultModel();
        var databaseObject = await StringDefaultModel.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultModelNull,
          'This is a default model null value',
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultModel" field value should match the provided value',
      () async {
        var specificObject = StringDefaultModel(
          stringDefaultModel: 'A specific model value',
        );
        var specificDatabaseObject = await StringDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultModel,
          'A specific model value',
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultModelNull" field value should match the provided value',
      () async {
        var specificObject = StringDefaultModel(
          stringDefaultModelNull: 'A specific model null value',
        );
        var specificDatabaseObject = await StringDefaultModel.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultModelNull,
          'A specific model null value',
        );
      },
    );
  });
}
