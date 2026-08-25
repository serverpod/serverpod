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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;

abstract class ObjectUser
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectUser._({
    this.id,
    this.name,
    required this.userInfoId,
    this.userInfo,
  });

  factory ObjectUser({
    int? id,
    String? name,
    required int userInfoId,
    _i1n3uhu0.UserInfo? userInfo,
  }) = _ObjectUserImpl;

  factory ObjectUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i1n3uhu0.UserInfo>(
              jsonSerialization['userInfo'],
            ),
    );
  }

  static final t = ObjectUserTable();

  static const db = ObjectUserRepository._();

  @override
  int? id;

  String? name;

  int userInfoId;

  _i1n3uhu0.UserInfo? userInfo;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
    _i1n3uhu0.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectUser',
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectUser',
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  static ObjectUserInclude include({
    _i1n3uhu0.UserInfoInclude? userInfo,
    _is.SelectColumnsBuilder<ObjectUserTable>? select,
  }) {
    return ObjectUserInclude._(
      userInfo: userInfo,
      selectedColumns: select?.call(ObjectUser.t),
    );
  }

  static ObjectUserIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    ObjectUserInclude? include,
    _is.SelectColumnsBuilder<ObjectUserTable>? select,
  }) {
    return ObjectUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      include: include,
      selectedColumns: select?.call(ObjectUser.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectUserImpl extends ObjectUser {
  _ObjectUserImpl({
    int? id,
    String? name,
    required int userInfoId,
    _i1n3uhu0.UserInfo? userInfo,
  }) : super._(
         id: id,
         name: name,
         userInfoId: userInfoId,
         userInfo: userInfo,
       );

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectUser copyWith({
    Object? id = _Undefined,
    Object? name = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
  }) {
    return ObjectUser(
      id: id is int? ? id : this.id,
      name: name is String? ? name : this.name,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo: userInfo is _i1n3uhu0.UserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
    );
  }
}

class ObjectUserUpdateTable extends _is.UpdateTable<ObjectUserTable> {
  ObjectUserUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String? value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> userInfoId(int value) => _is.ColumnValue(
    table.userInfoId,
    value,
  );
}

class ObjectUserTable extends _is.Table<int?> {
  ObjectUserTable({super.tableRelation}) : super(tableName: 'object_user') {
    updateTable = ObjectUserUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    userInfoId = _is.ColumnInt(
      'userInfoId',
      this,
    );
  }

  late final ObjectUserUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt userInfoId;

  _i1n3uhu0.UserInfoTable? _userInfo;

  _i1n3uhu0.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _is.createRelationTable(
      relationFieldName: 'userInfo',
      field: ObjectUser.t.userInfoId,
      foreignField: _i1n3uhu0.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i1n3uhu0.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    userInfoId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    return null;
  }
}

class ObjectUserInclude extends _is.IncludeObject {
  ObjectUserInclude._({
    _i1n3uhu0.UserInfoInclude? userInfo,
    this.selectedColumns,
  }) {
    _userInfo = userInfo;
  }

  _i1n3uhu0.UserInfoInclude? _userInfo;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'userInfo': _userInfo};

  @override
  _is.Table<int?> get table => ObjectUser.t;
}

class ObjectUserIncludeList extends _is.IncludeList {
  ObjectUserIncludeList._({
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectUser.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectUser.t;
}

class ObjectUserRepository {
  const ObjectUserRepository._();

  final attachRow = const ObjectUserAttachRowRepository._();

  /// Returns a list of [ObjectUser]s matching the given query parameters.
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
  Future<List<ObjectUser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectUser] matching the given query parameters.
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
  Future<ObjectUser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectUser] by its [id] or null if no such row exists.
  Future<ObjectUser?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectUser>(
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

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.SelectColumnsBuilder<ObjectUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ObjectUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.SelectColumnsBuilder<ObjectUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ObjectUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    ObjectUserInclude? include,
    _is.SelectColumnsBuilder<ObjectUserTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectUser>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ObjectUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectUser]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectUser]s will have their `id` fields set.
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
  Future<List<ObjectUser>> insert(
    _is.DatabaseSession session,
    List<ObjectUser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectUser] and returns the inserted row.
  ///
  /// The returned [ObjectUser] will have its `id` field set.
  Future<ObjectUser> insertRow(
    _is.DatabaseSession session,
    ObjectUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectUser]s in the list and returns the resulting rows.
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
  /// The returned [ObjectUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectUser>> upsert(
    _is.DatabaseSession session,
    List<ObjectUser> rows, {
    required _is.ColumnSelections<ObjectUserTable> conflictColumns,
    _is.ColumnSelections<ObjectUserTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectUserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectUser>(
      rows,
      conflictColumns: conflictColumns(ObjectUser.t),
      updateColumns: updateColumns?.call(ObjectUser.t),
      updateWhere: updateWhere?.call(ObjectUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectUser] and returns the resulting row.
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
  /// The returned [ObjectUser] will have its `id` field set.
  Future<ObjectUser?> upsertRow(
    _is.DatabaseSession session,
    ObjectUser row, {
    required _is.ColumnSelections<ObjectUserTable> conflictColumns,
    _is.ColumnSelections<ObjectUserTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectUserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectUser>(
      row,
      conflictColumns: conflictColumns(ObjectUser.t),
      updateColumns: updateColumns?.call(ObjectUser.t),
      updateWhere: updateWhere?.call(ObjectUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectUser>> update(
    _is.DatabaseSession session,
    List<ObjectUser> rows, {
    _is.ColumnSelections<ObjectUserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectUser>(
      rows,
      columns: columns?.call(ObjectUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectUser> updateRow(
    _is.DatabaseSession session,
    ObjectUser row, {
    _is.ColumnSelections<ObjectUserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectUser>(
      row,
      columns: columns?.call(ObjectUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectUser?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectUserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectUser>(
      id,
      columnValues: columnValues(ObjectUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectUser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ObjectUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectUser>(
      columnValues: columnValues(ObjectUser.t.updateTable),
      where: where(ObjectUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectUser]s in the list and returns the deleted rows.
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
  Future<List<ObjectUser>> delete(
    _is.DatabaseSession session,
    List<ObjectUser> rows, {
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectUser>(
      rows,
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectUser].
  Future<ObjectUser> deleteRow(
    _is.DatabaseSession session,
    ObjectUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectUser>(
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
  Future<List<ObjectUser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectUserTable> where,
    _is.OrderByBuilder<ObjectUserTable>? orderBy,
    _is.OrderByListBuilder<ObjectUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectUser>(
      where: where(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectUser>(
      where: where?.call(ObjectUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectUser>(
      where: where(ObjectUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ObjectUserAttachRowRepository {
  const ObjectUserAttachRowRepository._();

  /// Creates a relation between the given [ObjectUser] and [UserInfo]
  /// by setting the [ObjectUser]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _is.DatabaseSession session,
    ObjectUser objectUser,
    _i1n3uhu0.UserInfo userInfo, {
    _is.Transaction? transaction,
  }) async {
    if (objectUser.id == null) {
      throw ArgumentError.notNull('objectUser.id');
    }
    if (userInfo.id == null) {
      throw ArgumentError.notNull('userInfo.id');
    }

    var $objectUser = objectUser.copyWith(userInfoId: userInfo.id);
    await session.db.updateRow<ObjectUser>(
      $objectUser,
      columns: [ObjectUser.t.userInfoId],
      transaction: transaction,
    );
  }
}
