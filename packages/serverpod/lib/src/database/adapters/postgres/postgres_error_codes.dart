// ignore_for_file: public_member_api_docs

/// A class containing constants for PostgreSQL error codes.
///
/// These error codes are defined in the PostgreSQL documentation at:
/// https://www.postgresql.org/docs/current/errcodes-appendix.html
abstract final class PgErrorCode {
  // Class 00 — Successful Completion
  static const successfulCompletion = '00000';

  // Class 01 — Warning
  static const warning = '01000';
  static const dynamicResultSetsReturned = '0100C';
  static const implicitZeroBitPadding = '01008';
  static const nullValueEliminatedInSetFunction = '01003';
  static const privilegeNotGranted = '01007';
  static const privilegeNotRevoked = '01006';
  static const stringDataRightTruncationWarning = '01004';
  static const deprecatedFeature = '01P01';

  // Class 02 — No Data (this is also a warning class per the SQL standard)
  static const noData = '02000';
  static const noAdditionalDynamicResultSetsReturned = '02001';

  // Class 03 — SQL Statement Not Yet Complete
  static const sqlStatementNotYetComplete = '03000';

  // Class 08 — Connection Exception
  static const connectionException = '08000';
  static const connectionDoesNotExist = '08003';
  static const connectionFailure = '08006';
  static const sqlclientUnableToEstablishSqlconnection = '08001';
  static const sqlserverRejectedEstablishmentOfSqlconnection = '08004';
  static const transactionResolutionUnknown = '08007';
  static const protocolViolation = '08P01';

  // Class 09 — Triggered Action Exception
  static const triggeredActionException = '09000';

  // Class 0A — Feature Not Supported
  static const featureNotSupported = '0A000';

  // Class 0B — Invalid Transaction Initiation
  static const invalidTransactionInitiation = '0B000';

  // Class 0F — Locator Exception
  static const locatorException = '0F000';
  static const invalidLocatorSpecification = '0F001';

  // Class 0L — Invalid Grantor
  static const invalidGrantor = '0L000';
  static const invalidGrantOperation = '0LP01';

  // Class 0P — Invalid Role Specification
  static const invalidRoleSpecification = '0P000';

  // Class 0Z — Diagnostics Exception
  static const diagnosticsException = '0Z000';
  static const stackedDiagnosticsAccessedWithoutActiveHandler = '0Z002';

  // Class 20 — Case Not Found
  static const caseNotFound = '20000';

  // Class 21 — Cardinality Violation
  static const cardinalityViolation = '21000';

  // Class 22 — Data Exception
  static const dataException = '22000';
  static const arraySubscriptError = '2202E';
  static const characterNotInRepertoire = '22021';
  static const datetimeFieldOverflow = '22008';
  static const divisionByZero = '22012';
  static const errorInAssignment = '22005';
  static const escapeCharacterConflict = '2200B';
  static const indicatorOverflow = '22022';
  static const intervalFieldOverflow = '22015';
  static const invalidArgumentForLogarithm = '2201E';
  static const invalidArgumentForNtileFunction = '22014';
  static const invalidArgumentForNthValueFunction = '22016';
  static const invalidArgumentForPowerFunction = '2201F';
  static const invalidArgumentForWidthBucketFunction = '2201G';
  static const invalidCharacterValueForCast = '22018';
  static const invalidDatetimeFormat = '22007';
  static const invalidEscapeCharacter = '22019';
  static const invalidEscapeOctet = '2200D';
  static const invalidEscapeSequence = '22025';
  static const nonstandardUseOfEscapeCharacter = '22P06';
  static const invalidIndicatorParameterValue = '22010';
  static const invalidParameterValue = '22023';
  static const invalidRegularExpression = '2201B';
  static const invalidRowCountInLimitClause = '2201W';
  static const invalidRowCountInResultOffsetClause = '2201X';
  static const invalidTablesampleArgument = '2202H';
  static const invalidTablesampleRepeat = '2202G';
  static const invalidTimeZoneDisplacementValue = '22009';
  static const invalidUseOfEscapeCharacter = '2200C';
  static const mostSpecificTypeMismatch = '2200G';
  static const nullValueNotAllowed = '22004';
  static const nullValueNoIndicatorParameter = '22002';
  static const numericValueOutOfRange = '22003';
  static const sequenceGeneratorLimitExceeded = '2200H';
  static const stringDataLengthMismatch = '22026';
  static const stringDataRightTruncation = '22001';
  static const substringError = '22011';
  static const trimError = '22027';
  static const unterminatedCString = '22024';
  static const zeroLengthCharacterString = '2200F';
  static const floatingPointException = '22P01';
  static const invalidTextRepresentation = '22P02';
  static const invalidBinaryRepresentation = '22P03';
  static const badCopyFileFormat = '22P04';
  static const untranslatableCharacter = '22P05';
  static const notAnXmlDocument = '2200L';
  static const invalidXmlDocument = '2200M';
  static const invalidXmlContent = '2200N';
  static const invalidXmlComment = '2200S';
  static const invalidXmlProcessingInstruction = '2200T';
  static const duplicateJsonObjectKey = '22030';
  static const invalidArgumentForJsonDatetimeFunction = '22031';
  static const invalidJsonText = '22032';
  static const invalidSqlJsonSubscript = '22033';
  static const moreThanOneSqlJsonItem = '22034';
  static const noSqlJsonItem = '22035';
  static const nonNumericSqlJsonItem = '22036';
  static const nonUniqueKeysInJsonObject = '22037';
  static const singletonSqlJsonItemRequired = '22038';
  static const sqlJsonArrayNotFound = '22039';
  static const sqlJsonMemberNotFound = '2203A';
  static const sqlJsonNumberNotFound = '2203B';
  static const sqlJsonObjectNotFound = '2203C';
  static const tooManyJsonArrayElements = '2203D';
  static const tooManyJsonObjectMembers = '2203E';
  static const sqlJsonScalarRequired = '2203F';
  static const sqlJasonItemCannotBeCastToTargetType = '2203G';

