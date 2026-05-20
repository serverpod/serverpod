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
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../common/secret_challenge/models/secret_challenge.dart' as _i2;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// Pending passwordless login request.
abstract class PasswordlessLoginRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  PasswordlessLoginRequest._({
    this.id,
    DateTime? createdAt,
    required this.handle,
    String? handleType,
    required this.challengeId,
    this.challenge,
  }) : createdAt = createdAt ?? DateTime.now(),
       handleType = handleType ?? 'default';

  factory PasswordlessLoginRequest({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String handle,
    String? handleType,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
  }) = _PasswordlessLoginRequestImpl;

  factory PasswordlessLoginRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasswordlessLoginRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      handle: jsonSerialization['handle'] as String,
      handleType: jsonSerialization['handleType'] as String?,
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      challenge: jsonSerialization['challenge'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SecretChallenge>(
              jsonSerialization['challenge'],
            ),
    );
  }

  static final t = PasswordlessLoginRequestTable();

  static const db = PasswordlessLoginRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this request was created.
  DateTime createdAt;

  /// Login handle for this pending request (e.g., email), a hash (e.g.,
  /// phoneHash), or any other deterministic value the provider can resolve to
  /// an auth user.
  String handle;

  /// Namespace key for the handle (e.g., "default", "email", "sms").
  ///
  /// Passed through to the `sendLoginVerificationCode` and
  /// `resolveAuthUserId` callbacks so integrators can distinguish channels
  /// without parsing the handle string.
  String handleType;

  _i1.UuidValue challengeId;

  /// The single verification challenge for this request.
  _i2.SecretChallenge? challenge;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PasswordlessLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordlessLoginRequest copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    String? handle,
    String? handleType,
    _i1.UuidValue? challengeId,
    _i2.SecretChallenge? challenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.PasswordlessLoginRequest',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'handle': handle,
      'handleType': handleType,
      'challengeId': challengeId.toJson(),
      if (challenge != null) 'challenge': challenge?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PasswordlessLoginRequestInclude include({
    _i2.SecretChallengeInclude? challenge,
  }) {
    return PasswordlessLoginRequestInclude._(challenge: challenge);
  }

  static PasswordlessLoginRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    PasswordlessLoginRequestInclude? include,
  }) {
    return PasswordlessLoginRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasswordlessLoginRequestImpl extends PasswordlessLoginRequest {
  _PasswordlessLoginRequestImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required String handle,
    String? handleType,
    required _i1.UuidValue challengeId,
    _i2.SecretChallenge? challenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         handle: handle,
         handleType: handleType,
         challengeId: challengeId,
         challenge: challenge,
       );

  /// Returns a shallow copy of this [PasswordlessLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordlessLoginRequest copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? handle,
    String? handleType,
    _i1.UuidValue? challengeId,
    Object? challenge = _Undefined,
  }) {
    return PasswordlessLoginRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      handle: handle ?? this.handle,
      handleType: handleType ?? this.handleType,
      challengeId: challengeId ?? this.challengeId,
      challenge: challenge is _i2.SecretChallenge?
          ? challenge
          : this.challenge?.copyWith(),
    );
  }
}

class PasswordlessLoginRequestUpdateTable
    extends _i1.UpdateTable<PasswordlessLoginRequestTable> {
  PasswordlessLoginRequestUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> handle(String value) => _i1.ColumnValue(
    table.handle,
    value,
  );

  _i1.ColumnValue<String, String> handleType(String value) => _i1.ColumnValue(
    table.handleType,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> challengeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.challengeId,
    value,
  );
}

