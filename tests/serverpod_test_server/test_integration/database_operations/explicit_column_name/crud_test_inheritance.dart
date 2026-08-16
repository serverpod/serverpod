import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a child class with explicit column name that extends another class',
    (sessionBuilder, endpoints) {
      final session = sessionBuilder.build();
      const parentValue = 'parentValue';
      const childValue = 'childValue';

      late ChildClassExplicitColumn data;
      late ChildClassExplicitColumnRepository db;

      setUp(() {
        data = ChildClassExplicitColumn(
          nonTableParentField: parentValue,
          childField: childValue,
        );
        db = ChildClassExplicitColumn.db;
      });

      test('when inserting an entry then it is created', () async {
        final inserted = await db.insertRow(session, data);

        expect(inserted.id, isNotNull);
        expect(inserted.nonTableParentField, parentValue);
        expect(inserted.childField, childValue);
      });

      group('Given an entry in the database', () {
        late ChildClassExplicitColumn inserted;

        setUp(() async {
          inserted = await db.insertRow(session, data);
        });

        test(
          'when fetching the entry by id then the same object is returned',
          () async {
            final retrieved = await db.findById(session, inserted.id!);

            expect(retrieved, isNotNull);
            expect(retrieved!.id, inserted.id);
            expect(retrieved.nonTableParentField, data.nonTableParentField);
            expect(retrieved.childField, data.childField);
          },
        );

        group('when updating the entry', () {
          late ChildClassExplicitColumn updatedReturn;
          const newChildField = 'newChildValue';

          setUp(() async {
            inserted.childField = newChildField;
            updatedReturn = await db.updateRow(session, inserted);
          });

          test('then the updated object is returned', () {
            expect(updatedReturn.childField, newChildField);
            expect(updatedReturn.nonTableParentField, parentValue);
          });

          test('then the entry is updated in the database', () async {
            final retrieved = await db.findById(session, inserted.id!);

            expect(retrieved, isNotNull);
            expect(retrieved!.childField, newChildField);
            expect(retrieved.nonTableParentField, parentValue);
          });
        });

        test('when deleting the entry then it is deleted', () async {
          final result = await db.deleteRow(session, inserted);

          expect(result, isNotNull);
          final retrieved = await db.findById(session, inserted.id!);
          expect(retrieved, isNull);
        });
      });
    },
  );
}