  // Class 23 — Integrity Constraint Violation
  static const integrityConstraintViolation = '23000';
  static const restrictViolation = '23001';
  static const notNullViolation = '23502';
  static const foreignKeyViolation = '23503';
  static const uniqueViolation = '23505';
  static const checkViolation = '23514';
  static const exclusionViolation = '23P01';

  // Class 24 — Invalid Cursor State
  static const invalidCursorState = '24000';

  // Class 25 — Invalid Transaction State
  static const invalidTransactionState = '25000';
  static const activeSqlTransaction = '25001';
  static const branchTransactionAlreadyActive = '25002';
  static const heldCursorRequiresSameIsolationLevel = '25008';
  static const inappropriateAccessModeForBranchTransaction = '25003';
  static const inappropriateIsolationLevelForBranchTransaction = '25004';
  static const noActiveSqlTransactionForBranchTransaction = '25005';
  static const readOnlySqlTransaction = '25006';
  static const schemaAndDataStatementMixingNotSupported = '25007';
  static const noActiveSqlTransaction = '25P01';
  static const inFailedSqlTransaction = '25P02';
  static const idleInTransactionSessionTimeout = '25P03';
  static const transactionTimeout = '25P04';

  // Class 26 — Invalid SQL Statement Name
  static const invalidSqlStatementName = '26000';

  // Class 27 — Triggered Data Change Violation
  static const triggeredDataChangeViolation = '27000';

  // Class 28 — Invalid Authorization Specification
  static const invalidAuthorizationSpecification = '28000';
  static const invalidPassword = '28P01';

  // Class 2B — Dependent Privilege Descriptors Still Exist
  static const dependentPrivilegeDescriptorsStillExist = '2B000';
  static const dependentObjectsStillExist = '2BP01';

  // Class 2D — Invalid Transaction Termination
  static const invalidTransactionTermination = '2D000';

  // Class 2F — SQL Routine Exception
  static const sqlRoutineException = '2F000';
  static const functionExecutedNoReturnStatement = '2F005';
  static const modifyingSqlDataNotPermitted = '2F002';
  static const prohibitedSqlStatementAttempted = '2F003';
  static const readingSqlDataNotPermitted = '2F004';

  // Class 34 — Invalid Cursor Name
  static const invalidCursorName = '34000';

  // Class 38 — External Routine Exception
  static const externalRoutineException = '38000';
  static const containingSqlNotPermitted = '38001';
  static const modifyingSqlDataNotPermittedExternal = '38002';
  static const prohibitedSqlStatementAttemptedExternal = '38003';
  static const readingSqlDataNotPermittedExternal = '38004';

  // Class 39 — External Routine Invocation Exception
  static const externalRoutineInvocationException = '39000';
  static const invalidSqlstateReturned = '39001';
  static const nullValueNotAllowedExternal = '39004';
  static const triggerProtocolViolated = '39P01';
  static const srfProtocolViolated = '39P02';
  static const eventTriggerProtocolViolated = '39P03';

  // Class 3B — Savepoint Exception
  static const savepointException = '3B000';
  static const invalidSavepointSpecification = '3B001';

  // Class 40 — Transaction Rollback
  static const transactionRollback = '40000';
  static const serializationFailure = '40001';
  static const transactionIntegrityConstraintViolation = '40002';
  static const statementCompletionUnknown = '40003';
  static const deadlockDetected = '40P01';

