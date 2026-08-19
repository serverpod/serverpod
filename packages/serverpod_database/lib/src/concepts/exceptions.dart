/// Exception thrown when an error occurs in the database.
class DatabaseException implements Exception {
  /// Creates a new [DatabaseException] with the given [message].
  DatabaseException(this.message);

  /// A message describing the error.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Exception thrown when an error occurs during the execution of a database operation.
class DatabaseExecutionException extends DatabaseException {
  /// Creates a new [DatabaseExecutionException].
  DatabaseExecutionException(super.message);
}

/// Exception thrown when an exception occurs during a database query.
class DatabaseQueryException extends DatabaseException {
  /// Creates a new [DatabaseQueryException].
  DatabaseQueryException(
    super.message, {
    this.code,
    this.detail,
    this.hint,
    this.tableName,
    this.columnName,
    this.constraintName,
    this.position,
  });

  /// The error code of the exception.
  final String? code;

  /// Additional details if provided by the database.
  final String? detail;

  /// A hint on how to remedy an error, if provided by the database.
  final String? hint;

  /// The name of the table where the error occurred.
  final String? tableName;

  /// The name of the column where the error occurred.
  final String? columnName;

  /// The name of the constraint that was violated.
  final String? constraintName;

  /// The position in the query where the error occurred.
  final int? position;

  @override
  String toString() {
    var details = [
      'message: $message',
      if (code != null) 'code: $code',
      if (detail != null) 'detail: $detail',
      if (hint != null) 'hint: $hint',
      if (tableName != null) 'table: $tableName',
      if (columnName != null) 'column: $columnName',
      if (constraintName != null) 'constraint: $constraintName',
      if (position != null) 'position: $position',
    ].join(', ');
    return 'DatabaseQueryException: { $details }';
  }
}

/// Thrown when SQLite [PRAGMA foreign_key_check](https://www.sqlite.org/pragma.html#pragma_foreign_key_check)
/// reports one or more rows that violate foreign key constraints.
final class SqliteForeignKeyViolationException implements DatabaseException {
  /// Creates a new [SqliteForeignKeyViolationException].
  ///
  /// Each map is a row from `PRAGMA foreign_key_check` (typically `table`,
  /// `rowid`, `parent`, `fkid`).
  SqliteForeignKeyViolationException(this.violations)
    : message = _formatMessage(violations);

  /// Rows returned by `PRAGMA foreign_key_check`.
  final List<Map<String, dynamic>> violations;

  @override
  final String message;

  static String _formatMessage(List<Map<String, dynamic>> violations) {
    final buffer = StringBuffer(
      'Foreign key integrity check failed: ${violations.length} violation'
      '${violations.length > 1 ? 's' : ''}.',
    );
    for (var i = 0; i < violations.length; i++) {
      buffer.writeln();
      buffer.write('  ${i + 1}. ');
      buffer.write(
        violations[i].entries.map((e) => '${e.key}=${e.value}').join(', '),
      );
    }
    return buffer.toString();
  }

  @override
  String toString() => 'SqliteForeignKeyViolationException: $message';
}
