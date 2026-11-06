/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;
import '../../../common/secret_challenge/models/secret_challenge.dart'
    as _i7k1fa50;

/// Pending one-time password (OTP) login request for an email address.
///
/// Created for both registered and unregistered email addresses, so that the
/// existence of an account is not revealed before the code is verified.
abstract class EmailAccountOtpLoginRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  EmailAccountOtpLoginRequest._({
    this.id,
    DateTime? createdAt,
    required this.email,
    required this.challengeId,
    this.challenge,
    this.completeChallengeId,
    this.completeChallenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EmailAccountOtpLoginRequest({
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? completeChallengeId,
    _i7k1fa50.SecretChallenge? completeChallenge,
  }) = _EmailAccountOtpLoginRequestImpl;

  factory EmailAccountOtpLoginRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountOtpLoginRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      email: jsonSerialization['email'] as String,
      challengeId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
      completeChallengeId: jsonSerialization['completeChallengeId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['completeChallengeId'],
            ),
      completeChallenge: jsonSerialization['completeChallenge'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_i7k1fa50.SecretChallenge>(
              jsonSerialization['completeChallenge'],
            ),
    );
  }

  static final t = EmailAccountOtpLoginRequestTable();

  static const db = EmailAccountOtpLoginRequestRepository._();

  @override
  _is.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  _is.UuidValue challengeId;

  /// The associated challenge holding the one-time password.
  _i7k1fa50.SecretChallenge? challenge;

  _is.UuidValue? completeChallengeId;

  /// Used to complete the login or the account creation.
  /// This will be set after the one-time password has been verified.
  _i7k1fa50.SecretChallenge? completeChallenge;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountOtpLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccountOtpLoginRequest copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge =
        const _UndefinedEmailAccountOtpLoginRequest$challenge(),
    _is.UuidValue? completeChallengeId = const _is.$UndefinedUuidValue(),
    _i7k1fa50.SecretChallenge? completeChallenge =
        const _UndefinedEmailAccountOtpLoginRequest$challenge(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountOtpLoginRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'email': email,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
      if (completeChallengeId != null)
        'completeChallengeId': completeChallengeId?.toJson(),
      if (completeChallenge != null)
        'completeChallenge': completeChallenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountOtpLoginRequestInclude include({
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? completeChallenge,
  }) {
    return EmailAccountOtpLoginRequestInclude._(
      challenge: challenge,
      completeChallenge: completeChallenge,
    );
  }

  static EmailAccountOtpLoginRequestIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    EmailAccountOtpLoginRequestInclude? include,
  }) {
    return EmailAccountOtpLoginRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedEmailAccountOtpLoginRequest$challenge
    extends _is.UndefinedSentinel
    implements _i7k1fa50.SecretChallenge {
  const _UndefinedEmailAccountOtpLoginRequest$challenge();
}

class _EmailAccountOtpLoginRequestImpl extends EmailAccountOtpLoginRequest {
  _EmailAccountOtpLoginRequestImpl({
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
    _is.UuidValue? completeChallengeId,
    _i7k1fa50.SecretChallenge? completeChallenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         email: email,
         challengeId: challengeId,
         challenge: challenge,
         completeChallengeId: completeChallengeId,
         completeChallenge: completeChallenge,
       );

  /// Returns a shallow copy of this [EmailAccountOtpLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAccountOtpLoginRequest copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge =
        const _UndefinedEmailAccountOtpLoginRequest$challenge(),
    _is.UuidValue? completeChallengeId = const _is.$UndefinedUuidValue(),
    _i7k1fa50.SecretChallenge? completeChallenge =
        const _UndefinedEmailAccountOtpLoginRequest$challenge(),
  }) {
    return EmailAccountOtpLoginRequest(
      id: id is _is.UndefinedSentinel ? this.id : id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _is.UndefinedSentinel
          ? this.challenge?.copyWith()
          : challenge,
      completeChallengeId: completeChallengeId is _is.UndefinedSentinel
          ? this.completeChallengeId
          : completeChallengeId,
      completeChallenge: completeChallenge is _is.UndefinedSentinel
          ? this.completeChallenge?.copyWith()
          : completeChallenge,
    );
  }
}

class EmailAccountOtpLoginRequestUpdateTable
    extends _is.UpdateTable<EmailAccountOtpLoginRequestTable> {
  EmailAccountOtpLoginRequestUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> challengeId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.challengeId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> completeChallengeId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.completeChallengeId,
    value,
  );
}

