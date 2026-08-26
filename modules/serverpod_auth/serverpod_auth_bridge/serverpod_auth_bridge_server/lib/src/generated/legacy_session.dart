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
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart'
    as _isg9n5v0;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

abstract class LegacySession
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LegacySession._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    required this.hash,
    required this.method,
  });

  factory LegacySession({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required Set<String> scopeNames,
    required String hash,
    required String method,
  }) = _LegacySessionImpl;

  factory LegacySession.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegacySession(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _isg9n5v0.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      scopeNames: _isg9n5v0.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      hash: jsonSerialization['hash'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = LegacySessionTable();

  static const db = LegacySessionRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _iacs.AuthUser? authUser;

  /// The scopes this session provides access to.
  Set<String> scopeNames;

  /// The hashed version of the key (as the legacy `AuthKey`)
  String hash;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  String method;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegacySession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LegacySession copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    Set<String>? scopeNames,
    String? hash,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacySession',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      'hash': hash,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  /// Builds a complete [LegacySessionInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static LegacySessionInclude include({_iacs.AuthUserInclude? authUser}) {
    return LegacySessionInclude._(authUser: authUser);
  }

  /// Builds a complete [LegacySessionIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static LegacySessionIncludeList includeList({
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    LegacySessionInclude? include,
  }) {
    return LegacySessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [LegacySessionJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static LegacySessionJsonInclude includeJson({
    _iacs.AuthUserJsonInclude? authUser,
    _is.SelectColumnsBuilder<LegacySessionTable>? select,
  }) {
    return _LegacySessionJsonInclude._(
      authUser: authUser,
      selectedColumns: select?.call(LegacySession.t),
    );
  }

  /// Builds a JSON-compatible [LegacySessionJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static LegacySessionJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    LegacySessionJsonInclude? include,
    _is.SelectColumnsBuilder<LegacySessionTable>? select,
  }) {
    return _LegacySessionJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      include: include,
      selectedColumns: select?.call(LegacySession.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacySessionImpl extends LegacySession {
  _LegacySessionImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required Set<String> scopeNames,
    required String hash,
    required String method,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         scopeNames: scopeNames,
         hash: hash,
         method: method,
       );

  /// Returns a shallow copy of this [LegacySession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LegacySession copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    String? hash,
    String? method,
  }) {
    return LegacySession(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      hash: hash ?? this.hash,
      method: method ?? this.method,
    );
  }
}

class LegacySessionUpdateTable extends _is.UpdateTable<LegacySessionTable> {
  LegacySessionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<Set<String>, Set<String>> scopeNames(Set<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<String, String> hash(String value) => _is.ColumnValue(
    table.hash,
    value,
  );

  _is.ColumnValue<String, String> method(String value) => _is.ColumnValue(
    table.method,
    value,
  );
}

class LegacySessionTable extends _is.Table<int?> {
  LegacySessionTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_bridge_session') {
    updateTable = LegacySessionUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _is.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    hash = _is.ColumnString(
      'hash',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
  }

  late final LegacySessionUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _iacs.AuthUserTable? _authUser;

  /// The scopes this session provides access to.
  late final _is.ColumnSerializable<Set<String>> scopeNames;

