part of 'database_connection.dart';

final class _PgDatabaseQueryException extends DatabaseQueryException {
  _PgDatabaseQueryException(
    super.message, {
    super.code,
    super.detail,
    super.hint,
    super.tableName,
    super.columnName,
    super.constraintName,
    super.position,
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
