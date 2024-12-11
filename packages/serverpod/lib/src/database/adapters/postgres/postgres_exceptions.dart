part of 'database_connection.dart';

final class _PgDatabaseQueryException implements DatabaseQueryException {
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

  _PgDatabaseQueryException(
    this.message, {
    this.code,
    this.detail,
    this.hint,
    this.tableName,
    this.columnName,
    this.constraintName,
    this.position,
  });

  factory _PgDatabaseQueryException.fromServerException(
    pg.ServerException e, {
    String? messageOverride,
  }) {
    var message = messageOverride ?? e.message;
    return _PgDatabaseQueryException(
      message,
      code: e.code,
      detail: e.detail,
      hint: e.hint,
      tableName: e.tableName,
      columnName: e.columnName,
      constraintName: e.constraintName,
      position: e.position,
    );
  }
}

final class _PgDatabaseInsertRowException
    implements DatabaseInsertRowException {
  @override
  final String message;

  _PgDatabaseInsertRowException(this.message);
}

final class _PgDatabaseUpdateRowException
    implements DatabaseUpdateRowException {
  @override
  final String message;

  _PgDatabaseUpdateRowException(this.message);
}

final class _PgDatabaseDeleteRowException
    implements DatabaseDeleteRowException {
  @override
  final String message;

  _PgDatabaseDeleteRowException(this.message);
}
