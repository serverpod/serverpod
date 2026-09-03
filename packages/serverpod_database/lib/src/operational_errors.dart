import 'dart:io';

import 'package:postgres/postgres.dart' as pg;

import 'adapters/postgres/postgres_error_codes.dart';
import 'concepts/exceptions.dart';
import 'migrations/migration_exceptions.dart';

/// Postgres SQLSTATEs that are operational (misconfig, unavailable server)
/// rather than unexpected bugs. Listed explicitly — do not prefix-match
/// class `08` (`08P01` is protocol violation, a driver bug).
const Set<String> operationalSqlStates = {
  PgErrorCode.connectionException,
  PgErrorCode.connectionDoesNotExist,
  PgErrorCode.connectionFailure,
  PgErrorCode.sqlclientUnableToEstablishSqlconnection,
  PgErrorCode.sqlserverRejectedEstablishmentOfSqlconnection,
  PgErrorCode.transactionResolutionUnknown,
  PgErrorCode.invalidAuthorizationSpecification,
  PgErrorCode.invalidPassword,
  PgErrorCode.invalidCatalogName,
  PgErrorCode.invalidSchemaName,
  PgErrorCode.adminShutdown,
  PgErrorCode.crashShutdown,
  PgErrorCode.cannotConnectNow,
  PgErrorCode.databaseDropped,
  PgErrorCode.tooManyConnections,
  PgErrorCode.undefinedTable,
};

/// Whether [code] is a known operational Postgres SQLSTATE.
bool isOperationalSqlState(String? code) =>
    code != null && operationalSqlStates.contains(code);

/// Extracts a Postgres SQLSTATE from [error] or a wrapped cause.
String? sqlStateOf(Object error) {
  return switch (error) {
    DatabaseConnectException(:final sqlState) => sqlState,
    DatabaseQueryException(:final code) => code,
    pg.ServerException(:final code) => code,
    _ => null,
  };
}

/// Walks [error] and [DatabaseConnectException.cause].
Iterable<Object> causeChain(Object error) sync* {
  var current = error;
  final seen = <int>{};
  while (seen.add(identityHashCode(current))) {
    yield current;
    final next = switch (current) {
      DatabaseConnectException(:final cause) => cause,
      _ => null,
    };
    if (next == null) return;
    current = next;
  }
}

/// Whether the console log for [error] should include a stack trace.
///
/// Operational types (`DatabaseConnectException`, `MigrationLoadException`,
/// listed SQLSTATEs) omit the stack. Unknown errors keep it. Dart `dart:io`
/// types are not classified here — wrap those on the connect path.
bool shouldIncludeConsoleStack(Object error) {
  for (final e in causeChain(error)) {
    if (e is DatabaseConnectException) return false;
    if (e is MigrationLoadException) return false;
    if (e is DatabaseQueryException && isOperationalSqlState(e.code)) {
      return false;
    }
    if (e is pg.ServerException && isOperationalSqlState(e.code)) {
      return false;
    }
  }
  return true;
}

/// Wraps a raw connect-path failure as [DatabaseConnectException].
///
/// Idempotent if [error] is already a [DatabaseConnectException].
DatabaseConnectException wrapConnectFailure(
  Object error, {
  String? message,
}) {
  if (error is DatabaseConnectException) return error;
  return DatabaseConnectException(
    cause: error,
    sqlState: sqlStateOf(error),
    message: message,
  );
}

/// Exception to put on [ExceptionEvent] — the original cause, not the wrap.
Object exceptionEventException(Object error) {
  if (error is DatabaseConnectException) return error.cause;
  return error;
}

/// Dedupe key for retry / repeat suppression: `(causeType, sqlState|osError)`.
String operationalDedupeKey(Object error) {
  final root = error is DatabaseConnectException ? error.cause : error;
  final sqlState = sqlStateOf(error) ?? sqlStateOf(root);
  return '${root.runtimeType}:${sqlState ?? _osErrorCode(root)}';
}

String _osErrorCode(Object error) {
  if (error is SocketException) {
    return '${error.osError?.errorCode ?? error.message}';
  }
  return '';
}

/// Whether [error] is an undefined-table failure for [tableName].
///
/// Postgres is matched on SQLSTATE `42P01` and on `relation "name" does not
/// exist` when the driver drops the SQLSTATE (the `PgException` fallback in
/// the adapter). Schema-qualified names (`public.name`) are accepted. SQLite
/// is matched on the `no such table` message — not
/// `SqliteErrorCode.undefinedTable`, which is the generic `SQLITE_ERROR` (`1`).
bool isUndefinedTableError(Object error, {String? tableName}) {
  if (sqlStateOf(error) == PgErrorCode.undefinedTable) return true;
  for (final e in causeChain(error)) {
    if (sqlStateOf(e) == PgErrorCode.undefinedTable) return true;
    if (e is DatabaseQueryException) {
      if (e.code == PgErrorCode.undefinedTable) return true;
      if (_undefinedTableMessage(e.message, tableName)) return true;
    }
    if (e is pg.ServerException && e.code == PgErrorCode.undefinedTable) {
      return true;
    }
    if (_undefinedTableMessage(e.toString(), tableName)) return true;
  }
  return false;
}

bool _undefinedTableMessage(String text, String? tableName) {
  final lower = text.toLowerCase();
  if (tableName == null) {
    return lower.contains('no such table:') ||
        (lower.contains('relation "') && lower.contains('" does not exist')) ||
        (lower.contains("relation '") && lower.contains("' does not exist"));
  }

  final name = tableName.toLowerCase();
  if (lower.contains('no such table: $name') ||
      lower.contains('no such table: "$name"') ||
      lower.contains("no such table: '$name'")) {
    return true;
  }
  // `relation "name"` or `relation "schema.name"`, single or double quotes.
  // Also matches the adapter rewrite of 42P01:
  // "Table not found ... (relation "name" ...)".
  return RegExp(
    'relation\\s+["\'](?:[^"\']+\\.)?${RegExp.escape(name)}["\']',
  ).hasMatch(lower);
}
