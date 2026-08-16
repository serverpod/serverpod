import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import 'utils/database_path.dart';

const _clientUrl = 'http://localhost:8081/';

late ClientDatabaseSession _session;
late String _databasePath;

/// A fresh [ClientDatabaseSession] for each test that is automatically closed
/// and removed once no longer needed.
ClientDatabaseSession get session => _session;

/// Initialize one [ClientDatabaseSession] for each test whole file to avoid a
/// slower operation of creating one file per test. The isolation is ensured by
/// a cleanup of all tables after each test. This means that tests do not need
/// a [tearDown].
///
/// Suites using this run on the VM and in the browser. On the browser they need
/// `sqlite3.wasm` and `db_worker.js` next to the test file - see
/// `util/setup_sqlite_web_assets` in the repository root.
void initTestClientSession() {
  setUpAll(() async {
    _databasePath = await createTestDatabasePath();
    _session = await Client(_clientUrl).createSession(
      _databasePath,
      isDebugMode: true,
    );
  });

  tearDown(() async {
    await _clearUserTables(_session);
  });

  tearDownAll(() async {
    await _session.close();
    await deleteTestDatabase(_databasePath);
  });
}

Future<void> _clearUserTables(DatabaseSession session) async {
  await session.db.unsafeExecute('PRAGMA foreign_keys = OFF');
  final result = await session.db.unsafeQuery('''
    SELECT name
    FROM sqlite_master
    WHERE (type = 'table')
      AND (name NOT IN ('serverpod_migrations', 'serverpod_sqlite_schema'))
''');
  for (final row in result) {
    final tableName = row[0] as String;
    await session.db.unsafeExecute('DELETE FROM "$tableName"');
  }
  await session.db.unsafeExecute('PRAGMA foreign_keys = ON');
}
