import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with fields that include non-persisted fields,', () {
    tearDownAll(() async => ObjectFieldScopes.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    test(
      'when inserting a single record into the database then non-persisted fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var object = ObjectFieldScopes(
          normal: 'Normal Value',
          api: 'Api Value',
          database: 'Database Value',
        );

        object = await ObjectFieldScopes.db.insertRow(
          session,
          object,
        );

        expect(
          object.api,
          'Api Value',
        );
      },
    );

    test(
      'when inserting multiple records into the database then non-persisted fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldScopes>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldScopes(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
              database: 'Database Value $i',
            ),
          );
        }

        rows = await ObjectFieldScopes.db.insert(
          session,
          rows,
        );

        for (int i = 0; i < rows.length; i++) {
          expect(
            rows[i].api,
            'Api Value $i',
          );
        }
      },
    );

    test(
      'when updating a single record in the database then non-persisted fields should retain their values after update, even though they are not stored in the database',
      () async {
        var object = ObjectFieldScopes(
          normal: 'Normal Value',
          api: 'Api Value',
          database: 'Database Value',
        );

        object = await ObjectFieldScopes.db.insertRow(
          session,
          object,
        );

        object = object.copyWith(
          normal: 'Updated Normal Value',
          api: 'Updated Api Value',
        );

        object = await ObjectFieldScopes.db.updateRow(
          session,
          object,
        );

        expect(
          object.normal,
          'Updated Normal Value',
        );
        expect(
          object.api,
          'Updated Api Value',
        );
      },
    );

    test(
      'when updating multiple records in the database then non-persisted fields should retain their values after update, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldScopes>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldScopes(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
              database: 'Database Value $i',
            ),
          );
        }

        rows = await ObjectFieldScopes.db.insert(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          rows[i] = rows[i].copyWith(
            normal: 'Updated Normal Value $i',
            api: 'Updated Api Value $i',
          );
        }

        rows = await ObjectFieldScopes.db.update(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          expect(
            rows[i].normal,
            'Updated Normal Value $i',
          );
          expect(
            rows[i].api,
            'Updated Api Value $i',
          );
        }
      },
    );
  });
}
