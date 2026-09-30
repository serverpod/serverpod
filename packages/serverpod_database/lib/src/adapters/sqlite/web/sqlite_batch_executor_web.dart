import 'package:sqlite3/common.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../sqlite_statement_batch.dart';

/// Executes statements in order using the existing transaction and worker.
Future<List<ResultSet>> executeSqliteBatch(
  SqliteWriteContext context,
  List<SqliteBatchStatement> statements,
) async {
  final results = <ResultSet>[];

  for (final statement in statements) {
    results.add(await context.execute(statement.sql, statement.parameters));
  }

  return results;
}

/// Opens a database with the driver's existing worker and storage options.
SqliteDatabase openSqliteDatabase(String path, SqliteOptions options) =>
    SqliteDatabase(path: path, options: options);
