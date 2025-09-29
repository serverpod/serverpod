import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an immutable object with a table', (sessionBuilder, _) {
    const tableName = 'immutable_object_with_table';
    late Session session;

    setUp(() async {
      session = await sessionBuilder.build();
      await session.db.unsafeExecute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          id SERIAL PRIMARY KEY,
          variable TEXT NOT NULL
        );
      ''');
    });

    tearDown(() async {
      await session.db.unsafeExecute('DROP TABLE $tableName;');
    });

    test('When inserting, then it should be inserted correctly', () async {
      var object = ImmutableObjectWithTable(variable: 'initial value');
      var insertedObject =
          await ImmutableObjectWithTable.db.insertRow(session, object);
      expect(insertedObject.id, isNotNull);
      expect(insertedObject.variable, 'initial value');

      var fetchedObject = await ImmutableObjectWithTable.db
          .findById(session, insertedObject.id!);
      expect(fetchedObject, isNotNull);
      expect(fetchedObject!.id, insertedObject.id);
      expect(fetchedObject.variable, 'initial value');
    });

    test('When updating, then it should be updated correctly', () async {
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
}
