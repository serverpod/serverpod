part of 'database_connection.dart';

// Optional parameters match [DatabaseQueryException]; not all are set from SqliteException.
// ignore_for_file: unused_element_parameter

final class _SqliteDatabaseQueryException extends DatabaseQueryException {
  @override
  final String message;
  @override
  final String? code;
  @override
  final String? detail;
  @override
  final String? hint;
  @override
  final String? tableName;
  @override
  final String? columnName;
  @override
  final String? constraintName;
  @override
  final int? position;

  _SqliteDatabaseQueryException(
    this.message, {
    this.code,
    this.detail,
    this.hint,
    this.tableName,
    this.columnName,
    this.constraintName,
    this.position,
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

final class _SqliteDatabaseInsertRowException
    extends DatabaseInsertRowException {
  @override
  final String message;

  _SqliteDatabaseInsertRowException(this.message);
}

final class _SqliteDatabaseUpdateRowException
    extends DatabaseUpdateRowException {
  @override
  final String message;

  _SqliteDatabaseUpdateRowException(this.message);
}

final class _SqliteDatabaseDeleteRowException
    extends DatabaseDeleteRowException {
  @override
  final String message;

  _SqliteDatabaseDeleteRowException(this.message);
}

final class _SqliteDatabaseUpsertRowException
    extends DatabaseUpsertRowException {
  @override
  final String message;

  _SqliteDatabaseUpsertRowException(this.message);
}
