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
