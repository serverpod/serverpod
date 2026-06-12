import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  test(
    'Given that a table does not exist in the database when querying that table then the database exception prompt the user to check if a migration was applied.',
    () async {
      var randomName = 't_${Uuid().v4().replaceAll('-', '_')}';

      await expectLater(
        session.db.unsafeQuery('SELECT * FROM $randomName'),
        throwsA(
          allOf(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              SqliteErrorCode.undefinedTable,
            ),
            predicate<DatabaseQueryException>(
              (e) => e.message.contains(
                'no such table: ',
              ),
            ),
          ),
        ),
      );
    },
  );
}
