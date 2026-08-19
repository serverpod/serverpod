import 'dart:io';

import 'package:path/path.dart' as p;

/// Creates a path for a client-side test database in its own temporary
/// directory.
Future<String> createTestDatabasePath() async {
  var directory = await Directory.systemTemp.createTemp('client_db_session_');
  return p.join(directory.path, 'test.db');
}

/// Removes the temporary directory holding the database at [path].
///
/// Retries while Windows releases SQLite handles from stopped worker isolates.
Future<void> deleteTestDatabase(String path) async {
  var directory = Directory(p.dirname(path));
  if (!await directory.exists()) return;

  const maxAttempts = 30;
  var delay = const Duration(milliseconds: 100);
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      await directory.delete(recursive: true);
      return;
    } on PathAccessException {
      if (attempt == maxAttempts - 1) rethrow;
      await Future<void>.delayed(delay);
      delay *= 2;
      if (delay > const Duration(seconds: 2)) {
        delay = const Duration(seconds: 2);
      }
    }
  }
}
