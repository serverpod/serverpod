import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" enum fields,', () {
    tearDownAll(
      () async => EnumDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=byName1" field value should be byName1',
      () async {
        var object = EnumDefault();
        var databaseObject = await EnumDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byNameEnumDefault,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default=byName2" field value should be byName2',
      () async {
        var object = EnumDefault();
        var databaseObject = await EnumDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byNameEnumDefaultNull,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database, then the "default=byIndex1" field value should be byIndex1',
      () async {
        var object = EnumDefault();
        var databaseObject = await EnumDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byIndexEnumDefault,
          equals(ByIndexEnum.byIndex1),
        );
      },
    );

    test(
      'when creating a record in the database, then the nullable "default=byIndex2" field value should be byIndex2',
      () async {
        var object = EnumDefault();
        var databaseObject = await EnumDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.byIndexEnumDefaultNull,
          equals(ByIndexEnum.byIndex2),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byNameEnumDefault" field value should match the provided value',
      () async {
        var specificObject = EnumDefault(
          byNameEnumDefault: ByNameEnum.byName2,
        );
        var specificDatabaseObject = await EnumDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefault,
          equals(ByNameEnum.byName2),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byNameEnumDefaultNull" field value should match the provided value',
      () async {
        var specificObject = EnumDefault(
          byNameEnumDefaultNull: ByNameEnum.byName1,
        );
        var specificDatabaseObject = await EnumDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byNameEnumDefaultNull,
          equals(ByNameEnum.byName1),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byIndexEnumDefault" field value should match the provided value',
      () async {
        var specificObject = EnumDefault(
          byIndexEnumDefault: ByIndexEnum.byIndex2,
        );
        var specificDatabaseObject = await EnumDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byIndexEnumDefault,
          equals(ByIndexEnum.byIndex2),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "byIndexEnumDefaultNull" field value should match the provided value',
      () async {
        var specificObject = EnumDefault(
          byIndexEnumDefaultNull: ByIndexEnum.byIndex1,
        );
        var specificDatabaseObject = await EnumDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.byIndexEnumDefaultNull,
          equals(ByIndexEnum.byIndex1),
        );
      },
    );

    group('Given a class with "default" enum fields,', () {
      test(
        'when deserializing an invalid index for DefaultValueEnum, it should default to value2',
        () async {
          var object = DefaultValueEnum.fromJson(-1);
          expect(DefaultValueEnum.values.length, 2);
          expect(object, DefaultValueEnum.value2);
        },
      );

      test(
        'when deserializing an invalid index for ByIndexEnum, it should throw an ArgumentError',
        () async {
          expect(
            () => ByIndexEnum.fromJson(-1),
            throwsA(
              predicate(
                (e) =>
                    e is ArgumentError &&
                    e.message ==
                        'Value "-1" cannot be converted to "ByIndexEnum"',
              ),
            ),
          );
        },
      );

      test(
        'when deserializing an invalid name for ByNameEnum, it should throw an ArgumentError',
        () async {
          expect(
            () => ByNameEnum.fromJson('Invalid'),
            throwsA(
              predicate(
                (e) =>
                    e is ArgumentError &&
                    e.message ==
                        'Value "Invalid" cannot be converted to "ByNameEnum"',
              ),
            ),
          );
        },
      );
    });
  });
}
