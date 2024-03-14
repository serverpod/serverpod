/// Exception thrown when an error occurs during a database operation.
class DatabaseException implements Exception {
  /// A message indicating the error.
  final String message;

  /// Creates a new [DatabaseException].
  DatabaseException(this.message);

  @override
  String toString() {
    return 'DatabaseException: $message';
  }
}

/// Exception thrown when no row is inserted when inserting a row.
class DatabaseInsertRowException extends DatabaseException {
  /// Creates a new [DatabaseInsertRowException].
  DatabaseInsertRowException(super.message);
}

/// Exception thrown when no rows is updated when updating a row.
class DatabaseUpdateRowException extends DatabaseException {
  /// Creates a new [DatabaseUpdateRowException].
  DatabaseUpdateRowException(super.message);
}

/// Exception thrown when no rows is deleted when deleting a row.
class DatabaseDeleteRowException extends DatabaseException {
  /// Creates a new [DatabaseDeleteRowException].
  DatabaseDeleteRowException(super.message);
}
