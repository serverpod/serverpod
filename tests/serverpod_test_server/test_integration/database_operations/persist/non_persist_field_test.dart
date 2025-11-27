import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with fields that include non-persisted fields,', () {
    tearDownAll(
      () async => ObjectFieldPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when inserting a single record into the database then non-persisted simple fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var object = ObjectFieldPersist(
          normal: 'Normal Value',
          api: 'Api Value',
        );

        object = await ObjectFieldPersist.db.insertRow(
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
      'when inserting a single record with nested non-persisted fields into the database then the nested fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var object = ObjectFieldPersist(
          normal: 'Normal Value',
          api: 'Api Value',
          data: SimpleData(num: 1),
        );

        object = await ObjectFieldPersist.db.insertRow(
          session,
          object,
        );

        expect(
          object.data,
          isNotNull,
        );

        expect(
          object.data!.num,
          1,
        );
      },
    );

    test(
      'when inserting multiple records into the database then non-persisted simple fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldPersist>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldPersist(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
            ),
          );
        }

        rows = await ObjectFieldPersist.db.insert(
          session,
          rows,
        );

        for (int i = 0; i < rows.length; i++) {
          var row = rows[i];
          expect(
            row.api,
            'Api Value $i',
          );
        }
      },
    );

    test(
      'when inserting multiple records with nested non-persisted fields into the database then the nested fields should retain their values after insertion, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldPersist>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldPersist(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
              data: SimpleData(num: i),
            ),
          );
        }

        rows = await ObjectFieldPersist.db.insert(
          session,
          rows,
        );

        for (int i = 0; i < rows.length; i++) {
          var row = rows[i];
          expect(
            row.data,
            isNotNull,
          );
          expect(
            row.data!.num,
            i,
          );
        }
      },
    );

    test(
      'when updating a single record in the database then non-persisted simple fields should retain their values after update, even though they are not stored in the database',
      () async {
        var object = ObjectFieldPersist(
          normal: 'Normal Value',
          api: 'Api Value',
        );

        object = await ObjectFieldPersist.db.insertRow(
          session,
          object,
        );

        object = object.copyWith(
          normal: 'Updated Normal Value',
          api: 'Updated Api Value',
        );

        object = await ObjectFieldPersist.db.updateRow(
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
      'when updating a single record with nested non-persisted fields in the database then the nested fields should retain their values after update, even though they are not stored in the database',
      () async {
        var object = ObjectFieldPersist(
          normal: 'Normal Value',
          api: 'Api Value',
          data: SimpleData(num: 1),
        );

        object = await ObjectFieldPersist.db.insertRow(
          session,
          object,
        );

        object = object.copyWith(
          normal: 'Updated Normal Value',
          api: 'Updated Api Value',
        );

        object = await ObjectFieldPersist.db.updateRow(
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

        expect(
          object.data,
          isNotNull,
        );

        expect(
          object.data!.num,
          1,
        );
      },
    );

    test(
      'when updating multiple records in the database then non-persisted simple fields should retain their values after update, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldPersist>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldPersist(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
            ),
          );
        }

        rows = await ObjectFieldPersist.db.insert(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          rows[i] = rows[i].copyWith(
            normal: 'Updated Normal Value $i',
            api: 'Updated Api Value $i',
          );
        }

        rows = await ObjectFieldPersist.db.update(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          var row = rows[i];
          expect(
            row.normal,
            'Updated Normal Value $i',
          );
          expect(
            row.api,
            'Updated Api Value $i',
          );
        }
      },
    );

    test(
      'when updating multiple records with nested non-persisted fields in the database then the nested fields should retain their values after update, even though they are not stored in the database',
      () async {
        var rows = <ObjectFieldPersist>[];

        for (int i = 0; i < 10; i++) {
          rows.add(
            ObjectFieldPersist(
              normal: 'Normal Value $i',
              api: 'Api Value $i',
              data: SimpleData(num: i),
            ),
          );
        }

        rows = await ObjectFieldPersist.db.insert(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          rows[i] = rows[i].copyWith(
            normal: 'Updated Normal Value $i',
            api: 'Updated Api Value $i',
          );
        }

        rows = await ObjectFieldPersist.db.update(
          session,
          rows,
        );

        for (var i = 0; i < rows.length; i++) {
          var row = rows[i];
          expect(
            row.normal,
            'Updated Normal Value $i',
          );
          expect(
            row.api,
            'Updated Api Value $i',
          );
          expect(
            row.data,
            isNotNull,
          );
          expect(
            row.data!.num,
            i,
          );
        }
      },
    );
  });
}