class PasswordlessLoginRequestTable extends _i1.Table<_i1.UuidValue?> {
  PasswordlessLoginRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_passwordless_login_request') {
    updateTable = PasswordlessLoginRequestUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    handle = _i1.ColumnString(
      'handle',
      this,
    );
    handleType = _i1.ColumnString(
      'handleType',
      this,
      hasDefault: true,
    );
    challengeId = _i1.ColumnUuid(
      'challengeId',
      this,
    );
  }

  late final PasswordlessLoginRequestUpdateTable updateTable;

  /// The time when this request was created.
  late final _i1.ColumnDateTime createdAt;

  /// Login handle for this pending request (e.g., email), a hash (e.g.,
  /// phoneHash), or any other deterministic value the provider can resolve to
  /// an auth user.
  late final _i1.ColumnString handle;

  /// Namespace key for the handle (e.g., "default", "email", "sms").
  ///
  /// Passed through to the `sendLoginVerificationCode` and
  /// `resolveAuthUserId` callbacks so integrators can distinguish channels
  /// without parsing the handle string.
  late final _i1.ColumnString handleType;

  late final _i1.ColumnUuid challengeId;

  /// The single verification challenge for this request.
  _i2.SecretChallengeTable? _challenge;

  _i2.SecretChallengeTable get challenge {
    if (_challenge != null) return _challenge!;
    _challenge = _i1.createRelationTable(
      relationFieldName: 'challenge',
      field: PasswordlessLoginRequest.t.challengeId,
      foreignField: _i2.SecretChallenge.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SecretChallengeTable(tableRelation: foreignTableRelation),
    );
    return _challenge!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    handle,
    handleType,
    challengeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'challenge') {
      return challenge;
    }
    return null;
  }
}

class PasswordlessLoginRequestInclude extends _i1.IncludeObject {
  PasswordlessLoginRequestInclude._({_i2.SecretChallengeInclude? challenge}) {
    _challenge = challenge;
  }

  _i2.SecretChallengeInclude? _challenge;

  @override
  Map<String, _i1.Include?> get includes => {'challenge': _challenge};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasswordlessLoginRequest.t;
}

