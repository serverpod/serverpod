import 'dart:io';

import 'package:path/path.dart' as p;

/// Creates a path for a client-side test database in its own temporary
/// directory.
Future<String> createTestDatabasePath() async {
  var directory = await Directory.systemTemp.createTemp('client_db_session_');
  return p.join(directory.path, 'test.db');
}

/// Removes the temporary directory holding the database at [path].
Future<void> deleteTestDatabase(String path) async {
  var directory = Directory(p.dirname(path));
  if (directory.existsSync()) {
    await directory.delete(recursive: true);
  }
}
