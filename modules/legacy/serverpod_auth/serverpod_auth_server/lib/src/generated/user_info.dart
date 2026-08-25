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

/// Information about a user. The [UserInfo] should only be shared with the user
/// itself as it may contain sensitive information, such as the users email.
/// If you need to share a user's info with other users, use the
/// [UserInfoPublic] instead. You can retrieve a [UserInfoPublic] through the
/// toPublic() method.
abstract class UserInfo
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserInfo._({
    this.id,
    required this.userIdentifier,
    this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.blocked,
  });

  factory UserInfo({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) = _UserInfoImpl;

  factory UserInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserInfo(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      created: _is.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      scopeNames: _i4k4nnr6.Protocol().deserialize<List<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  static final t = UserInfoTable();

  static const db = UserInfoRepository._();

  @override
  int? id;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  String userIdentifier;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  String? email;

  /// The time when this user was created.
  DateTime created;

  /// A URL to the user's avatar.
  String? imageUrl;

  /// List of scopes that this user can access.
  List<String> scopeNames;

  /// True if the user is blocked from signing in.
  bool blocked;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserInfo copyWith({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
    List<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.UserInfo',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.UserInfo',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  static UserInfoInclude include({
    _is.SelectColumnsBuilder<UserInfoTable>? select,
  }) {
    return UserInfoInclude._(selectedColumns: select?.call(UserInfo.t));
  }

  static UserInfoIncludeList includeList({
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    UserInfoInclude? include,
    _is.SelectColumnsBuilder<UserInfoTable>? select,
  }) {
    return UserInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      include: include,
      selectedColumns: select?.call(UserInfo.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserInfoImpl extends UserInfo {
  _UserInfoImpl({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         userName: userName,
         fullName: fullName,
         email: email,
         created: created,
         imageUrl: imageUrl,
         scopeNames: scopeNames,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [UserInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserInfo copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
    List<String>? scopeNames,
    bool? blocked,
  }) {
    return UserInfo(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toList(),
      blocked: blocked ?? this.blocked,
    );
  }
}

class UserInfoUpdateTable extends _is.UpdateTable<UserInfoTable> {
  UserInfoUpdateTable(super.table);

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> userName(String? value) => _is.ColumnValue(
    table.userName,
    value,
  );

  _is.ColumnValue<String, String> fullName(String? value) => _is.ColumnValue(
    table.fullName,
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

  _is.ColumnValue<String, String> imageUrl(String? value) => _is.ColumnValue(
    table.imageUrl,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> scopeNames(List<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<bool, bool> blocked(bool value) => _is.ColumnValue(
    table.blocked,
    value,
  );
}

class UserInfoTable extends _is.Table<int?> {
  UserInfoTable({super.tableRelation})
    : super(tableName: 'serverpod_user_info') {
    updateTable = UserInfoUpdateTable(this);
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    userName = _is.ColumnString(
      'userName',
      this,
    );
    fullName = _is.ColumnString(
      'fullName',
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
    imageUrl = _is.ColumnString(
      'imageUrl',
      this,
    );
    scopeNames = _is.ColumnSerializable<List<String>>(
      'scopeNames',
      this,
    );
    blocked = _is.ColumnBool(
      'blocked',
      this,
    );
  }

  late final UserInfoUpdateTable updateTable;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  late final _is.ColumnString userIdentifier;

  /// The first name of the user or the user's nickname.
  late final _is.ColumnString userName;

  /// The full name of the user.
  late final _is.ColumnString fullName;

  /// The email of the user.
  late final _is.ColumnString email;

  /// The time when this user was created.
  late final _is.ColumnDateTime created;

  /// A URL to the user's avatar.
  late final _is.ColumnString imageUrl;

  /// List of scopes that this user can access.
  late final _is.ColumnSerializable<List<String>> scopeNames;

  /// True if the user is blocked from signing in.
  late final _is.ColumnBool blocked;

  @override
  List<_is.Column> get columns => [
    id,
    userIdentifier,
    userName,
    fullName,
    email,
    created,
    imageUrl,
    scopeNames,
    blocked,
  ];
}

class UserInfoInclude extends _is.IncludeObject {
  UserInfoInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserInfo.t;
}

class UserInfoIncludeList extends _is.IncludeList {
  UserInfoIncludeList._({
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserInfo.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserInfo.t;
}

class UserInfoRepository {
  const UserInfoRepository._();

  /// Returns a list of [UserInfo]s matching the given query parameters.
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
  Future<List<UserInfo>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserInfo] matching the given query parameters.
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
  Future<UserInfo?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserInfo] by its [id] or null if no such row exists.
  Future<UserInfo?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserInfo>(
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
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UserInfoTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UserInfo.t),
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
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UserInfoTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UserInfo.t),
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
    _is.SelectColumnsBuilder<UserInfoTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserInfo>(
      id,
      transaction: transaction,
      select: select?.call(UserInfo.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [UserInfo]s will have their `id` fields set.
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
  Future<List<UserInfo>> insert(
    _is.DatabaseSession session,
    List<UserInfo> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserInfo>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserInfo] and returns the inserted row.
  ///
  /// The returned [UserInfo] will have its `id` field set.
  Future<UserInfo> insertRow(
    _is.DatabaseSession session,
    UserInfo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserInfo]s in the list and returns the resulting rows.
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
  /// The returned [UserInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserInfo>> upsert(
    _is.DatabaseSession session,
    List<UserInfo> rows, {
    required _is.ColumnSelections<UserInfoTable> conflictColumns,
    _is.ColumnSelections<UserInfoTable>? updateColumns,
    _is.WhereExpressionBuilder<UserInfoTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserInfo>(
      rows,
      conflictColumns: conflictColumns(UserInfo.t),
      updateColumns: updateColumns?.call(UserInfo.t),
      updateWhere: updateWhere?.call(UserInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserInfo] and returns the resulting row.
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
  /// The returned [UserInfo] will have its `id` field set.
  Future<UserInfo?> upsertRow(
    _is.DatabaseSession session,
    UserInfo row, {
    required _is.ColumnSelections<UserInfoTable> conflictColumns,
    _is.ColumnSelections<UserInfoTable>? updateColumns,
    _is.WhereExpressionBuilder<UserInfoTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserInfo>(
      row,
      conflictColumns: conflictColumns(UserInfo.t),
      updateColumns: updateColumns?.call(UserInfo.t),
      updateWhere: updateWhere?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserInfo>> update(
    _is.DatabaseSession session,
    List<UserInfo> rows, {
    _is.ColumnSelections<UserInfoTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserInfo>(
      rows,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserInfo> updateRow(
    _is.DatabaseSession session,
    UserInfo row, {
    _is.ColumnSelections<UserInfoTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserInfo>(
      row,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserInfo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserInfo?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserInfoUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserInfo>(
      id,
      columnValues: columnValues(UserInfo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserInfo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserInfo>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserInfoUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserInfoTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserInfo>(
      columnValues: columnValues(UserInfo.t.updateTable),
      where: where(UserInfo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserInfo]s in the list and returns the deleted rows.
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
  Future<List<UserInfo>> delete(
    _is.DatabaseSession session,
    List<UserInfo> rows, {
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserInfo>(
      rows,
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserInfo].
  Future<UserInfo> deleteRow(
    _is.DatabaseSession session,
    UserInfo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserInfo>(
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
  Future<List<UserInfo>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserInfoTable> where,
    _is.OrderByBuilder<UserInfoTable>? orderBy,
    _is.OrderByListBuilder<UserInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserInfo>(
      where: where(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserInfo>(
      where: where?.call(UserInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserInfo] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserInfoTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserInfo>(
      where: where(UserInfo.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
