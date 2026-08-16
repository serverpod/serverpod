import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" enum fields,', () {
    tearDownAll(
      () async => EnumDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=byName1" field should be byName1',
      () async {
        var object = EnumDefaultPersist();
        var databaseObject = await EnumDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byNameEnumDefaultPersist,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=byName1" field should be byName1',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${EnumDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject = await EnumDefaultPersist.db.findFirstRow(session);
        expect(
          databaseObject?.byNameEnumDefaultPersist,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database, then the "defaultPersist=byIndex1" field should be byIndex1',
      () async {
        var object = EnumDefaultPersist();
        var databaseObject = await EnumDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byIndexEnumDefaultPersist,
          equals(ByIndexEnum.byIndex1),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=byIndex1" field should be byIndex1',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${EnumDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject = await EnumDefaultPersist.db.findFirstRow(session);
        expect(
          databaseObject?.byIndexEnumDefaultPersist,
          equals(ByIndexEnum.byIndex1),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byNameEnumDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = EnumDefaultPersist(
          byNameEnumDefaultPersist: ByNameEnum.byName2,
        );
        var specificDatabaseObject = await EnumDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefaultPersist,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byIndexEnumDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = EnumDefaultPersist(
          byIndexEnumDefaultPersist: ByIndexEnum.byIndex2,
        );
        var specificDatabaseObject = await EnumDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byIndexEnumDefaultPersist,
          equals(ByIndexEnum.byIndex2),
        );
      },
    );
  });
}