  /// The hashed version of the key (as the legacy `AuthKey`)
  late final _is.ColumnString hash;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  late final _is.ColumnString method;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: LegacySession.t.authUserId,
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
    scopeNames,
    hash,
    method,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

abstract interface class LegacySessionJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class LegacySessionJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class LegacySessionInclude extends _is.IncludeObject
    implements LegacySessionJsonInclude, _is.FullModelInclude {
  LegacySessionInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => LegacySession.t;
}

final class LegacySessionIncludeList extends _is.IncludeList
    implements LegacySessionJsonIncludeList, _is.FullModelInclude {
  LegacySessionIncludeList._({
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    LegacySessionInclude? super.include,
  }) {
    super.where = where?.call(LegacySession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LegacySession.t;
}

final class _LegacySessionJsonInclude extends _is.IncludeObject
    implements LegacySessionJsonInclude {
  _LegacySessionJsonInclude._({
    _iacs.AuthUserJsonInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _iacs.AuthUserJsonInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => LegacySession.t;
}

final class _LegacySessionJsonIncludeList extends _is.IncludeList
    implements LegacySessionJsonIncludeList {
  _LegacySessionJsonIncludeList._({
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    LegacySessionJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(LegacySession.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LegacySession.t;
}

class LegacySessionRepository {
  const LegacySessionRepository._();

  final attachRow = const LegacySessionAttachRowRepository._();

  /// Returns a list of [LegacySession]s matching the given query parameters.
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
  Future<List<LegacySession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    LegacySessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LegacySession] matching the given query parameters.
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
  Future<LegacySession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    LegacySessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LegacySession] by its [id] or null if no such row exists.
  Future<LegacySession?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    LegacySessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LegacySession>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    LegacySessionJsonInclude? include,
    _is.SelectColumnsBuilder<LegacySessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(LegacySession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    LegacySessionJsonInclude? include,
    _is.SelectColumnsBuilder<LegacySessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(LegacySession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    LegacySessionJsonInclude? include,
    _is.SelectColumnsBuilder<LegacySessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<LegacySession>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(LegacySession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LegacySession]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacySession]s will have their `id` fields set.
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
  Future<List<LegacySession>> insert(
    _is.DatabaseSession session,
    List<LegacySession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LegacySession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LegacySession] and returns the inserted row.
  ///
  /// The returned [LegacySession] will have its `id` field set.
  Future<LegacySession> insertRow(
    _is.DatabaseSession session,
    LegacySession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacySession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LegacySession]s in the list and returns the resulting rows.
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
  /// The returned [LegacySession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacySession>> upsert(
    _is.DatabaseSession session,
    List<LegacySession> rows, {
    required _is.ColumnSelections<LegacySessionTable> conflictColumns,
    _is.ColumnSelections<LegacySessionTable>? updateColumns,
    _is.WhereExpressionBuilder<LegacySessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LegacySession>(
      rows,
      conflictColumns: conflictColumns(LegacySession.t),
      updateColumns: updateColumns?.call(LegacySession.t),
      updateWhere: updateWhere?.call(LegacySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LegacySession] and returns the resulting row.
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
  /// The returned [LegacySession] will have its `id` field set.
  Future<LegacySession?> upsertRow(
    _is.DatabaseSession session,
    LegacySession row, {
    required _is.ColumnSelections<LegacySessionTable> conflictColumns,
    _is.ColumnSelections<LegacySessionTable>? updateColumns,
    _is.WhereExpressionBuilder<LegacySessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LegacySession>(
      row,
      conflictColumns: conflictColumns(LegacySession.t),
      updateColumns: updateColumns?.call(LegacySession.t),
      updateWhere: updateWhere?.call(LegacySession.t),
      transaction: transaction,
    );
  }

  /// Updates all [LegacySession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacySession>> update(
    _is.DatabaseSession session,
    List<LegacySession> rows, {
    _is.ColumnSelections<LegacySessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LegacySession>(
      rows,
      columns: columns?.call(LegacySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LegacySession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacySession> updateRow(
    _is.DatabaseSession session,
    LegacySession row, {
    _is.ColumnSelections<LegacySessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacySession>(
      row,
      columns: columns?.call(LegacySession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacySession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegacySession?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LegacySessionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LegacySession>(
      id,
      columnValues: columnValues(LegacySession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegacySession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacySession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LegacySessionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LegacySessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LegacySession>(
      columnValues: columnValues(LegacySession.t.updateTable),
      where: where(LegacySession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LegacySession]s in the list and returns the deleted rows.
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
  Future<List<LegacySession>> delete(
    _is.DatabaseSession session,
    List<LegacySession> rows, {
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LegacySession>(
      rows,
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LegacySession].
  Future<LegacySession> deleteRow(
    _is.DatabaseSession session,
    LegacySession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacySession>(
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
  Future<List<LegacySession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegacySessionTable> where,
    _is.OrderByBuilder<LegacySessionTable>? orderBy,
    _is.OrderByListBuilder<LegacySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LegacySession>(
      where: where(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LegacySession>(
      where: where?.call(LegacySession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LegacySession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegacySessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LegacySession>(
      where: where(LegacySession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class LegacySessionAttachRowRepository {
  const LegacySessionAttachRowRepository._();

  /// Creates a relation between the given [LegacySession] and [AuthUser]
  /// by setting the [LegacySession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    LegacySession legacySession,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (legacySession.id == null) {
      throw ArgumentError.notNull('legacySession.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $legacySession = legacySession.copyWith(authUserId: authUser.id);
    await session.db.updateRow<LegacySession>(
      $legacySession,
      columns: [LegacySession.t.authUserId],
      transaction: transaction,
    );
  }
}