class PasswordlessLoginRequestIncludeList extends _i1.IncludeList {
  PasswordlessLoginRequestIncludeList._({
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PasswordlessLoginRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => PasswordlessLoginRequest.t;
}

class PasswordlessLoginRequestRepository {
  const PasswordlessLoginRequestRepository._();

  final attachRow = const PasswordlessLoginRequestAttachRowRepository._();

  /// Returns a list of [PasswordlessLoginRequest]s matching the given query parameters.
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
  Future<List<PasswordlessLoginRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    PasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PasswordlessLoginRequest>(
      where: where?.call(PasswordlessLoginRequest.t),
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PasswordlessLoginRequest] matching the given query parameters.
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
  Future<PasswordlessLoginRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
    PasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PasswordlessLoginRequest>(
      where: where?.call(PasswordlessLoginRequest.t),
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PasswordlessLoginRequest] by its [id] or null if no such row exists.
  Future<PasswordlessLoginRequest?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PasswordlessLoginRequestInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PasswordlessLoginRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PasswordlessLoginRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [PasswordlessLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PasswordlessLoginRequest>> insert(
    _i1.DatabaseSession session,
    List<PasswordlessLoginRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PasswordlessLoginRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PasswordlessLoginRequest] and returns the inserted row.
  ///
  /// The returned [PasswordlessLoginRequest] will have its `id` field set.
  Future<PasswordlessLoginRequest> insertRow(
    _i1.DatabaseSession session,
    PasswordlessLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PasswordlessLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PasswordlessLoginRequest]s in the list and returns the resulting rows.
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
  /// The returned [PasswordlessLoginRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  Future<List<PasswordlessLoginRequest>> upsert(
    _i1.DatabaseSession session,
    List<PasswordlessLoginRequest> rows, {
    required _i1.ColumnSelections<PasswordlessLoginRequestTable>
    conflictColumns,
    _i1.ColumnSelections<PasswordlessLoginRequestTable>? updateColumns,
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert<PasswordlessLoginRequest>(
      rows,
      conflictColumns: conflictColumns(PasswordlessLoginRequest.t),
      updateColumns: updateColumns?.call(PasswordlessLoginRequest.t),
      updateWhere: updateWhere?.call(PasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Upserts a single [PasswordlessLoginRequest] and returns the resulting row.
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
  /// The returned [PasswordlessLoginRequest] will have its `id` field set.
  Future<PasswordlessLoginRequest?> upsertRow(
    _i1.DatabaseSession session,
    PasswordlessLoginRequest row, {
    required _i1.ColumnSelections<PasswordlessLoginRequestTable>
    conflictColumns,
    _i1.ColumnSelections<PasswordlessLoginRequestTable>? updateColumns,
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PasswordlessLoginRequest>(
      row,
      conflictColumns: conflictColumns(PasswordlessLoginRequest.t),
      updateColumns: updateColumns?.call(PasswordlessLoginRequest.t),
      updateWhere: updateWhere?.call(PasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [PasswordlessLoginRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PasswordlessLoginRequest>> update(
    _i1.DatabaseSession session,
    List<PasswordlessLoginRequest> rows, {
    _i1.ColumnSelections<PasswordlessLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PasswordlessLoginRequest>(
      rows,
      columns: columns?.call(PasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasswordlessLoginRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PasswordlessLoginRequest> updateRow(
    _i1.DatabaseSession session,
    PasswordlessLoginRequest row, {
    _i1.ColumnSelections<PasswordlessLoginRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PasswordlessLoginRequest>(
      row,
      columns: columns?.call(PasswordlessLoginRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasswordlessLoginRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PasswordlessLoginRequest?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PasswordlessLoginRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PasswordlessLoginRequest>(
      id,
      columnValues: columnValues(PasswordlessLoginRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PasswordlessLoginRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PasswordlessLoginRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PasswordlessLoginRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PasswordlessLoginRequest>(
      columnValues: columnValues(PasswordlessLoginRequest.t.updateTable),
      where: where(PasswordlessLoginRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PasswordlessLoginRequest]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PasswordlessLoginRequest>> delete(
    _i1.DatabaseSession session,
    List<PasswordlessLoginRequest> rows, {
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PasswordlessLoginRequest>(
      rows,
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [PasswordlessLoginRequest].
  Future<PasswordlessLoginRequest> deleteRow(
    _i1.DatabaseSession session,
    PasswordlessLoginRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PasswordlessLoginRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<PasswordlessLoginRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable> where,
    _i1.OrderByBuilder<PasswordlessLoginRequestTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<PasswordlessLoginRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PasswordlessLoginRequest>(
      where: where(PasswordlessLoginRequest.t),
      orderBy: orderBy?.call(PasswordlessLoginRequest.t),
      orderByList: orderByList?.call(PasswordlessLoginRequest.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PasswordlessLoginRequest>(
      where: where?.call(PasswordlessLoginRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PasswordlessLoginRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PasswordlessLoginRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PasswordlessLoginRequest>(
      where: where(PasswordlessLoginRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PasswordlessLoginRequestAttachRowRepository {
  const PasswordlessLoginRequestAttachRowRepository._();

  /// Creates a relation between the given [PasswordlessLoginRequest] and [SecretChallenge]
  /// by setting the [PasswordlessLoginRequest]'s foreign key `challengeId` to refer to the [SecretChallenge].
  Future<void> challenge(
    _i1.DatabaseSession session,
    PasswordlessLoginRequest passwordlessLoginRequest,
    _i2.SecretChallenge challenge, {
    _i1.Transaction? transaction,
  }) async {
    if (passwordlessLoginRequest.id == null) {
      throw ArgumentError.notNull('passwordlessLoginRequest.id');
    }
    if (challenge.id == null) {
      throw ArgumentError.notNull('challenge.id');
    }

    var $passwordlessLoginRequest = passwordlessLoginRequest.copyWith(
      challengeId: challenge.id,
    );
    await session.db.updateRow<PasswordlessLoginRequest>(
      $passwordlessLoginRequest,
      columns: [PasswordlessLoginRequest.t.challengeId],
      transaction: transaction,
    );
  }
}
