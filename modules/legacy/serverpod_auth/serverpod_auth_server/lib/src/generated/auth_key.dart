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
import 'package:serverpod_auth_server/src/generated/protocol.dart' as _i4k4nnr6;

/// Provides a method of access for a user to authenticate with the server.
abstract class AuthKey
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AuthKey._({
    this.id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  });

  factory AuthKey({
    int? id,
    required int userId,
    required String hash,
    String? key,
    required List<String> scopeNames,
    required String method,
  }) = _AuthKeyImpl;

  factory AuthKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthKey(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      hash: jsonSerialization['hash'] as String,
      key: jsonSerialization['key'] as String?,
      scopeNames: _i4k4nnr6.Protocol().deserialize<List<String>>(
        jsonSerialization['scopeNames'],
      ),
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = AuthKeyTable();

  static const db = AuthKeyRepository._();

  @override
  int? id;

  /// The id of the user to provide access to.
  int userId;

  /// The hashed version of the key.
  String hash;

  /// The key sent to the server to authenticate.
  String? key;

  /// The scopes this key provides access to.
  List<String> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  String method;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthKey copyWith({
    int? id,
    int? userId,
    String? hash,
    String? key,
    List<String>? scopeNames,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.AuthKey',
      if (id != null) 'id': id,
      'userId': userId,
      'hash': hash,
      if (key != null) 'key': key,
      'scopeNames': scopeNames.toJson(),
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.AuthKey',
      if (id != null) 'id': id,
      'userId': userId,
      'hash': hash,
      if (key != null) 'key': key,
      'scopeNames': scopeNames.toJson(),
      'method': method,
    };
  }

  /// Builds a complete [AuthKeyInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static AuthKeyInclude include() {
    return AuthKeyInclude._();
  }

  /// Builds a complete [AuthKeyIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static AuthKeyIncludeList includeList({
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    AuthKeyInclude? include,
  }) {
    return AuthKeyIncludeList._(
      where: where?.call(AuthKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [AuthKeyJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static AuthKeyJsonInclude includeJson({
    _is.SelectColumnsBuilder<AuthKeyTable>? select,
  }) {
    return _AuthKeyJsonInclude._(selectedColumns: select?.call(AuthKey.t));
  }

  /// Builds a JSON-compatible [AuthKeyJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static AuthKeyJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    AuthKeyJsonInclude? include,
    _is.SelectColumnsBuilder<AuthKeyTable>? select,
  }) {
    return _AuthKeyJsonIncludeList._(
      where: where?.call(AuthKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      include: include,
      selectedColumns: select?.call(AuthKey.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthKeyImpl extends AuthKey {
  _AuthKeyImpl({
    int? id,
    required int userId,
    required String hash,
    String? key,
    required List<String> scopeNames,
    required String method,
  }) : super._(
         id: id,
         userId: userId,
         hash: hash,
         key: key,
         scopeNames: scopeNames,
         method: method,
       );

  /// Returns a shallow copy of this [AuthKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthKey copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hash,
    Object? key = _Undefined,
    List<String>? scopeNames,
    String? method,
  }) {
    return AuthKey(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
      key: key is String? ? key : this.key,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toList(),
      method: method ?? this.method,
    );
  }
}

class AuthKeyUpdateTable extends _is.UpdateTable<AuthKeyTable> {
  AuthKeyUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> hash(String value) => _is.ColumnValue(
    table.hash,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> scopeNames(List<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<String, String> method(String value) => _is.ColumnValue(
    table.method,
    value,
  );
}

class AuthKeyTable extends _is.Table<int?> {
  AuthKeyTable({super.tableRelation}) : super(tableName: 'serverpod_auth_key') {
    updateTable = AuthKeyUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    hash = _is.ColumnString(
      'hash',
      this,
    );
    scopeNames = _is.ColumnSerializable<List<String>>(
      'scopeNames',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
  }

  late final AuthKeyUpdateTable updateTable;

  /// The id of the user to provide access to.
  late final _is.ColumnInt userId;

  /// The hashed version of the key.
  late final _is.ColumnString hash;

  /// The scopes this key provides access to.
  late final _is.ColumnSerializable<List<String>> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  late final _is.ColumnString method;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    hash,
    scopeNames,
    method,
  ];
}

abstract interface class AuthKeyJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class AuthKeyJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class AuthKeyInclude extends _is.IncludeObject
    implements AuthKeyJsonInclude, _is.FullModelInclude {
  AuthKeyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AuthKey.t;
}

final class AuthKeyIncludeList extends _is.IncludeList
    implements AuthKeyJsonIncludeList, _is.FullModelInclude {
  AuthKeyIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    AuthKeyInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AuthKey.t;
}

final class _AuthKeyJsonInclude extends _is.IncludeObject
    implements AuthKeyJsonInclude {
  _AuthKeyJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AuthKey.t;
}

final class _AuthKeyJsonIncludeList extends _is.IncludeList
    implements AuthKeyJsonIncludeList {
  _AuthKeyJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    AuthKeyJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AuthKey.t;
}

class AuthKeyRepository {
  const AuthKeyRepository._();

  /// Returns a list of [AuthKey]s matching the given query parameters.
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
  Future<List<AuthKey>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuthKey>(
      where: where?.call(AuthKey.t),
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuthKey] matching the given query parameters.
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
  Future<AuthKey?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuthKey>(
      where: where?.call(AuthKey.t),
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuthKey] by its [id] or null if no such row exists.
  Future<AuthKey?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuthKey>(
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
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<AuthKeyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<AuthKey>(
      where: where?.call(AuthKey.t),
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(AuthKey.t),
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
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<AuthKeyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<AuthKey>(
      where: where?.call(AuthKey.t),
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(AuthKey.t),
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
    _is.SelectColumnsBuilder<AuthKeyTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<AuthKey>(
      id,
      transaction: transaction,
      select: select?.call(AuthKey.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuthKey]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthKey]s will have their `id` fields set.
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
  Future<List<AuthKey>> insert(
    _is.DatabaseSession session,
    List<AuthKey> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuthKey>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuthKey] and returns the inserted row.
  ///
  /// The returned [AuthKey] will have its `id` field set.
  Future<AuthKey> insertRow(
    _is.DatabaseSession session,
    AuthKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthKey>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuthKey]s in the list and returns the resulting rows.
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
  /// The returned [AuthKey]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthKey>> upsert(
    _is.DatabaseSession session,
    List<AuthKey> rows, {
    required _is.ColumnSelections<AuthKeyTable> conflictColumns,
    _is.ColumnSelections<AuthKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthKeyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuthKey>(
      rows,
      conflictColumns: conflictColumns(AuthKey.t),
      updateColumns: updateColumns?.call(AuthKey.t),
      updateWhere: updateWhere?.call(AuthKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuthKey] and returns the resulting row.
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
  /// The returned [AuthKey] will have its `id` field set.
  Future<AuthKey?> upsertRow(
    _is.DatabaseSession session,
    AuthKey row, {
    required _is.ColumnSelections<AuthKeyTable> conflictColumns,
    _is.ColumnSelections<AuthKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthKeyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuthKey>(
      row,
      conflictColumns: conflictColumns(AuthKey.t),
      updateColumns: updateColumns?.call(AuthKey.t),
      updateWhere: updateWhere?.call(AuthKey.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuthKey]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthKey>> update(
    _is.DatabaseSession session,
    List<AuthKey> rows, {
    _is.ColumnSelections<AuthKeyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuthKey>(
      rows,
      columns: columns?.call(AuthKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuthKey]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthKey> updateRow(
    _is.DatabaseSession session,
    AuthKey row, {
    _is.ColumnSelections<AuthKeyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthKey>(
      row,
      columns: columns?.call(AuthKey.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthKey] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuthKey?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AuthKeyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuthKey>(
      id,
      columnValues: columnValues(AuthKey.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuthKey]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthKey>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuthKeyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuthKeyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuthKey>(
      columnValues: columnValues(AuthKey.t.updateTable),
      where: where(AuthKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuthKey]s in the list and returns the deleted rows.
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
  Future<List<AuthKey>> delete(
    _is.DatabaseSession session,
    List<AuthKey> rows, {
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuthKey>(
      rows,
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuthKey].
  Future<AuthKey> deleteRow(
    _is.DatabaseSession session,
    AuthKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthKey>(
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
  Future<List<AuthKey>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthKeyTable> where,
    _is.OrderByBuilder<AuthKeyTable>? orderBy,
    _is.OrderByListBuilder<AuthKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuthKey>(
      where: where(AuthKey.t),
      orderBy: orderBy?.call(AuthKey.t),
      orderByList: orderByList?.call(AuthKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthKeyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuthKey>(
      where: where?.call(AuthKey.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuthKey] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthKeyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuthKey>(
      where: where(AuthKey.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
