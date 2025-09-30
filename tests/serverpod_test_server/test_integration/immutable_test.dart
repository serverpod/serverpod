import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an immutable model stored in the database',
      (sessionBuilder, _) {
    late Session session;

    setUp(() async {
      session = await sessionBuilder.build();
    });

    test('when inserting it, then it is inserted correctly', () async {
      var object = ImmutableObjectWithTable(variable: 'initial value');
      var insertedObject =
          await ImmutableObjectWithTable.db.insertRow(session, object);
      expect(insertedObject.id, isNotNull);
      expect(insertedObject.variable, 'initial value');
    });

    group('that is already inserted,', () {
      late ImmutableObjectWithTable constructedObject;
      late ImmutableObjectWithTable insertedObject;

      setUp(() async {
        constructedObject = ImmutableObjectWithTable(variable: 'initial value');
        insertedObject = await ImmutableObjectWithTable.db
            .insertRow(session, constructedObject);
      });

      group('when fetching it,', () {
        late ImmutableObjectWithTable? fetchedObject;

        setUp(() async {
          fetchedObject = (await ImmutableObjectWithTable.db
              .findById(session, insertedObject.id!));
        });

        test('then it is fetched correctly', () async {
          expect(fetchedObject, isNotNull);
          expect(fetchedObject!.id, insertedObject.id);
          expect(fetchedObject!.variable, 'initial value');
        });

        test(
            'then the equality comparison with constructed object returns false',
            () {
          expect(fetchedObject, isNot(equals(constructedObject)));
        });

        test('then the equality comparison with inserted object returns true',
            () {
          expect(fetchedObject, equals(insertedObject));
        });

        test(
            'then the equality comparison with identical fetched object returns true',
            () async {
          final theSameFetchedObject = (await ImmutableObjectWithTable.db
              .findById(session, insertedObject.id!));
          expect(fetchedObject, equals(theSameFetchedObject));
        });
      });

      test('when updating it, then it is updated correctly', () async {
        var object = ImmutableObjectWithTable(variable: 'initial value');
        var insertedObject =
            await ImmutableObjectWithTable.db.insertRow(session, object);

        var updatedObject = await ImmutableObjectWithTable.db.updateRow(
            session, insertedObject.copyWith(variable: 'updated value'));
        expect(updatedObject.id, insertedObject.id);
        expect(updatedObject.variable, 'updated value');

        var fetchedObject = await ImmutableObjectWithTable.db
            .findById(session, insertedObject.id!);
        expect(fetchedObject, isNotNull);
        expect(fetchedObject!.id, insertedObject.id);
        expect(fetchedObject.variable, 'updated value');
      });
    });
  });
}
