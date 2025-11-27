import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a table with an explicit column name',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late TableWithExplicitColumnName data;
      late TableWithExplicitColumnNameRepository db;

      setUp(() {
        data = TableWithExplicitColumnName(
          userName: 'userName',
          description: 'description',
        );
        db = TableWithExplicitColumnName.db;
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
      });
    },
  );
}
