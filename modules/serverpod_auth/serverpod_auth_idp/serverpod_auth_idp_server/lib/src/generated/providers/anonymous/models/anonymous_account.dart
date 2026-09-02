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

/// A shell account. Persists as long as the user remains logged in,
/// but can never restore this session if the user logs out or loses access
/// to their device.
abstract class AnonymousAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AnonymousAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AnonymousAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
  }) = _AnonymousAccountImpl;

  factory AnonymousAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousAccount(
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
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AnonymousAccountTable();

  static const db = AnonymousAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AnonymousAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AnonymousAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.AnonymousAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AnonymousAccountInclude include({_iacs.AuthUserInclude? authUser}) {
    return AnonymousAccountInclude._(authUser: authUser);
  }

  static AnonymousAccountIncludeList includeList({
    _is.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    AnonymousAccountInclude? include,
  }) {
    return AnonymousAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousAccountImpl extends AnonymousAccount {
  _AnonymousAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AnonymousAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AnonymousAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
  }) {
    return AnonymousAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AnonymousAccountUpdateTable
    extends _is.UpdateTable<AnonymousAccountTable> {
  AnonymousAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AnonymousAccountTable extends _is.Table<_is.UuidValue?> {
  AnonymousAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_anonymous_account') {
    updateTable = AnonymousAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AnonymousAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime createdAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: AnonymousAccount.t.authUserId,
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
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AnonymousAccountInclude extends _is.IncludeObject {
  AnonymousAccountInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => AnonymousAccount.t;
}

class AnonymousAccountIncludeList extends _is.IncludeList {
  AnonymousAccountIncludeList._({
    _is.WhereExpressionBuilder<AnonymousAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnonymousAccount.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AnonymousAccount.t;
}

class AnonymousAccountRepository {
  const AnonymousAccountRepository._();

  final attachRow = const AnonymousAccountAttachRowRepository._();

  /// Returns a list of [AnonymousAccount]s matching the given query parameters.
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
  Future<List<AnonymousAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _is.Transaction? transaction,
    AnonymousAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AnonymousAccount] matching the given query parameters.
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
  Future<AnonymousAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _is.Transaction? transaction,
    AnonymousAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AnonymousAccount] by its [id] or null if no such row exists.
  Future<AnonymousAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AnonymousAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AnonymousAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AnonymousAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [AnonymousAccount]s will have their `id` fields set.
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
  Future<List<AnonymousAccount>> insert(
    _is.DatabaseSession session,
    List<AnonymousAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AnonymousAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AnonymousAccount] and returns the inserted row.
  ///
  /// The returned [AnonymousAccount] will have its `id` field set.
  Future<AnonymousAccount> insertRow(
    _is.DatabaseSession session,
    AnonymousAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnonymousAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AnonymousAccount]s in the list and returns the resulting rows.
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
  /// The returned [AnonymousAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnonymousAccount>> upsert(
    _is.DatabaseSession session,
    List<AnonymousAccount> rows, {
    required _is.ColumnSelections<AnonymousAccountTable> conflictColumns,
    _is.ColumnSelections<AnonymousAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AnonymousAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AnonymousAccount>(
      rows,
      conflictColumns: conflictColumns(AnonymousAccount.t),
      updateColumns: updateColumns?.call(AnonymousAccount.t),
      updateWhere: updateWhere?.call(AnonymousAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AnonymousAccount] and returns the resulting row.
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
  /// The returned [AnonymousAccount] will have its `id` field set.
  Future<AnonymousAccount?> upsertRow(
    _is.DatabaseSession session,
    AnonymousAccount row, {
    required _is.ColumnSelections<AnonymousAccountTable> conflictColumns,
    _is.ColumnSelections<AnonymousAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AnonymousAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AnonymousAccount>(
      row,
      conflictColumns: conflictColumns(AnonymousAccount.t),
      updateColumns: updateColumns?.call(AnonymousAccount.t),
      updateWhere: updateWhere?.call(AnonymousAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnonymousAccount>> update(
    _is.DatabaseSession session,
    List<AnonymousAccount> rows, {
    _is.ColumnSelections<AnonymousAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AnonymousAccount>(
      rows,
      columns: columns?.call(AnonymousAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AnonymousAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnonymousAccount> updateRow(
    _is.DatabaseSession session,
    AnonymousAccount row, {
    _is.ColumnSelections<AnonymousAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnonymousAccount>(
      row,
      columns: columns?.call(AnonymousAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AnonymousAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AnonymousAccountUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AnonymousAccount>(
      id,
      columnValues: columnValues(AnonymousAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnonymousAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AnonymousAccountUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AnonymousAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AnonymousAccount>(
      columnValues: columnValues(AnonymousAccount.t.updateTable),
      where: where(AnonymousAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AnonymousAccount]s in the list and returns the deleted rows.
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
  Future<List<AnonymousAccount>> delete(
    _is.DatabaseSession session,
    List<AnonymousAccount> rows, {
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AnonymousAccount>(
      rows,
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AnonymousAccount].
  Future<AnonymousAccount> deleteRow(
    _is.DatabaseSession session,
    AnonymousAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnonymousAccount>(
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
  Future<List<AnonymousAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AnonymousAccountTable> where,
    _is.OrderByBuilder<AnonymousAccountTable>? orderBy,
    _is.OrderByListBuilder<AnonymousAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AnonymousAccount>(
      where: where(AnonymousAccount.t),
      orderBy: orderBy?.call(AnonymousAccount.t),
      orderByList: orderByList?.call(AnonymousAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnonymousAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AnonymousAccount>(
      where: where?.call(AnonymousAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AnonymousAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AnonymousAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AnonymousAccount>(
      where: where(AnonymousAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AnonymousAccountAttachRowRepository {
  const AnonymousAccountAttachRowRepository._();

  /// Creates a relation between the given [AnonymousAccount] and [AuthUser]
  /// by setting the [AnonymousAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    AnonymousAccount anonymousAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (anonymousAccount.id == null) {
      throw ArgumentError.notNull('anonymousAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $anonymousAccount = anonymousAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AnonymousAccount>(
      $anonymousAccount,
      columns: [AnonymousAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
