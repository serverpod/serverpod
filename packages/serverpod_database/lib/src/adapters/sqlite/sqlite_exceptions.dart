part of 'database_connection.dart';

// Optional parameters match [DatabaseQueryException]; not all are set from SqliteException.
// ignore_for_file: unused_element_parameter

final class _SqliteDatabaseQueryException extends DatabaseQueryException {
  _SqliteDatabaseQueryException(
    super.message, {
    super.code,
    super.detail,
    super.hint,
    super.tableName,
    super.columnName,
    super.constraintName,
    super.position,
  });

  factory _SqliteDatabaseQueryException.fromSqliteException(Object e) {
    if (e is! SqliteException) {
      int? code;
      if ([
        'recursive lock',
        'LockError',
      ].any((s) => e.toString().contains(s))) {
        code = 6;
      }
      return _SqliteDatabaseQueryException(e.toString(), code: code.toString());
    }

    var code = e.extendedResultCode;
    if (e.resultCode == 19 && e.message.contains('FOREIGN KEY')) {
      code = 787;
    }
    return _SqliteDatabaseQueryException(
      e.message,
      code: code.toString(),
      detail: e.explanation,
    );
  }
}
