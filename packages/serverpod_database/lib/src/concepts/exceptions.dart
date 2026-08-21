/// Exception thrown when an error occurs in the database.
class DatabaseException implements Exception {
  /// Creates a new [DatabaseException] with the given [message].
  DatabaseException(this.message);

  /// A message describing the error.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Exception thrown when the result of a database operation is unexpected.
class DatabaseUnexpectedResultException extends DatabaseException {
  /// Creates a new [DatabaseUnexpectedResultException].
  DatabaseUnexpectedResultException(super.message);
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
    return '$runtimeType: { $details }';
  }
}

/// Exception thrown when a query violates a unique constraint.
class DatabaseUniqueViolationException extends DatabaseQueryException {
  /// Creates a new [DatabaseUniqueViolationException].
  DatabaseUniqueViolationException(
    super.message, {
    super.code,
    super.detail,
    super.hint,
    super.tableName,
    super.columnName,
    super.constraintName,
    super.position,
  });
}

/// Exception thrown when a query violates a foreign key constraint..
class DatabaseForeignKeyViolationException extends DatabaseQueryException {
  /// Creates a new [DatabaseForeignKeyViolationException].
  DatabaseForeignKeyViolationException(
    super.message, {
    super.code,
    super.detail,
    super.hint,
    super.tableName,
    super.columnName,
    super.constraintName,
    super.position,
  });
}

/// Exception thrown when a query cannot acquire a lock on the SQLite database.
///
/// This typically happens when transactions run concurrently, or when a query
/// is executed without passing the transaction of an already active transaction.
class SqliteDatabaseLockedException extends DatabaseQueryException {
  /// Creates a new [SqliteDatabaseLockedException].
  SqliteDatabaseLockedException(
    super.message, {
    super.code,
    super.detail,
    super.hint,
    super.tableName,
    super.columnName,
    super.constraintName,
    super.position,
  });
}

/// Thrown when SQLite [PRAGMA foreign_key_check](https://www.sqlite.org/pragma.html#pragma_foreign_key_check)
/// reports one or more rows that violate foreign key constraints.
final class SqliteMigrationForeignKeyViolationException
    implements DatabaseException {
  /// Creates a new [SqliteMigrationForeignKeyViolationException].
  ///
  /// Each map is a row from `PRAGMA foreign_key_check` (typically `table`,
  /// `rowid`, `parent`, `fkid`).
  SqliteMigrationForeignKeyViolationException(this.violations)
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
  String toString() => 'SqliteMigrationForeignKeyViolationException: $message';
}