class EmailAccountOtpLoginRequestTable extends _is.Table<_is.UuidValue?> {
  EmailAccountOtpLoginRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account_otp_login_request') {
    updateTable = EmailAccountOtpLoginRequestUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    challengeId = _is.ColumnUuid(
      'challengeId',
      this,
    );
    completeChallengeId = _is.ColumnUuid(
      'completeChallengeId',
      this,
    );
  }

  late final EmailAccountOtpLoginRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _is.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  late final _is.ColumnUuid challengeId;

  /// The associated challenge holding the one-time password.
  _i7k1fa50.SecretChallengeTable? _challenge;

  late final _is.ColumnUuid completeChallengeId;

  /// Used to complete the login or the account creation.
  /// This will be set after the one-time password has been verified.
  _i7k1fa50.SecretChallengeTable? _completeChallenge;

  _i7k1fa50.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _is.createRelationTable(
      relationFieldName: 'challenge',
      field: EmailAccountOtpLoginRequest.t.challengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  _i7k1fa50.SecretChallengeTable get completeChallenge {
    if (_completeChallenge != null) return _completeChallenge!;
    _completeChallenge = _is.createRelationTable(
      relationFieldName: 'completeChallenge',
      field: EmailAccountOtpLoginRequest.t.completeChallengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _completeChallenge!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    email,
    challengeId,
    completeChallengeId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    if (relationField == 'completeChallenge') {
      return completeChallenge;
    }
    return null;
  }
}

class EmailAccountOtpLoginRequestInclude extends _is.IncludeObject {
  EmailAccountOtpLoginRequestInclude._({
    _i7k1fa50.SecretChallengeInclude? challenge,
    _i7k1fa50.SecretChallengeInclude? completeChallenge,
  }) {
    _challenge = challenge;
    _completeChallenge = completeChallenge;
  }

  _i7k1fa50.SecretChallengeInclude? _challenge;

  _i7k1fa50.SecretChallengeInclude? _completeChallenge;

  @override
  Map<String, _is.Include?> get includes => {
    'challenge': _challenge,
    'completeChallenge': _completeChallenge,
  };

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountOtpLoginRequest.t;
}

class EmailAccountOtpLoginRequestIncludeList extends _is.IncludeList {
  EmailAccountOtpLoginRequestIncludeList._({
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountOtpLoginRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountOtpLoginRequest.t;
}

class EmailAccountOtpLoginRequestRepository {
  const EmailAccountOtpLoginRequestRepository._();

  final attachRow = const EmailAccountOtpLoginRequestAttachRowRepository._();

  final detachRow = const EmailAccountOtpLoginRequestDetachRowRepository._();

  /// Returns a list of [EmailAccountOtpLoginRequest]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<EmailAccountOtpLoginRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountOtpLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAccountOtpLoginRequest>(
      where: where?.call(EmailAccountOtpLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [EmailAccountOtpLoginRequest]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `EmailAccountOtpLoginRequest.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<EmailAccountOtpLoginRequest>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    EmailAccountOtpLoginRequestInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<EmailAccountOtpLoginRequest>(
      where: where?.call(EmailAccountOtpLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [EmailAccountOtpLoginRequest] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<EmailAccountOtpLoginRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountOtpLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAccountOtpLoginRequest>(
      where: where?.call(EmailAccountOtpLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAccountOtpLoginRequest] by its [id] or null if no such row exists.
  Future<EmailAccountOtpLoginRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    EmailAccountOtpLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAccountOtpLoginRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAccountOtpLoginRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountOtpLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> insert(
    _is.DatabaseSession session,
    List<EmailAccountOtpLoginRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAccountOtpLoginRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAccountOtpLoginRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountOtpLoginRequest] will have its `id` field set.
  Future<EmailAccountOtpLoginRequest> insertRow(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountOtpLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAccountOtpLoginRequest]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [EmailAccountOtpLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> upsert(
    _is.DatabaseSession session,
    List<EmailAccountOtpLoginRequest> rows, {
    required _is.ColumnSelections<EmailAccountOtpLoginRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountOtpLoginRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAccountOtpLoginRequest>(
      rows,
      conflictColumns: conflictColumns(EmailAccountOtpLoginRequest.t),
      updateColumns: updateColumns?.call(EmailAccountOtpLoginRequest.t),
      updateWhere: updateWhere?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAccountOtpLoginRequest] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [EmailAccountOtpLoginRequest] will have its `id` field set.
  Future<EmailAccountOtpLoginRequest?> upsertRow(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest row, {
    required _is.ColumnSelections<EmailAccountOtpLoginRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountOtpLoginRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAccountOtpLoginRequest>(
      row,
      conflictColumns: conflictColumns(EmailAccountOtpLoginRequest.t),
      updateColumns: updateColumns?.call(EmailAccountOtpLoginRequest.t),
      updateWhere: updateWhere?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountOtpLoginRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> update(
    _is.DatabaseSession session,
    List<EmailAccountOtpLoginRequest> rows, {
    _is.ColumnSelections<EmailAccountOtpLoginRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAccountOtpLoginRequest>(
      rows,
      columns: columns?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAccountOtpLoginRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountOtpLoginRequest> updateRow(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest row, {
    _is.ColumnSelections<EmailAccountOtpLoginRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountOtpLoginRequest>(
      row,
      columns: columns?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountOtpLoginRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountOtpLoginRequest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<EmailAccountOtpLoginRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountOtpLoginRequest>(
      id,
      columnValues: columnValues(EmailAccountOtpLoginRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountOtpLoginRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailAccountOtpLoginRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAccountOtpLoginRequest>(
      columnValues: columnValues(EmailAccountOtpLoginRequest.t.updateTable),
      where: where(EmailAccountOtpLoginRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAccountOtpLoginRequest]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> delete(
    _is.DatabaseSession session,
    List<EmailAccountOtpLoginRequest> rows, {
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAccountOtpLoginRequest>(
      rows,
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAccountOtpLoginRequest].
  Future<EmailAccountOtpLoginRequest> deleteRow(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountOtpLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountOtpLoginRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable> where,
    _is.OrderByBuilder<EmailAccountOtpLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountOtpLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAccountOtpLoginRequest>(
      where: where(EmailAccountOtpLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountOtpLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountOtpLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountOtpLoginRequest>(
      where: where?.call(EmailAccountOtpLoginRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAccountOtpLoginRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountOtpLoginRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAccountOtpLoginRequest>(
      where: where(EmailAccountOtpLoginRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EmailAccountOtpLoginRequestAttachRowRepository {
  const EmailAccountOtpLoginRequestAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountOtpLoginRequest] and [SecretChallenge]
  /// by setting the [EmailAccountOtpLoginRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest emailAccountOtpLoginRequest,
    _i7k1fa50.SecretChallenge challenge, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountOtpLoginRequest.id == null) {
      throw ArgumentError.notNull('emailAccountOtpLoginRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $emailAccountOtpLoginRequest = emailAccountOtpLoginRequest.copyWith(
      challengeId: challenge.id,
    );
    await session.db.updateRow<EmailAccountOtpLoginRequest>(
      $emailAccountOtpLoginRequest,
      columns: [EmailAccountOtpLoginRequest.t.challengeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EmailAccountOtpLoginRequest] and [SecretChallenge]
  /// by setting the [EmailAccountOtpLoginRequest]'s foreign key `completeChallengeId` to refer to the [SecretChallenge].
  Future<void> completeChallenge(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest emailAccountOtpLoginRequest,
    _i7k1fa50.SecretChallenge completeChallenge, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountOtpLoginRequest.id == null) {
      throw ArgumentError.notNull('emailAccountOtpLoginRequest.id');
    }
    if (completeChallenge.id == null) {
      throw ArgumentError.notNull('completeChallenge.id');
    }

    var $emailAccountOtpLoginRequest = emailAccountOtpLoginRequest.copyWith(
      completeChallengeId: completeChallenge.id,
    );
    await session.db.updateRow<EmailAccountOtpLoginRequest>(
      $emailAccountOtpLoginRequest,
      columns: [EmailAccountOtpLoginRequest.t.completeChallengeId],
      transaction: transaction,
    );
  }
}

class EmailAccountOtpLoginRequestDetachRowRepository {
  const EmailAccountOtpLoginRequestDetachRowRepository._();

  /// Detaches the relation between this [EmailAccountOtpLoginRequest] and the [SecretChallenge] set in `completeChallenge`
  /// by setting the [EmailAccountOtpLoginRequest]'s foreign key `completeChallengeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> completeChallenge(
    _is.DatabaseSession session,
    EmailAccountOtpLoginRequest emailAccountOtpLoginRequest, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountOtpLoginRequest.id == null) {
      throw ArgumentError.notNull('emailAccountOtpLoginRequest.id');
    }

    var $emailAccountOtpLoginRequest = emailAccountOtpLoginRequest.copyWith(
      completeChallengeId: null,
    );
    await session.db.updateRow<EmailAccountOtpLoginRequest>(
      $emailAccountOtpLoginRequest,
      columns: [EmailAccountOtpLoginRequest.t.completeChallengeId],
      transaction: transaction,
    );
  }
}
