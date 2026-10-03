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
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import '../../auth_user/models/auth_user.dart' as _ivyervu7;

/// An in-progress request to link an additional sign-in method to an [AuthUser].
///
/// Created before the user signs in with the additional identity provider, and
/// completed once that sign-in has been attached and approved. Only one request
/// can be active per user at a time; creating a new one replaces the previous.
abstract class AccountLinkRequest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AccountLinkRequest._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.authId,
    this.linkedAuthUserId,
    this.linkedMethod,
    this.linkedAccountWasCreated,
    DateTime? createdAt,
    required this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AccountLinkRequest({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required String authId,
    _is.UuidValue? linkedAuthUserId,
    String? linkedMethod,
    bool? linkedAccountWasCreated,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) = _AccountLinkRequestImpl;

  factory AccountLinkRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountLinkRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ivyervu7.AuthUser>(
              jsonSerialization['authUser'],
            ),
      authId: jsonSerialization['authId'] as String,
      linkedAuthUserId: jsonSerialization['linkedAuthUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['linkedAuthUserId'],
            ),
      linkedMethod: jsonSerialization['linkedMethod'] as String?,
      linkedAccountWasCreated:
          jsonSerialization['linkedAccountWasCreated'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['linkedAccountWasCreated'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  static final t = AccountLinkRequestTable();

  static const db = AccountLinkRequestRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] that initiated the request. This account is the one kept
  /// when the link is executed.
  _ivyervu7.AuthUser? authUser;

  /// The `authId` of the session that created this request.
  ///
  /// Depending on the token strategy this is either the server-side session's
  /// ID or the JWT refresh token's ID. It ensures that only the device which
  /// started the flow can attach a sign-in to it or execute it, so a concurrent
  /// login on a second device is never absorbed into this request.
  String authId;

  /// The [AuthUser] of the sign-in that was attached to this request.
  ///
  /// This account is merged into [authUser] and then removed when the request is
  /// executed. `null` until a sign-in has been attached.
  ///
  /// Deliberately not a relation: a cascade from the attached user would delete
  /// this request, and a missing user is already reported as an
  /// `AuthUserNotFoundException` by the merge.
  _is.UuidValue? linkedAuthUserId;

  /// The identity provider method of the attached sign-in, for example "google".
  String? linkedMethod;

  /// Whether the attached account was created by the sign-in that attached it.
  ///
  /// If `true` the account cannot hold any application data yet, so the link can
  /// be completed without asking the user to approve a merge.
  bool? linkedAccountWasCreated;

  /// The time when this request was created.
  DateTime createdAt;

  /// The time after which this request can no longer be used.
  ///
  /// Stored on the request rather than derived from [createdAt] so that
  /// validity can be checked without access to the module's configuration.
  DateTime expiresAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AccountLinkRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountLinkRequest copyWith({
    _is.UuidValue? id = const _issu.$UndefinedUuidValue(),
    _is.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser =
        const _UndefinedAccountLinkRequest$authUser(),
    String? authId,
    _is.UuidValue? linkedAuthUserId = const _issu.$UndefinedUuidValue(),
    String? linkedMethod,
    bool? linkedAccountWasCreated,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AccountLinkRequest',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'authId': authId,
      if (linkedAuthUserId != null)
        'linkedAuthUserId': linkedAuthUserId?.toJson(),
      if (linkedMethod != null) 'linkedMethod': linkedMethod,
      if (linkedAccountWasCreated != null)
        'linkedAccountWasCreated': linkedAccountWasCreated,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AccountLinkRequestInclude include({
    _ivyervu7.AuthUserInclude? authUser,
  }) {
    return AccountLinkRequestInclude._(authUser: authUser);
  }

  static AccountLinkRequestIncludeList includeList({
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    AccountLinkRequestInclude? include,
  }) {
    return AccountLinkRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedAccountLinkRequest$authUser extends _issu.UndefinedSentinel
    implements _ivyervu7.AuthUser {
  const _UndefinedAccountLinkRequest$authUser();
}

class _AccountLinkRequestImpl extends AccountLinkRequest {
  _AccountLinkRequestImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required String authId,
    _is.UuidValue? linkedAuthUserId,
    String? linkedMethod,
    bool? linkedAccountWasCreated,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         authId: authId,
         linkedAuthUserId: linkedAuthUserId,
         linkedMethod: linkedMethod,
         linkedAccountWasCreated: linkedAccountWasCreated,
         createdAt: createdAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [AccountLinkRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountLinkRequest copyWith({
    _is.UuidValue? id = const _issu.$UndefinedUuidValue(),
    _is.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser =
        const _UndefinedAccountLinkRequest$authUser(),
    String? authId,
    _is.UuidValue? linkedAuthUserId = const _issu.$UndefinedUuidValue(),
    Object? linkedMethod = _Undefined,
    Object? linkedAccountWasCreated = _Undefined,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return AccountLinkRequest(
      id: id is _issu.UndefinedSentinel ? this.id : id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _issu.UndefinedSentinel
          ? this.authUser?.copyWith()
          : authUser,
      authId: authId ?? this.authId,
      linkedAuthUserId: linkedAuthUserId is _issu.UndefinedSentinel
          ? this.linkedAuthUserId
          : linkedAuthUserId,
      linkedMethod: linkedMethod is String? ? linkedMethod : this.linkedMethod,
      linkedAccountWasCreated: linkedAccountWasCreated is bool?
          ? linkedAccountWasCreated
          : this.linkedAccountWasCreated,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class AccountLinkRequestUpdateTable
    extends _is.UpdateTable<AccountLinkRequestTable> {
  AccountLinkRequestUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> authId(String value) => _is.ColumnValue(
    table.authId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> linkedAuthUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.linkedAuthUserId,
    value,
  );

  _is.ColumnValue<String, String> linkedMethod(String? value) =>
      _is.ColumnValue(
        table.linkedMethod,
        value,
      );

  _is.ColumnValue<bool, bool> linkedAccountWasCreated(bool? value) =>
      _is.ColumnValue(
        table.linkedAccountWasCreated,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );
}

class AccountLinkRequestTable extends _is.Table<_is.UuidValue?> {
  AccountLinkRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_account_link_request') {
    updateTable = AccountLinkRequestUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    authId = _is.ColumnString(
      'authId',
      this,
    );
    linkedAuthUserId = _is.ColumnUuid(
      'linkedAuthUserId',
      this,
    );
    linkedMethod = _is.ColumnString(
      'linkedMethod',
      this,
    );
    linkedAccountWasCreated = _is.ColumnBool(
      'linkedAccountWasCreated',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
  }

  late final AccountLinkRequestUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] that initiated the request. This account is the one kept
  /// when the link is executed.
  _ivyervu7.AuthUserTable? _authUser;

  /// The `authId` of the session that created this request.
  ///
  /// Depending on the token strategy this is either the server-side session's
  /// ID or the JWT refresh token's ID. It ensures that only the device which
  /// started the flow can attach a sign-in to it or execute it, so a concurrent
  /// login on a second device is never absorbed into this request.
  late final _is.ColumnString authId;

  /// The [AuthUser] of the sign-in that was attached to this request.
  ///
  /// This account is merged into [authUser] and then removed when the request is
  /// executed. `null` until a sign-in has been attached.
  ///
  /// Deliberately not a relation: a cascade from the attached user would delete
  /// this request, and a missing user is already reported as an
  /// `AuthUserNotFoundException` by the merge.
  late final _is.ColumnUuid linkedAuthUserId;

  /// The identity provider method of the attached sign-in, for example "google".
  late final _is.ColumnString linkedMethod;

  /// Whether the attached account was created by the sign-in that attached it.
  ///
  /// If `true` the account cannot hold any application data yet, so the link can
  /// be completed without asking the user to approve a merge.
  late final _is.ColumnBool linkedAccountWasCreated;

  /// The time when this request was created.
  late final _is.ColumnDateTime createdAt;

  /// The time after which this request can no longer be used.
  ///
  /// Stored on the request rather than derived from [createdAt] so that
  /// validity can be checked without access to the module's configuration.
  late final _is.ColumnDateTime expiresAt;

  _ivyervu7.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: AccountLinkRequest.t.authUserId,
      foreignField: _ivyervu7.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivyervu7.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    authId,
    linkedAuthUserId,
    linkedMethod,
    linkedAccountWasCreated,
    createdAt,
    expiresAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AccountLinkRequestInclude extends _is.IncludeObject {
  AccountLinkRequestInclude._({_ivyervu7.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _ivyervu7.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => AccountLinkRequest.t;
}

class AccountLinkRequestIncludeList extends _is.IncludeList {
  AccountLinkRequestIncludeList._({
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountLinkRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AccountLinkRequest.t;
}

class AccountLinkRequestRepository {
  const AccountLinkRequestRepository._();

  final attachRow = const AccountLinkRequestAttachRowRepository._();

  /// Returns a list of [AccountLinkRequest]s matching the given query parameters.
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
  Future<List<AccountLinkRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    _is.Transaction? transaction,
    AccountLinkRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountLinkRequest>(
      where: where?.call(AccountLinkRequest.t),
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AccountLinkRequest]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AccountLinkRequest.t`.
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
  _ida.Stream<List<AccountLinkRequest>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    AccountLinkRequestInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AccountLinkRequest>(
      where: where?.call(AccountLinkRequest.t),
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AccountLinkRequest] matching the given query parameters.
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
  Future<AccountLinkRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    _is.Transaction? transaction,
    AccountLinkRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountLinkRequest>(
      where: where?.call(AccountLinkRequest.t),
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountLinkRequest] by its [id] or null if no such row exists.
  Future<AccountLinkRequest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AccountLinkRequestInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountLinkRequest>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountLinkRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountLinkRequest]s will have their `id` fields set.
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
  Future<List<AccountLinkRequest>> insert(
    _is.DatabaseSession session,
    List<AccountLinkRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccountLinkRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccountLinkRequest] and returns the inserted row.
  ///
  /// The returned [AccountLinkRequest] will have its `id` field set.
  Future<AccountLinkRequest> insertRow(
    _is.DatabaseSession session,
    AccountLinkRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountLinkRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccountLinkRequest]s in the list and returns the resulting rows.
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
  /// The returned [AccountLinkRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountLinkRequest>> upsert(
    _is.DatabaseSession session,
    List<AccountLinkRequest> rows, {
    required _is.ColumnSelections<AccountLinkRequestTable> conflictColumns,
    _is.ColumnSelections<AccountLinkRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccountLinkRequest>(
      rows,
      conflictColumns: conflictColumns(AccountLinkRequest.t),
      updateColumns: updateColumns?.call(AccountLinkRequest.t),
      updateWhere: updateWhere?.call(AccountLinkRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccountLinkRequest] and returns the resulting row.
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
  /// The returned [AccountLinkRequest] will have its `id` field set.
  Future<AccountLinkRequest?> upsertRow(
    _is.DatabaseSession session,
    AccountLinkRequest row, {
    required _is.ColumnSelections<AccountLinkRequestTable> conflictColumns,
    _is.ColumnSelections<AccountLinkRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccountLinkRequest>(
      row,
      conflictColumns: conflictColumns(AccountLinkRequest.t),
      updateColumns: updateColumns?.call(AccountLinkRequest.t),
      updateWhere: updateWhere?.call(AccountLinkRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccountLinkRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountLinkRequest>> update(
    _is.DatabaseSession session,
    List<AccountLinkRequest> rows, {
    _is.ColumnSelections<AccountLinkRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccountLinkRequest>(
      rows,
      columns: columns?.call(AccountLinkRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccountLinkRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountLinkRequest> updateRow(
    _is.DatabaseSession session,
    AccountLinkRequest row, {
    _is.ColumnSelections<AccountLinkRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountLinkRequest>(
      row,
      columns: columns?.call(AccountLinkRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountLinkRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountLinkRequest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AccountLinkRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountLinkRequest>(
      id,
      columnValues: columnValues(AccountLinkRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountLinkRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountLinkRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountLinkRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AccountLinkRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccountLinkRequest>(
      columnValues: columnValues(AccountLinkRequest.t.updateTable),
      where: where(AccountLinkRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccountLinkRequest]s in the list and returns the deleted rows.
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
  Future<List<AccountLinkRequest>> delete(
    _is.DatabaseSession session,
    List<AccountLinkRequest> rows, {
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccountLinkRequest>(
      rows,
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccountLinkRequest].
  Future<AccountLinkRequest> deleteRow(
    _is.DatabaseSession session,
    AccountLinkRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountLinkRequest>(
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
  Future<List<AccountLinkRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountLinkRequestTable> where,
    _is.OrderByBuilder<AccountLinkRequestTable>? orderBy,
    _is.OrderByListBuilder<AccountLinkRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccountLinkRequest>(
      where: where(AccountLinkRequest.t),
      orderBy: orderBy?.call(AccountLinkRequest.t),
      orderByList: orderByList?.call(AccountLinkRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountLinkRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccountLinkRequest>(
      where: where?.call(AccountLinkRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountLinkRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountLinkRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountLinkRequest>(
      where: where(AccountLinkRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AccountLinkRequestAttachRowRepository {
  const AccountLinkRequestAttachRowRepository._();

  /// Creates a relation between the given [AccountLinkRequest] and [AuthUser]
  /// by setting the [AccountLinkRequest]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    AccountLinkRequest accountLinkRequest,
    _ivyervu7.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (accountLinkRequest.id == null) {
      throw ArgumentError.notNull('accountLinkRequest.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $accountLinkRequest = accountLinkRequest.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<AccountLinkRequest>(
      $accountLinkRequest,
      columns: [AccountLinkRequest.t.authUserId],
      transaction: transaction,
    );
  }
}
