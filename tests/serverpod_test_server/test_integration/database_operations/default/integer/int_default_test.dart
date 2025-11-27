import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" fields,', () {
    tearDownAll(
      () async => IntDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=10" field value should be 10',
      () async {
        var object = IntDefault();
        var databaseObject = await IntDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.intDefault,
          equals(10),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default=20" field value should be 20',
      () async {
        var object = IntDefault();
        var databaseObject = await IntDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.intDefaultNull,
          equals(20),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "intDefault" field value should match the provided value',
      () async {
        var specificObject = IntDefault(
          intDefault: 30,
        );
        var specificDatabaseObject = await IntDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.intDefault,
          equals(30),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "intDefaultNull" field value should match the provided value',
      () async {
        var specificObject = IntDefault(
          intDefaultNull: 40,
        );
        var specificDatabaseObject = await IntDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.intDefaultNull,
          equals(40),
        );
      },
    );
  });
}
