import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(
      () async => DecimalDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=10.5" field should be 10.5',
      () async {
        var object = DecimalDefaultPersist();
        var databaseObject = await DecimalDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.decimalDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=10.5" field should be 10.5',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${DecimalDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject = await DecimalDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.decimalDefaultPersist,
          equals(Decimal.parse('10.5')),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "decimalDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = DecimalDefaultPersist(
          decimalDefaultPersist: Decimal.parse('20.5'),
        );
        var specificDatabaseObject = await DecimalDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.decimalDefaultPersist,
          equals(Decimal.parse('20.5')),
        );
      },
    );
  });
}
