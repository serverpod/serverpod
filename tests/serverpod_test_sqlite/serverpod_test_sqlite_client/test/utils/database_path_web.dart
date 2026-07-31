/// Makes every database name unique within a suite.
var _databaseCount = 0;

/// Creates a name for a client-side test database.
///
/// Names only have to be unique within the browser profile, which `dart test`
/// and `flutter test` recreate for every run.
Future<String> createTestDatabasePath() async {
  var id = '${DateTime.now().microsecondsSinceEpoch}_${_databaseCount++}';
  return 'client_db_session_$id.db';
}

/// Does nothing. The browser profile holding the database at [path] is
/// discarded when the run ends.
Future<void> deleteTestDatabase(String path) async {}
