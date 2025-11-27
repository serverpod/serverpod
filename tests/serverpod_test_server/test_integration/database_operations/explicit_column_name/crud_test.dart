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

      test('when inserting an entry then it is created', () async {
        final inserted = await db.insertRow(session, data);

        expect(inserted.id, isNotNull);
      });
    },
  );

  withServerpod(
    'Given an entry in the database for a table with an explicit column name',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late TableWithExplicitColumnName data;
      late TableWithExplicitColumnName inserted;
      late TableWithExplicitColumnNameRepository db;

      setUp(() async {
        data = TableWithExplicitColumnName(
          userName: 'userName',
          description: 'description',
        );
        db = TableWithExplicitColumnName.db;
        inserted = await db.insertRow(session, data);
      });

      test(
        'when fetching the entry by id then the same object is returned',
        () async {
          final retrieved = await db.findById(session, inserted.id!);

          expect(retrieved, isNotNull);
          expect(retrieved?.id, inserted.id);
          expect(retrieved?.userName, data.userName);
          expect(retrieved?.description, data.description);
        },
      );

      test(
        'when updating the entry then the updated object is returned',
        () async {
          const newUserName = 'newUserName';
          inserted.userName = newUserName;
          final updated = await db.updateRow(session, inserted);

          expect(updated.userName, newUserName);
        },
      );

      test('when deleting the entry then it is deleted', () async {
        final result = await db.deleteRow(session, inserted);

        expect(result, isNotNull);
        final retrieved = await db.findById(session, inserted.id!);
        expect(retrieved, isNull);
      });
    },
  );
}
