// ignore_for_file: public_member_api_docs

/// A class containing constants for SQLite error codes.
///
/// These error codes are defined in the SQLite documentation at:
/// [https://www.sqlite.org/rescode.html](https://www.sqlite.org/rescode.html)
abstract final class SqliteErrorCode {
  // Class 00 — Successful Completion
  static const String successfulCompletion = '0'; // SQLITE_OK

  // Class 02 — No Data
  static const String noData = '101'; // SQLITE_DONE

  // Class 08 — Connection Exception (Mapped to SQLite file/lock errors)
  static const String connectionFailure = '14'; // SQLITE_CANTOPEN
  static const String protocolViolation = '15'; // SQLITE_PROTOCOL

  // Class 22 — Data Exception
  static const String dataException = '20'; // SQLITE_MISMATCH

  // Class 23 — Integrity Constraint Violation
  static const String integrityConstraintViolation = '19'; // SQLITE_CONSTRAINT
  static const String checkViolation = '275'; // SQLITE_CONSTRAINT_CHECK
  static const String foreignKeyViolation =
      '787'; // SQLITE_CONSTRAINT_FOREIGNKEY
  static const String notNullViolation = '1299'; // SQLITE_CONSTRAINT_NOTNULL
  static const String uniqueViolation = '2067'; // SQLITE_CONSTRAINT_UNIQUE

  // Class 25 — Invalid Transaction State
  static const String readOnlySqlTransaction = '8'; // SQLITE_READONLY

  // Class 28 — Invalid Authorization Specification
  static const String invalidAuthorizationSpecification = '23'; // SQLITE_AUTH
  static const String invalidPassword =
      '23'; // SQLITE_AUTH (Often used in SQLCipher)

  // Class 40 — Transaction Rollback
  static const String transactionRollback = '4'; // SQLITE_ABORT
  static const String deadlockDetected =
      '5'; // SQLITE_BUSY (SQLite locks DBs; conflicts yield BUSY)

  // Class 3B — Savepoint Exception (SQLite uses SQLITE_ERROR for no such savepoint)
  static const String invalidSavepointSpecification = '1'; // SQLITE_ERROR

  // Class 42 — Syntax Error or Access Rule Violation
  static const String syntaxErrorOrAccessRuleViolation = '1'; // SQLITE_ERROR
  static const String syntaxError = '1'; // SQLITE_ERROR
  static const String insufficientPrivilege = '23'; // SQLITE_AUTH
  static const String datatypeMismatch = '20'; // SQLITE_MISMATCH

  // Note: SQLite does not provide extended codes for schema definition errors.
  // Missing or duplicate tables/columns all resolve to the generic SQL logic error (1).
  static const String undefinedColumn = '1'; // SQLITE_ERROR
  static const String undefinedTable = '1'; // SQLITE_ERROR
  static const String duplicateColumn = '1'; // SQLITE_ERROR
  static const String duplicateTable = '1'; // SQLITE_ERROR

  // Class 53 — Insufficient Resources
  static const String insufficientResources = '7'; // SQLITE_NOMEM
  static const String diskFull = '13'; // SQLITE_FULL
  static const String outOfMemory = '7'; // SQLITE_NOMEM
  static const String configurationLimitExceeded = '18'; // SQLITE_TOOBIG

  // Class 54 — Program Limit Exceeded
  static const String programLimitExceeded = '18'; // SQLITE_TOOBIG
  static const String statementTooComplex = '18'; // SQLITE_TOOBIG
  static const String tooManyColumns = '18'; // SQLITE_TOOBIG
  static const String tooManyArguments = '18'; // SQLITE_TOOBIG

  // Class 55 — Object Not In Prerequisite State
  static const String objectInUse = '6'; // SQLITE_LOCKED
  static const String lockNotAvailable = '5'; // SQLITE_BUSY

  // Class 57 — Operator Intervention
  static const String operatorIntervention = '9'; // SQLITE_INTERRUPT
  static const String queryCanceled = '9'; // SQLITE_INTERRUPT

  // Class 58 — System Error
  static const String systemError = '2'; // SQLITE_INTERNAL
  static const String ioError = '10'; // SQLITE_IOERR

  // Class XX — Internal Error
  static const String internalError = '2'; // SQLITE_INTERNAL
  static const String dataCorrupted = '11'; // SQLITE_CORRUPT
  static const String indexCorrupted = '779'; // SQLITE_CORRUPT_INDEX
}
