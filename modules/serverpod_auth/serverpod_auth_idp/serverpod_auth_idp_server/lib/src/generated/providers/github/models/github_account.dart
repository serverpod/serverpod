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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;

/// A fully configured GitHub account to be used for logins.
abstract class GitHubAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  GitHubAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
    this.email,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  factory GitHubAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String userIdentifier,
    String? email,
    DateTime? created,
  }) = _GitHubAccountImpl;

  factory GitHubAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return GitHubAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String?,
      created: jsonSerialization['created'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  static final t = GitHubAccountTable();

  static const db = GitHubAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The user identifier given by GitHub for this account.
  String userIdentifier;

  /// The verified email of the user, as received from GitHub.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user's email is not public or verified.
  String? email;

  /// The time when this authentication was created.
  DateTime created;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [GitHubAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GitHubAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? userIdentifier,
    String? email,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.GitHubAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'userIdentifier': userIdentifier,
      if (email != null) 'email': email,
      'created': created.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static GitHubAccountInclude include({
    _iacs.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<GitHubAccountTable>? select,
  }) {
    return GitHubAccountInclude._(
      authUser: authUser,
      selectedColumns: select?.call(GitHubAccount.t),
    );
  }

  static GitHubAccountIncludeList includeList({
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    GitHubAccountInclude? include,
    _is.SelectColumnsBuilder<GitHubAccountTable>? select,
  }) {
    return GitHubAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      include: include,
      selectedColumns: select?.call(GitHubAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GitHubAccountImpl extends GitHubAccount {
  _GitHubAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String userIdentifier,
    String? email,
    DateTime? created,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userIdentifier: userIdentifier,
         email: email,
         created: created,
       );

  /// Returns a shallow copy of this [GitHubAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GitHubAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
    Object? email = _Undefined,
    DateTime? created,
  }) {
    return GitHubAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
    );
  }
}

class GitHubAccountUpdateTable extends _is.UpdateTable<GitHubAccountTable> {
  GitHubAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> created(DateTime value) =>
      _is.ColumnValue(
        table.created,
        value,
      );
}

class GitHubAccountTable extends _is.Table<_is.UuidValue?> {
  GitHubAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_github_account') {
    updateTable = GitHubAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    created = _is.ColumnDateTime(
      'created',
      this,
    );
  }

  late final GitHubAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The user identifier given by GitHub for this account.
  late final _is.ColumnString userIdentifier;

  /// The verified email of the user, as received from GitHub.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user's email is not public or verified.
  late final _is.ColumnString email;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime created;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: GitHubAccount.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    userIdentifier,
    email,
    created,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class GitHubAccountInclude extends _is.IncludeObject {
  GitHubAccountInclude._({
    _iacs.AuthUserInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => GitHubAccount.t;
}

class GitHubAccountIncludeList extends _is.IncludeList {
  GitHubAccountIncludeList._({
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(GitHubAccount.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => GitHubAccount.t;
}

class GitHubAccountRepository {
  const GitHubAccountRepository._();

  final attachRow = const GitHubAccountAttachRowRepository._();

  /// Returns a list of [GitHubAccount]s matching the given query parameters.
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
  Future<List<GitHubAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GitHubAccount] matching the given query parameters.
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
  Future<GitHubAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GitHubAccount] by its [id] or null if no such row exists.
  Future<GitHubAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GitHubAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.SelectColumnsBuilder<GitHubAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(GitHubAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.SelectColumnsBuilder<GitHubAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(GitHubAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    GitHubAccountInclude? include,
    _is.SelectColumnsBuilder<GitHubAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<GitHubAccount>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(GitHubAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GitHubAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [GitHubAccount]s will have their `id` fields set.
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
  Future<List<GitHubAccount>> insert(
    _is.DatabaseSession session,
    List<GitHubAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GitHubAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GitHubAccount] and returns the inserted row.
  ///
  /// The returned [GitHubAccount] will have its `id` field set.
  Future<GitHubAccount> insertRow(
    _is.DatabaseSession session,
    GitHubAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<GitHubAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GitHubAccount]s in the list and returns the resulting rows.
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
  /// The returned [GitHubAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GitHubAccount>> upsert(
    _is.DatabaseSession session,
    List<GitHubAccount> rows, {
    required _is.ColumnSelections<GitHubAccountTable> conflictColumns,
    _is.ColumnSelections<GitHubAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<GitHubAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GitHubAccount>(
      rows,
      conflictColumns: conflictColumns(GitHubAccount.t),
      updateColumns: updateColumns?.call(GitHubAccount.t),
      updateWhere: updateWhere?.call(GitHubAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GitHubAccount] and returns the resulting row.
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
  /// The returned [GitHubAccount] will have its `id` field set.
  Future<GitHubAccount?> upsertRow(
    _is.DatabaseSession session,
    GitHubAccount row, {
    required _is.ColumnSelections<GitHubAccountTable> conflictColumns,
    _is.ColumnSelections<GitHubAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<GitHubAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GitHubAccount>(
      row,
      conflictColumns: conflictColumns(GitHubAccount.t),
      updateColumns: updateColumns?.call(GitHubAccount.t),
      updateWhere: updateWhere?.call(GitHubAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [GitHubAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GitHubAccount>> update(
    _is.DatabaseSession session,
    List<GitHubAccount> rows, {
    _is.ColumnSelections<GitHubAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GitHubAccount>(
      rows,
      columns: columns?.call(GitHubAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GitHubAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GitHubAccount> updateRow(
    _is.DatabaseSession session,
    GitHubAccount row, {
    _is.ColumnSelections<GitHubAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<GitHubAccount>(
      row,
      columns: columns?.call(GitHubAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GitHubAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GitHubAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<GitHubAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<GitHubAccount>(
      id,
      columnValues: columnValues(GitHubAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GitHubAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GitHubAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GitHubAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<GitHubAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GitHubAccount>(
      columnValues: columnValues(GitHubAccount.t.updateTable),
      where: where(GitHubAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GitHubAccount]s in the list and returns the deleted rows.
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
  Future<List<GitHubAccount>> delete(
    _is.DatabaseSession session,
    List<GitHubAccount> rows, {
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GitHubAccount>(
      rows,
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GitHubAccount].
  Future<GitHubAccount> deleteRow(
    _is.DatabaseSession session,
    GitHubAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GitHubAccount>(
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
  Future<List<GitHubAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GitHubAccountTable> where,
    _is.OrderByBuilder<GitHubAccountTable>? orderBy,
    _is.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GitHubAccount>(
      where: where(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GitHubAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GitHubAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GitHubAccount>(
      where: where(GitHubAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GitHubAccountAttachRowRepository {
  const GitHubAccountAttachRowRepository._();

  /// Creates a relation between the given [GitHubAccount] and [AuthUser]
  /// by setting the [GitHubAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    GitHubAccount gitHubAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (gitHubAccount.id == null) {
      throw ArgumentError.notNull('gitHubAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $gitHubAccount = gitHubAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<GitHubAccount>(
      $gitHubAccount,
      columns: [GitHubAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
