import 'package:sqlite3/common.dart';
import 'package:sqlite_async/sqlite_async.dart';

import 'sqlite_statement_batch.dart';

/// Executes a bounded plan on the existing transaction's database worker.
Future<List<ResultSet>> executeSqliteBatch(
  SqliteWriteContext context,
  List<SqliteBatchStatement> statements,
) {
  // Keep this closure outside the connection class: only send the bound plan,
  // never the session, connection pool, transaction, or serialization manager.
  return context.computeWithDatabase((database) async {
    return runPreparedSqliteBatch(
      database,
      statements.map((statement) => statement.sql),
      (statement, index) => statement.select(statements[index].parameters),
    );
  });
}
