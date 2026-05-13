/// Exception thrown when an error occurs in the database.
abstract base class DatabaseException implements Exception {
  /// Returns the message of the exception.
  String get message;

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exception thrown when an exception occurs during a database query.
abstract base class DatabaseQueryException implements DatabaseException {
  /// Returns the error code of the exception.
  String? get code;

  /// Additional details if provided by the database.
  String? get detail;

  /// A hint on how to remedy an error, if provided by the database.
  String? get hint;

  /// Returns the name of the table where the error occurred.
  String? get tableName;

  /// Returns the name of the column where the error occurred.
  String? get columnName;

  /// Returns the name of the constraint that was violated.
  String? get constraintName;

  /// Returns the position in the query where the error occurred.
  int? get position;

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

/// Exception thrown when an insert row operation fails.
abstract base class DatabaseInsertRowException implements DatabaseException {
  @override
  String toString() => 'DatabaseInsertRowException: $message';
}

/// Exception thrown when an update row operation fails.
abstract base class DatabaseUpdateRowException implements DatabaseException {
  @override
  String toString() => 'DatabaseUpdateRowException: $message';
}

/// Exception thrown when a delete row operation fails.
abstract base class DatabaseDeleteRowException implements DatabaseException {
  @override
  String toString() => 'DatabaseDeleteRowException: $message';
}

/// Exception thrown when an upsert row operation fails.
abstract base class DatabaseUpsertRowException implements DatabaseException {
  @override
  String toString() => 'DatabaseUpsertRowException: $message';
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
