import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" fields,', () {
    tearDownAll(
      () async => DoubleDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=10.5" field value should be 10.5',
      () async {
        var object = DoubleDefault();
        var databaseObject = await DoubleDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.doubleDefault,
          equals(10.5),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default=20.5" field value should be 20.5',
      () async {
        var object = DoubleDefault();
        var databaseObject = await DoubleDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.doubleDefaultNull,
          equals(20.5),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "doubleDefault" field value should match the provided value',
      () async {
        var specificObject = DoubleDefault(
          doubleDefault: 30.5,
        );
        var specificDatabaseObject = await DoubleDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.doubleDefault,
          equals(30.5),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "doubleDefaultNull" field value should match the provided value',
      () async {
        var specificObject = DoubleDefault(
          doubleDefaultNull: 40.5,
        );
        var specificDatabaseObject = await DoubleDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.doubleDefaultNull,
          equals(40.5),
        );
      },
    );
  });
}
