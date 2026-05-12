import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

const _clientUrl = 'http://localhost:8081/';

late ClientDatabaseSession _session;
late Directory _tempDir;

/// A fresh [ClientDatabaseSession] for each test that is automatically closed
/// and removed once no longer needed.
ClientDatabaseSession get session => _session;

/// Initialize one [ClientDatabaseSession] for each test whole file to avoid a
/// slower operation of creating one file per test. The isolation is ensured by
/// a cleanup of all tables after each test. This means that tests do not need
/// a [tearDown].
void initTestClientSession() {
  setUpAll(() async {
    _tempDir = await Directory.systemTemp.createTemp('client_db_session_');
    _session = await Client(_clientUrl).createSession(
      p.join(_tempDir.path, 'test.db'),
      isDebugMode: true,
    );
  });

  tearDown(() async {
    await _clearUserTables(_session);
  });

  tearDownAll(() async {
    await _session.close();
    if (_tempDir.existsSync()) {
      await _tempDir.delete(recursive: true);
    }
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
