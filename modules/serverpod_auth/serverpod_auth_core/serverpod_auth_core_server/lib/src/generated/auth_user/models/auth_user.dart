/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;

/// Core database entity representing a user in the authentication system.
///
/// This class is meant to be used only to interact with the database. To transfer
/// user data, use the [AuthUserModel] DTO.
abstract class AuthUser
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AuthUser._({
    this.id,
    DateTime? createdAt,
    required this.scopeNames,
    bool? blocked,
  }) : createdAt = createdAt ?? DateTime.now(),
       blocked = blocked ?? false;

  factory AuthUser({
    _is.UuidValue? id,
    DateTime? createdAt,
    required Set<String> scopeNames,
    bool? blocked,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      scopeNames: _i8reeoob.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: jsonSerialization['blocked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  static final t = AuthUserTable();

  static const db = AuthUserRepository._();

  @override
  _is.UuidValue? id;

  /// The time when this user was created.
  DateTime createdAt;

  /// Set of scopes that this user can access.
  Set<String> scopeNames;

  /// If `true` the user will be blocked from signing in.
  bool blocked;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthUser copyWith({
    _is.UuidValue? id,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AuthUser',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AuthUser',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  static AuthUserInclude include({
    _is.SelectColumnsBuilder<AuthUserTable>? select,
  }) {
    return AuthUserInclude._(selectedColumns: select?.call(AuthUser.t));
  }

  static AuthUserIncludeList includeList({
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    AuthUserInclude? include,
    _is.SelectColumnsBuilder<AuthUserTable>? select,
  }) {
    return AuthUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      include: include,
      selectedColumns: select?.call(AuthUser.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserImpl extends AuthUser {
  _AuthUserImpl({
    _is.UuidValue? id,
    DateTime? createdAt,
    required Set<String> scopeNames,
    bool? blocked,
  }) : super._(
         id: id,
         createdAt: createdAt,
         scopeNames: scopeNames,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthUser copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  }) {
    return AuthUser(
      id: id is _is.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      blocked: blocked ?? this.blocked,
    );
  }
}

class AuthUserUpdateTable extends _is.UpdateTable<AuthUserTable> {
  AuthUserUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<Set<String>, Set<String>> scopeNames(Set<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<bool, bool> blocked(bool value) => _is.ColumnValue(
    table.blocked,
    value,
  );
}

class AuthUserTable extends _is.Table<_is.UuidValue?> {
  AuthUserTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_user') {
    updateTable = AuthUserUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    scopeNames = _is.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    blocked = _is.ColumnBool(
      'blocked',
      this,
    );
  }

  late final AuthUserUpdateTable updateTable;

  /// The time when this user was created.
  late final _is.ColumnDateTime createdAt;

  /// Set of scopes that this user can access.
  late final _is.ColumnSerializable<Set<String>> scopeNames;

  /// If `true` the user will be blocked from signing in.
  late final _is.ColumnBool blocked;

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    scopeNames,
    blocked,
  ];
}

class AuthUserInclude extends _is.IncludeObject {
  AuthUserInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AuthUser.t;
}

class AuthUserIncludeList extends _is.IncludeList {
  AuthUserIncludeList._({
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(AuthUser.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AuthUser.t;
}

class AuthUserRepository {
  const AuthUserRepository._();

  /// Returns a list of [AuthUser]s matching the given query parameters.
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
  Future<List<AuthUser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuthUser] matching the given query parameters.
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
  Future<AuthUser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuthUser] by its [id] or null if no such row exists.
  Future<AuthUser?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuthUser>(
      id,
      transaction: transaction,
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
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<AuthUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(AuthUser.t),
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
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<AuthUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(AuthUser.t),
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
    _is.SelectColumnsBuilder<AuthUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<AuthUser>(
      id,
      transaction: transaction,
      select: select?.call(AuthUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuthUser]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthUser]s will have their `id` fields set.
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
  Future<List<AuthUser>> insert(
    _is.DatabaseSession session,
    List<AuthUser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuthUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuthUser] and returns the inserted row.
  ///
  /// The returned [AuthUser] will have its `id` field set.
  Future<AuthUser> insertRow(
    _is.DatabaseSession session,
    AuthUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuthUser]s in the list and returns the resulting rows.
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
  /// The returned [AuthUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthUser>> upsert(
    _is.DatabaseSession session,
    List<AuthUser> rows, {
    required _is.ColumnSelections<AuthUserTable> conflictColumns,
    _is.ColumnSelections<AuthUserTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthUserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuthUser>(
      rows,
      conflictColumns: conflictColumns(AuthUser.t),
      updateColumns: updateColumns?.call(AuthUser.t),
      updateWhere: updateWhere?.call(AuthUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuthUser] and returns the resulting row.
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
  /// The returned [AuthUser] will have its `id` field set.
  Future<AuthUser?> upsertRow(
    _is.DatabaseSession session,
    AuthUser row, {
    required _is.ColumnSelections<AuthUserTable> conflictColumns,
    _is.ColumnSelections<AuthUserTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthUserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuthUser>(
      row,
      conflictColumns: conflictColumns(AuthUser.t),
      updateColumns: updateColumns?.call(AuthUser.t),
      updateWhere: updateWhere?.call(AuthUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuthUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthUser>> update(
    _is.DatabaseSession session,
    List<AuthUser> rows, {
    _is.ColumnSelections<AuthUserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuthUser>(
      rows,
      columns: columns?.call(AuthUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuthUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthUser> updateRow(
    _is.DatabaseSession session,
    AuthUser row, {
    _is.ColumnSelections<AuthUserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthUser>(
      row,
      columns: columns?.call(AuthUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuthUser?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AuthUserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuthUser>(
      id,
      columnValues: columnValues(AuthUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuthUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthUser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuthUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuthUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuthUser>(
      columnValues: columnValues(AuthUser.t.updateTable),
      where: where(AuthUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuthUser]s in the list and returns the deleted rows.
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
  Future<List<AuthUser>> delete(
    _is.DatabaseSession session,
    List<AuthUser> rows, {
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuthUser>(
      rows,
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuthUser].
  Future<AuthUser> deleteRow(
    _is.DatabaseSession session,
    AuthUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthUser>(
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
  Future<List<AuthUser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthUserTable> where,
    _is.OrderByBuilder<AuthUserTable>? orderBy,
    _is.OrderByListBuilder<AuthUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuthUser>(
      where: where(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuthUser>(
      where: where?.call(AuthUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuthUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuthUser>(
      where: where(AuthUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