  // Class 42 — Syntax Error or Access Rule Violation
  static const syntaxErrorOrAccessRuleViolation = '42000';
  static const syntaxError = '42601';
  static const insufficientPrivilege = '42501';
  static const cannotCoerce = '42846';
  static const groupingError = '42803';
  static const windowingError = '42P20';
  static const invalidRecursion = '42P19';
  static const invalidForeignKey = '42830';
  static const invalidName = '42602';
  static const nameTooLong = '42622';
  static const reservedName = '42939';
  static const datatypeMismatch = '42804';
  static const indeterminateDatatype = '42P18';
  static const collationMismatch = '42P21';
  static const indeterminateCollation = '42P22';
  static const wrongObjectType = '42809';
  static const generatedAlways = '428C9';
  static const undefinedColumn = '42703';
  static const undefinedFunction = '42883';
  static const undefinedTable = '42P01';
  static const undefinedParameter = '42P02';
  static const undefinedObject = '42704';
  static const duplicateColumn = '42701';
  static const duplicateCursor = '42P03';
  static const duplicateDatabase = '42P04';
  static const duplicateFunction = '42723';
  static const duplicatePreparedStatement = '42P05';
  static const duplicateSchema = '42P06';
  static const duplicateTable = '42P07';
  static const duplicateAlias = '42712';
  static const duplicateObject = '42710';
  static const ambiguousColumn = '42702';
  static const ambiguousFunction = '42725';
  static const ambiguousParameter = '42P08';
  static const ambiguousAlias = '42P09';
  static const invalidColumnReference = '42P10';
  static const invalidColumnDefinition = '42611';
  static const invalidCursorDefinition = '42P11';
  static const invalidDatabaseDefinition = '42P12';
  static const invalidFunctionDefinition = '42P13';
  static const invalidPreparedStatementDefinition = '42P14';
  static const invalidSchemaDefinition = '42P15';
  static const invalidTableDefinition = '42P16';
  static const invalidObjectDefinition = '42P17';

  // Class 44 — WITH CHECK OPTION Violation
  static const withCheckOptionViolation = '44000';

  // Class 53 — Insufficient Resources
  static const insufficientResources = '53000';
  static const diskFull = '53100';
  static const outOfMemory = '53200';
  static const tooManyConnections = '53300';
  static const configurationLimitExceeded = '53400';

  // Class 54 — Program Limit Exceeded
  static const programLimitExceeded = '54000';
  static const statementTooComplex = '54001';
  static const tooManyColumns = '54011';
  static const tooManyArguments = '54023';

  // Class 55 — Object Not In Prerequisite State
  static const objectNotInPrerequisiteState = '55000';
  static const objectInUse = '55006';
  static const cantChangeRuntimeParam = '55P02';
  static const lockNotAvailable = '55P03';
  static const unsafeNewEnumValueUsage = '55P04';

  // Class 57 — Operator Intervention
  static const operatorIntervention = '57000';
  static const queryCanceled = '57014';
  static const adminShutdown = '57P01';
  static const crashShutdown = '57P02';
  static const cannotConnectNow = '57P03';
  static const databaseDropped = '57P04';
  static const idleSessionTimeout = '57P05';

  // Class 58 — System Error
  static const systemError = '58000';
  static const ioError = '58030';
  static const undefinedFile = '58P01';
  static const duplicateFile = '58P02';

  // Class F0 — Configuration File Error
  static const configurationFileError = 'F0000';
  static const lockFileExists = 'F0001';

  // Class HV — Foreign Data Wrapper Error (SQL/MED)
  static const fdwError = 'HV000';
  static const fdwColumnNameNotFound = 'HV005';
  static const fdwDynamicParameterValueNeeded = 'HV002';
  static const fdwFunctionSequenceError = 'HV010';
  static const fdwInconsistentDescriptorInformation = 'HV021';
  static const fdwInvalidAttributeValue = 'HV024';
  static const fdwInvalidColumnName = 'HV007';
  static const fdwInvalidColumnNumber = 'HV008';
  static const fdwInvalidDataType = 'HV004';
  static const fdwInvalidDataTypeDescriptors = 'HV006';
  static const fdwInvalidDescriptorFieldIdentifier = 'HV091';
  static const fdwInvalidHandle = 'HV00B';
  static const fdwInvalidOptionIndex = 'HV00C';
  static const fdwInvalidOptionName = 'HV00D';
  static const fdwInvalidStringLengthOrBufferLength = 'HV090';
  static const fdwInvalidStringFormat = 'HV00A';
  static const fdwInvalidUseOfNullPointer = 'HV009';
  static const fdwTooManyHandles = 'HV014';
  static const fdwOutOfMemory = 'HV001';
  static const fdwNoSchemas = 'HV00P';
  static const fdwOptionNameNotFound = 'HV00J';
  static const fdwReplyHandle = 'HV00K';
  static const fdwSchemaNotFound = 'HV00Q';
  static const fdwTableNotFound = 'HV00R';
  static const fdwUnableToCreateExecution = 'HV00L';
  static const fdwUnableToCreateReply = 'HV00M';
  static const fdwUnableToEstablishConnection = 'HV00N';

  // Class P0 — PL/pgSQL Error
  static const plpgsqlError = 'P0000';
  static const raiseException = 'P0001';
  static const noDataFound = 'P0002';
  static const tooManyRows = 'P0003';
  static const assertFailure = 'P0004';

  // Class XX — Internal Error
  static const internalError = 'XX000';
  static const dataCorrupted = 'XX001';
  static const indexCorrupted = 'XX002';
}
