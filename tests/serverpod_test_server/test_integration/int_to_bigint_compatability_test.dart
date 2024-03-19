import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/v4.dart';

void main() async {
  // Suite of regression tests to ensure that int and bigint types are
  // compatible with each other in the database.
  var session = await IntegrationTestServer().session();

  group('Given table that uses an int column and has a row entry', () {
    var tableName = UuidV4().generate().toString();
    var initialValue = 1;

    setUp(() async {
      await session.db.unsafeSimpleExecute('''
CREATE TABLE "$tableName" (
  id SERIAL PRIMARY KEY,
  anInt integer
);

INSERT INTO "$tableName" (anInt) VALUES ($initialValue);
''');
    });

    tearDown(() async {
      await session.db.unsafeExecute('''
DROP TABLE "$tableName";
''');
    });

    test('when doing updates using bigint type', () async {
      var id = 1;
      var newValue = 5;
      var result = await session.db.unsafeQuery('''
UPDATE "$tableName" SET anInt = $newValue WHERE id = $id::bigint RETURNING *;
''');

      expect(result, [
        [
          id,
          newValue,
        ]
      ]);
    });

    test('when doing inserts using bigint type', () async {
      var expectedId = 2;
      var newValue = 5;
      var result = await session.db.unsafeQuery('''
INSERT INTO "$tableName" (anInt) VALUES ($newValue::bigint) RETURNING *;
''');

      expect(result, [
        [
          expectedId,
          newValue,
        ]
      ]);
    });

    test('when doing finds using bigint type', () async {
      var result = await session.db.unsafeQuery('''
SELECT * FROM "$tableName" WHERE anInt = $initialValue::bigint;
''');

      expect(result, [
        [
          1,
          initialValue,
        ]
      ]);
    });
  });
}
