import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a database storable immutable model when inserted into the database',
    (sessionBuilder, _) {
      late Session session;
      late ImmutableObjectWithTable object;
      late Future<ImmutableObjectWithTable> insertFuture;

      setUp(() async {
        session = await sessionBuilder.build();
        object = ImmutableObjectWithTable(variable: 'initial value');
        insertFuture = ImmutableObjectWithTable.db.insertRow(session, object);
      });

      test('then insertion completes', () async {
        await expectLater(insertFuture, completes);
      });

      test('then inserted object has expected values', () async {
        var insertedObject = await insertFuture;
        expect(insertedObject.id, isNotNull);
        expect(insertedObject.variable, object.variable);
      });

      test('then inserted object is not equal to constructed object', () async {
        var insertedObject = await insertFuture;
        expect(insertedObject, isNot(equals(object)));
      });

      test(
        'then inserted object is equal to database fetched object',
        () async {
          var insertedObject = await insertFuture;
          var fetchedObject = await ImmutableObjectWithTable.db.findById(
            session,
            insertedObject.id!,
          );
          expect(fetchedObject, isNotNull);
          expect(fetchedObject, equals(insertedObject));
        },
      );
    },
  );

  withServerpod('Given an immutable model stored in the database', (
    sessionBuilder,
    _,
  ) {
    late Session session;
    late ImmutableObjectWithTable insertedObject;

    setUp(() async {
      session = await sessionBuilder.build();
      insertedObject = await ImmutableObjectWithTable.db.insertRow(
        session,
        ImmutableObjectWithTable(variable: 'initial value'),
      );
    });

    test('then two identical fetches return equal objects', () async {
      var fetchedObject1 = await ImmutableObjectWithTable.db.findById(
        session,
        insertedObject.id!,
      );
      var fetchedObject2 = await ImmutableObjectWithTable.db.findById(
        session,
        insertedObject.id!,
      );
      expect(fetchedObject1, isNotNull);
      expect(fetchedObject2, isNotNull);
      expect(fetchedObject1, equals(fetchedObject2));
    });

    group('when updated', () {
      late Future<ImmutableObjectWithTable> updateFuture;
      final updateHash = const Uuid().v4();
      setUp(() async {
        updateFuture = ImmutableObjectWithTable.db.updateRow(
          session,
          insertedObject.copyWith(
            variable: '${insertedObject.variable} - $updateHash',
          ),
        );
      });

      test('then update completes', () async {
        await expectLater(updateFuture, completes);
      });

      test('then updates object has expected values', () async {
        var updatedObject = await updateFuture;
        expect(updatedObject.variable, endsWith(updateHash));
      });
    });
  });
}
