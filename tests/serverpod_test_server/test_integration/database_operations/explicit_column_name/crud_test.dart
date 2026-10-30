import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a table with an explicit column name,',
    (sessionBuilder, endpoints) {
      late Session session;
      setUp(() => session = sessionBuilder.build());

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
    'Given an entry in the database for a table with an explicit column name,',
    (sessionBuilder, endpoints) {
      late Session session;
      setUp(() => session = sessionBuilder.build());

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

      group('when updating the entry', () {
        late TableWithExplicitColumnName updatedReturn;
        const newUserName = 'newUserName';

        setUp(() async {
          inserted.userName = newUserName;
          updatedReturn = await db.updateRow(session, inserted);
        });

        test('then the updated object is returned', () {
          expect(updatedReturn.userName, newUserName);
        });

        test('then the entry is updated in the database', () async {
          final retrieved = await db.findById(session, inserted.id!);

          expect(retrieved, isNotNull);
          expect(retrieved?.userName, newUserName);
        });
      });

      group('when updating the entry by id', () {
        late TableWithExplicitColumnName? updatedReturn;
        const newUserName = 'newUserName';

        setUp(() async {
          updatedReturn = await db.updateById(
            session,
            inserted.id!,
            columnValues: (t) => [t.userName(newUserName)],
          );
        });

        test('then the updated object is returned', () {
          expect(updatedReturn, isNotNull);
          expect(updatedReturn!.id, inserted.id);
          expect(updatedReturn!.userName, newUserName);
          expect(updatedReturn!.description, data.description);
        });

        test('then the entry is updated in the database', () async {
          final retrieved = await db.findById(session, inserted.id!);

          expect(retrieved?.userName, newUserName);
        });
      });

      group('when updating the entry with a where clause', () {
        late List<TableWithExplicitColumnName> updatedReturn;
        const newUserName = 'newUserName';

        setUp(() async {
          updatedReturn = await db.updateWhere(
            session,
            columnValues: (t) => [t.userName(newUserName)],
            where: (t) => t.userName.equals(data.userName),
          );
        });

        test('then the updated object is returned', () {
          expect(updatedReturn, hasLength(1));
          expect(updatedReturn.first.id, inserted.id);
          expect(updatedReturn.first.userName, newUserName);
          expect(updatedReturn.first.description, data.description);
        });

        test('then the entry is updated in the database', () async {
          final retrieved = await db.findById(session, inserted.id!);

          expect(retrieved?.userName, newUserName);
        });
      });

      test('when deleting the entry then it is deleted', () async {
        final result = await db.deleteRow(session, inserted);

        expect(result, isNotNull);
        final retrieved = await db.findById(session, inserted.id!);
        expect(retrieved, isNull);
      });
    },
  );

  withServerpod(
    'Given multiple entries in the database for a table with an explicit column name',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await TableWithExplicitColumnName.db.insert(session, [
          TableWithExplicitColumnName(userName: 'b', description: 'match'),
          TableWithExplicitColumnName(userName: 'c', description: 'match'),
          TableWithExplicitColumnName(userName: 'a', description: 'match'),
        ]);
      });

      group('when updating in descending order of an explicit column', () {
        late List<TableWithExplicitColumnName> updated;

        setUp(() async {
          updated = await TableWithExplicitColumnName.db.updateWhere(
            session,
            columnValues: (t) => [t.description('updated')],
            where: (t) => t.description.equals('match'),
            orderBy: (t) => t.userName.desc(),
            limit: 2,
          );
        });

        test('then rows are ordered correctly in descending order', () {
          expect(updated, hasLength(2));
          expect(updated[0].userName, 'c');
          expect(updated[1].userName, 'b');
        });

        test('then the updated rows are returned', () {
          expect(updated.map((e) => e.description), everyElement('updated'));
        });
      });

      group('when updating with a limit and no order', () {
        late List<TableWithExplicitColumnName> updated;

        setUp(() async {
          updated = await TableWithExplicitColumnName.db.updateWhere(
            session,
            columnValues: (t) => [t.description('updated')],
            where: (t) => t.description.equals('match'),
            limit: 2,
          );
        });

        test('then the updated rows are returned', () {
          expect(updated, hasLength(2));
          expect(updated.map((e) => e.description), everyElement('updated'));
        });
      });
    },
  );
}
