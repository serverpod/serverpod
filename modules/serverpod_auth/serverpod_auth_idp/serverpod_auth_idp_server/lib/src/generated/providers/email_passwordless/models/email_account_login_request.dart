/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, depend_on_referenced_packages
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import '../../../common/secret_challenge/models/secret_challenge.dart'
    as _i7k1fa50;

/// Pending passwordless login request for an email address.
///
/// Created by `startLogin` of the passwordless email identity provider (see
/// https://github.com/serverpod/serverpod/issues/2100). The request is
/// deleted once its code has been used successfully, too many verification
/// attempts have been made, or the request has expired.
abstract class EmailAccountLoginRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  EmailAccountLoginRequest._({
    this.id,
    DateTime? createdAt,
    required this.email,
    required this.challengeId,
    this.challenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EmailAccountLoginRequest({
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
  }) = _EmailAccountLoginRequestImpl;

  factory EmailAccountLoginRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountLoginRequest(
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
    );
  }

  static final t = EmailAccountLoginRequestTable();

  static const db = EmailAccountLoginRequestRepository._();

  @override
  _is.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  _is.UuidValue challengeId;

  /// The associated challenge holding the hash of the verification code.
  _i7k1fa50.SecretChallenge? challenge;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccountLoginRequest copyWith({
    _is.UuidValue? id = const _issu.$UndefinedUuidValue(),
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge =
        const _UndefinedEmailAccountLoginRequest$challenge(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountLoginRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'email': email,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountLoginRequestInclude include({
    _i7k1fa50.SecretChallengeInclude? challenge,
  }) {
    return EmailAccountLoginRequestInclude._(challenge: challenge);
  }

  static EmailAccountLoginRequestIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    EmailAccountLoginRequestInclude? include,
  }) {
    return EmailAccountLoginRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedEmailAccountLoginRequest$challenge
    extends _issu.UndefinedSentinel
    implements _i7k1fa50.SecretChallenge {
  const _UndefinedEmailAccountLoginRequest$challenge();
}

class _EmailAccountLoginRequestImpl extends EmailAccountLoginRequest {
  _EmailAccountLoginRequestImpl({
    _is.UuidValue? id,
    DateTime? createdAt,
    required String email,
    required _is.UuidValue challengeId,
    _i7k1fa50.SecretChallenge? challenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         email: email,
         challengeId: challengeId,
         challenge: challenge,
       );

  /// Returns a shallow copy of this [EmailAccountLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAccountLoginRequest copyWith({
    _is.UuidValue? id = const _issu.$UndefinedUuidValue(),
    DateTime? createdAt,
    String? email,
    _is.UuidValue? challengeId,
    _i7k1fa50.SecretChallenge? challenge =
        const _UndefinedEmailAccountLoginRequest$challenge(),
  }) {
    return EmailAccountLoginRequest(
      id: id is _issu.UndefinedSentinel ? this.id : id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _issu.UndefinedSentinel
          ? this.challenge?.copyWith()
          : challenge,
    );
  }
}

class EmailAccountLoginRequestUpdateTable
    extends _is.UpdateTable<EmailAccountLoginRequestTable> {
  EmailAccountLoginRequestUpdateTable(super.table);

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
}

class EmailAccountLoginRequestTable extends _is.Table<_is.UuidValue?> {
  EmailAccountLoginRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account_login_request') {
    updateTable = EmailAccountLoginRequestUpdateTable(this);
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
  }

  late final EmailAccountLoginRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _is.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  late final _is.ColumnUuid challengeId;

  /// The associated challenge holding the hash of the verification code.
  _i7k1fa50.SecretChallengeTable? _challenge;

  _i7k1fa50.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _is.createRelationTable(
      relationFieldName: 'challenge',
      field: EmailAccountLoginRequest.t.challengeId,
      foreignField: _i7k1fa50.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7k1fa50.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    email,
    challengeId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    return null;
  }
}

class EmailAccountLoginRequestInclude extends _is.IncludeObject {
  EmailAccountLoginRequestInclude._({
    _i7k1fa50.SecretChallengeInclude? challenge,
  }) {
    _challenge = challenge;
  }

  _i7k1fa50.SecretChallengeInclude? _challenge;

  @override
  Map<String, _is.Include?> get includes => {'challenge': _challenge};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountLoginRequest.t;
}

class EmailAccountLoginRequestIncludeList extends _is.IncludeList {
  EmailAccountLoginRequestIncludeList._({
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountLoginRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccountLoginRequest.t;
}

class EmailAccountLoginRequestRepository {
  const EmailAccountLoginRequestRepository._();

  final attachRow = const EmailAccountLoginRequestAttachRowRepository._();

  /// Returns a list of [EmailAccountLoginRequest]s matching the given query parameters.
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
  Future<List<EmailAccountLoginRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAccountLoginRequest>(
      where: where?.call(EmailAccountLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [EmailAccountLoginRequest]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `EmailAccountLoginRequest.t`.
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
  _ida.Stream<List<EmailAccountLoginRequest>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    EmailAccountLoginRequestInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<EmailAccountLoginRequest>(
      where: where?.call(EmailAccountLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [EmailAccountLoginRequest] matching the given query parameters.
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
  Future<EmailAccountLoginRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAccountLoginRequest>(
      where: where?.call(EmailAccountLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAccountLoginRequest] by its [id] or null if no such row exists.
  Future<EmailAccountLoginRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    EmailAccountLoginRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAccountLoginRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAccountLoginRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountLoginRequest]s will have their `id` fields set.
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
  Future<List<EmailAccountLoginRequest>> insert(
    _is.DatabaseSession session,
    List<EmailAccountLoginRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAccountLoginRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAccountLoginRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountLoginRequest] will have its `id` field set.
  Future<EmailAccountLoginRequest> insertRow(
    _is.DatabaseSession session,
    EmailAccountLoginRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAccountLoginRequest]s in the list and returns the resulting rows.
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
  /// The returned [EmailAccountLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountLoginRequest>> upsert(
    _is.DatabaseSession session,
    List<EmailAccountLoginRequest> rows, {
    required _is.ColumnSelections<EmailAccountLoginRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountLoginRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAccountLoginRequest>(
      rows,
      conflictColumns: conflictColumns(EmailAccountLoginRequest.t),
      updateColumns: updateColumns?.call(EmailAccountLoginRequest.t),
      updateWhere: updateWhere?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAccountLoginRequest] and returns the resulting row.
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
  /// The returned [EmailAccountLoginRequest] will have its `id` field set.
  Future<EmailAccountLoginRequest?> upsertRow(
    _is.DatabaseSession session,
    EmailAccountLoginRequest row, {
    required _is.ColumnSelections<EmailAccountLoginRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailAccountLoginRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAccountLoginRequest>(
      row,
      conflictColumns: conflictColumns(EmailAccountLoginRequest.t),
      updateColumns: updateColumns?.call(EmailAccountLoginRequest.t),
      updateWhere: updateWhere?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountLoginRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountLoginRequest>> update(
    _is.DatabaseSession session,
    List<EmailAccountLoginRequest> rows, {
    _is.ColumnSelections<EmailAccountLoginRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAccountLoginRequest>(
      rows,
      columns: columns?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAccountLoginRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountLoginRequest> updateRow(
    _is.DatabaseSession session,
    EmailAccountLoginRequest row, {
    _is.ColumnSelections<EmailAccountLoginRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountLoginRequest>(
      row,
      columns: columns?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountLoginRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountLoginRequest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<EmailAccountLoginRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountLoginRequest>(
      id,
      columnValues: columnValues(EmailAccountLoginRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountLoginRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccountLoginRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailAccountLoginRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmailAccountLoginRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAccountLoginRequest>(
      columnValues: columnValues(EmailAccountLoginRequest.t.updateTable),
      where: where(EmailAccountLoginRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAccountLoginRequest]s in the list and returns the deleted rows.
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
  Future<List<EmailAccountLoginRequest>> delete(
    _is.DatabaseSession session,
    List<EmailAccountLoginRequest> rows, {
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAccountLoginRequest>(
      rows,
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAccountLoginRequest].
  Future<EmailAccountLoginRequest> deleteRow(
    _is.DatabaseSession session,
    EmailAccountLoginRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountLoginRequest>(
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
  Future<List<EmailAccountLoginRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountLoginRequestTable> where,
    _is.OrderByBuilder<EmailAccountLoginRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountLoginRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAccountLoginRequest>(
      where: where(EmailAccountLoginRequest.t),
      orderBy: orderBy?.call(EmailAccountLoginRequest.t),
      orderByList: orderByList?.call(EmailAccountLoginRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountLoginRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountLoginRequest>(
      where: where?.call(EmailAccountLoginRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAccountLoginRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountLoginRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAccountLoginRequest>(
      where: where(EmailAccountLoginRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EmailAccountLoginRequestAttachRowRepository {
  const EmailAccountLoginRequestAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountLoginRequest] and [SecretChallenge]
  /// by setting the [EmailAccountLoginRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _is.DatabaseSession session,
    EmailAccountLoginRequest emailAccountLoginRequest,
    _i7k1fa50.SecretChallenge challenge, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccountLoginRequest.id == null) {
      throw ArgumentError.notNull('emailAccountLoginRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $emailAccountLoginRequest = emailAccountLoginRequest.copyWith(
      challengeId: challenge.id,
    );
    await session.db.updateRow<EmailAccountLoginRequest>(
      $emailAccountLoginRequest,
      columns: [EmailAccountLoginRequest.t.challengeId],
      transaction: transaction,
    );
  }
}
