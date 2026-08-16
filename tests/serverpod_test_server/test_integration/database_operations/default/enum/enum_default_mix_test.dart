import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with mixed default enum fields,', () {
    tearDownAll(
      () async => EnumDefaultMix.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database with an unsafe query, then the "byNameEnumDefaultAndDefaultModel" field value should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${EnumDefaultMix.t.tableName}" ("byNameEnumDefaultAndDefaultModel", "byNameEnumDefaultAndDefaultPersist", "byNameEnumDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await EnumDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.byNameEnumDefaultAndDefaultModel,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "byNameEnumDefaultAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${EnumDefaultMix.t.tableName}" ("byNameEnumDefaultAndDefaultModel", "byNameEnumDefaultAndDefaultPersist", "byNameEnumDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await EnumDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.byNameEnumDefaultAndDefaultPersist,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "byNameEnumDefaultModelAndDefaultPersist" field value should match the defaultPersist value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO "${EnumDefaultMix.t.tableName}" ("byNameEnumDefaultAndDefaultModel", "byNameEnumDefaultAndDefaultPersist", "byNameEnumDefaultModelAndDefaultPersist")
        VALUES (DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await EnumDefaultMix.db.findFirstRow(session);
        expect(
          databaseObject?.byNameEnumDefaultModelAndDefaultPersist,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "byNameEnumDefaultAndDefaultModel" field value should match the provided value',
      () async {
        var specificObject = EnumDefaultMix(
          byNameEnumDefaultAndDefaultModel: ByNameEnum.byName2,
        );
        var specificDatabaseObject = await EnumDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefaultAndDefaultModel,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "byNameEnumDefaultAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = EnumDefaultMix(
          byNameEnumDefaultAndDefaultPersist: ByNameEnum.byName1,
        );
        var specificDatabaseObject = await EnumDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefaultAndDefaultPersist,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database with specific values, then the "byNameEnumDefaultModelAndDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = EnumDefaultMix(
          byNameEnumDefaultModelAndDefaultPersist: ByNameEnum.byName1,
        );
        var specificDatabaseObject = await EnumDefaultMix.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefaultModelAndDefaultPersist,
          equals(ByNameEnum.byName1),
        );
      },
    );
  });
}
