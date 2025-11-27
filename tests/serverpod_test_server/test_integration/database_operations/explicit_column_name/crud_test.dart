import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';
import '../../../../../packages/serverpod/lib/src/database/sql_query_builder.dart';
import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a table with an explicit column name',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late TableWithExplicitColumnName data;
      late TableWithExplicitColumnNameRepository db;
      late TableWithExplicitColumnNameTable table;

      setUp(() {
        data = TableWithExplicitColumnName(
          userName: 'userName',
          description: 'description',
        );
        db = TableWithExplicitColumnName.db;
        table = TableWithExplicitColumnName.t;
      });

      group('when inserting', () {
        test('then it is created', () async {
          final inserted = await db.insertRow(session, data);

          expect(inserted.id, isNotNull);
        });
      });

      group('when an object is retrieved by its id', () {
        test('it returns the same object after insertion', () async {
          final inserted = await db.insertRow(session, data);
          final retrieved = await db.findById(session, (await inserted).id!);

          expect(retrieved, isNotNull);
          expect(retrieved?.id, inserted.id);
          expect(retrieved?.userName, data.userName);
          expect(retrieved?.description, data.description);
        });
      });

      test('when an object is previously inserted and then updated, '
          'the updated object is returned', () async {
        const newUserName = 'newUserName';
        final inserted = await db.insertRow(session, data);
        inserted.userName = newUserName;
        final updated = await db.updateRow(session, inserted);

        expect(updated.userName, newUserName);
      });

      group('when deleting', () {
        test('then it is deleted', () async {
          final inserted = await db.insertRow(session, data);
          final result = await db.deleteRow(session, inserted);

          expect(result, isNotNull);
          final retrieved = await db.findById(session, inserted.id!);
          expect(retrieved, isNull);
        });

        test('the explicit column name is used in the sql', () {
          final query = DeleteQueryBuilder(
            table: table,
          ).withReturn(Returning.all).withWhere(Constant.bool(true)).build();
          expect(
            query,
            'DELETE FROM "${table.tableName}" WHERE TRUE '
            'RETURNING "${table.tableName}"."id" AS "${table.tableName}.id", '
            '"${table.tableName}"."user_name" AS "${table.tableName}.user_name", '
            '"${table.tableName}"."user_description" AS "${table.tableName}.user_description"',
          );
        });
      });
    },
  );
}
