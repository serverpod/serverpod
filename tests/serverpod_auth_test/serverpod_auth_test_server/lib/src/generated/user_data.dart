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
import 'package:serverpod_auth_test_server/src/generated/protocol.dart'
    as _ik2mg1i3;

abstract class UserData
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserData._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.displayName,
    this.bio,
  });

  factory UserData({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) = _UserDataImpl;

  factory UserData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserData(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ik2mg1i3.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
    );
  }

  static final t = UserDataTable();

  static const db = UserDataRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// User's display name
  String displayName;

  /// User's bio
  String? bio;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserData copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? displayName,
    String? bio,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'displayName': displayName,
      if (bio != null) 'bio': bio,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'displayName': displayName,
      if (bio != null) 'bio': bio,
    };
  }

  /// Builds a complete [UserDataInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UserDataInclude include({_iacs.AuthUserInclude? authUser}) {
    return UserDataInclude._(authUser: authUser);
  }

  /// Builds a complete [UserDataIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UserDataIncludeList includeList({
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    UserDataInclude? include,
  }) {
    return UserDataIncludeList._(
      where: where?.call(UserData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [UserDataJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static UserDataJsonInclude includeJson({
    _iacs.AuthUserJsonInclude? authUser,
    _is.SelectColumnsBuilder<UserDataTable>? select,
  }) {
    return _UserDataJsonInclude._(
      authUser: authUser,
      selectedColumns: select?.call(UserData.t),
    );
  }

  /// Builds a JSON-compatible [UserDataJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static UserDataJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    UserDataJsonInclude? include,
    _is.SelectColumnsBuilder<UserDataTable>? select,
  }) {
    return _UserDataJsonIncludeList._(
      where: where?.call(UserData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      include: include,
      selectedColumns: select?.call(UserData.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserDataImpl extends UserData {
  _UserDataImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         displayName: displayName,
         bio: bio,
       );

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserData copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? displayName,
    Object? bio = _Undefined,
  }) {
    return UserData(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
    );
  }
}

class UserDataUpdateTable extends _is.UpdateTable<UserDataTable> {
  UserDataUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<String, String> bio(String? value) => _is.ColumnValue(
    table.bio,
    value,
  );
}

class UserDataTable extends _is.Table<int?> {
  UserDataTable({super.tableRelation}) : super(tableName: 'user_data') {
    updateTable = UserDataUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    bio = _is.ColumnString(
      'bio',
      this,
    );
  }

  late final UserDataUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// User's display name
  late final _is.ColumnString displayName;

  /// User's bio
  late final _is.ColumnString bio;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: UserData.t.authUserId,
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
    displayName,
    bio,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

abstract interface class UserDataJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class UserDataJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class UserDataInclude extends _is.IncludeObject
    implements UserDataJsonInclude, _is.FullModelInclude {
  UserDataInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => UserData.t;
}

final class UserDataIncludeList extends _is.IncludeList
    implements UserDataJsonIncludeList, _is.FullModelInclude {
  UserDataIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UserDataInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserData.t;
}

final class _UserDataJsonInclude extends _is.IncludeObject
    implements UserDataJsonInclude {
  _UserDataJsonInclude._({
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
  _is.Table<int?> get table => UserData.t;
}

final class _UserDataJsonIncludeList extends _is.IncludeList
    implements UserDataJsonIncludeList {
  _UserDataJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UserDataJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserData.t;
}

class UserDataRepository {
  const UserDataRepository._();

  final attachRow = const UserDataAttachRowRepository._();

  /// Returns a list of [UserData]s matching the given query parameters.
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
  Future<List<UserData>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    UserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserData] matching the given query parameters.
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
  Future<UserData?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    UserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserData] by its [id] or null if no such row exists.
  Future<UserData?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    UserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserData>(
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
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    UserDataJsonInclude? include,
    _is.SelectColumnsBuilder<UserDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserData.t),
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
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    UserDataJsonInclude? include,
    _is.SelectColumnsBuilder<UserDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(UserData.t),
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
    UserDataJsonInclude? include,
    _is.SelectColumnsBuilder<UserDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserData>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(UserData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserData]s in the list and returns the inserted rows.
  ///
  /// The returned [UserData]s will have their `id` fields set.
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
  Future<List<UserData>> insert(
    _is.DatabaseSession session,
    List<UserData> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserData] and returns the inserted row.
  ///
  /// The returned [UserData] will have its `id` field set.
  Future<UserData> insertRow(
    _is.DatabaseSession session,
    UserData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserData]s in the list and returns the resulting rows.
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
  /// The returned [UserData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserData>> upsert(
    _is.DatabaseSession session,
    List<UserData> rows, {
    required _is.ColumnSelections<UserDataTable> conflictColumns,
    _is.ColumnSelections<UserDataTable>? updateColumns,
    _is.WhereExpressionBuilder<UserDataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserData>(
      rows,
      conflictColumns: conflictColumns(UserData.t),
      updateColumns: updateColumns?.call(UserData.t),
      updateWhere: updateWhere?.call(UserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserData] and returns the resulting row.
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
  /// The returned [UserData] will have its `id` field set.
  Future<UserData?> upsertRow(
    _is.DatabaseSession session,
    UserData row, {
    required _is.ColumnSelections<UserDataTable> conflictColumns,
    _is.ColumnSelections<UserDataTable>? updateColumns,
    _is.WhereExpressionBuilder<UserDataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserData>(
      row,
      conflictColumns: conflictColumns(UserData.t),
      updateColumns: updateColumns?.call(UserData.t),
      updateWhere: updateWhere?.call(UserData.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserData>> update(
    _is.DatabaseSession session,
    List<UserData> rows, {
    _is.ColumnSelections<UserDataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserData>(
      rows,
      columns: columns?.call(UserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserData> updateRow(
    _is.DatabaseSession session,
    UserData row, {
    _is.ColumnSelections<UserDataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserData>(
      row,
      columns: columns?.call(UserData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserData?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserDataUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserData>(
      id,
      columnValues: columnValues(UserData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserData>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserDataUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserDataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserData>(
      columnValues: columnValues(UserData.t.updateTable),
      where: where(UserData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserData]s in the list and returns the deleted rows.
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
  Future<List<UserData>> delete(
    _is.DatabaseSession session,
    List<UserData> rows, {
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserData>(
      rows,
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserData].
  Future<UserData> deleteRow(
    _is.DatabaseSession session,
    UserData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserData>(
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
  Future<List<UserData>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserDataTable> where,
    _is.OrderByBuilder<UserDataTable>? orderBy,
    _is.OrderByListBuilder<UserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserData>(
      where: where(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserData>(
      where: where?.call(UserData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserData] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserDataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserData>(
      where: where(UserData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserDataAttachRowRepository {
  const UserDataAttachRowRepository._();

  /// Creates a relation between the given [UserData] and [AuthUser]
  /// by setting the [UserData]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    UserData userData,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (userData.id == null) {
      throw ArgumentError.notNull('userData.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $userData = userData.copyWith(authUserId: authUser.id);
    await session.db.updateRow<UserData>(
      $userData,
      columns: [UserData.t.authUserId],
      transaction: transaction,
    );
  }
}
