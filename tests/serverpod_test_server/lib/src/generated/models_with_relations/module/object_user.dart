/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;

abstract class ObjectUser implements _i1.TableRow, _i1.ProtocolSerialization {
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
    _i2.UserInfo? userInfo,
  }) = _ObjectUserImpl;

  factory ObjectUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
    );
  }

  static final t = ObjectUserTable();

  static const db = ObjectUserRepository._();

  @override
  int? id;

  String? name;

  int userInfoId;

  _i2.UserInfo? userInfo;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
    };
  }

  static ObjectUserInclude include({_i2.UserInfoInclude? userInfo}) {
    return ObjectUserInclude._(userInfo: userInfo);
  }

  static ObjectUserIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectUserTable>? orderByList,
    ObjectUserInclude? include,
  }) {
    return ObjectUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectUserImpl extends ObjectUser {
  _ObjectUserImpl({
    int? id,
    String? name,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) : super._(
          id: id,
          name: name,
          userInfoId: userInfoId,
          userInfo: userInfo,
        );

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
    );
  }
}

class ObjectUserTable extends _i1.Table {
  ObjectUserTable({super.tableRelation}) : super(tableName: 'object_user') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt userInfoId;

  _i2.UserInfoTable? _userInfo;

  _i2.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: ObjectUser.t.userInfoId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        userInfoId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    return null;
  }
}

class ObjectUserInclude extends _i1.IncludeObject {
  ObjectUserInclude._({_i2.UserInfoInclude? userInfo}) {
    _userInfo = userInfo;
  }

  _i2.UserInfoInclude? _userInfo;

  @override
  Map<String, _i1.Include?> get includes => {'userInfo': _userInfo};

  @override
  _i1.Table get table => ObjectUser.t;
}

class ObjectUserIncludeList extends _i1.IncludeList {
  ObjectUserIncludeList._({
    _i1.WhereExpressionBuilder<ObjectUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectUser.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectUserTable>? orderByList,
    _i1.Transaction? transaction,
    ObjectUserInclude? include,
  }) async {
    return session.db.find<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectUserTable>? orderByList,
    _i1.Transaction? transaction,
    ObjectUserInclude? include,
  }) async {
    return session.db.findFirstRow<ObjectUser>(
      where: where?.call(ObjectUser.t),
      orderBy: orderBy?.call(ObjectUser.t),
      orderByList: orderByList?.call(ObjectUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ObjectUser] by its [id] or null if no such row exists.
  Future<ObjectUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ObjectUserInclude? include,
  }) async {
    return session.db.findById<ObjectUser>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ObjectUser]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectUser>> insert(
    _i1.Session session,
    List<ObjectUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectUser] and returns the inserted row.
  ///
  /// The returned [ObjectUser] will have its `id` field set.
  Future<ObjectUser> insertRow(
    _i1.Session session,
    ObjectUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectUser>> update(
    _i1.Session session,
    List<ObjectUser> rows, {
    _i1.ColumnSelections<ObjectUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectUser>(
      rows,
      columns: columns?.call(ObjectUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectUser> updateRow(
    _i1.Session session,
    ObjectUser row, {
    _i1.ColumnSelections<ObjectUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectUser>(
      row,
      columns: columns?.call(ObjectUser.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectUser>> delete(
    _i1.Session session,
    List<ObjectUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectUser].
  Future<ObjectUser> deleteRow(
    _i1.Session session,
    ObjectUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectUser>(
      where: where(ObjectUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectUser>(
      where: where?.call(ObjectUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ObjectUserAttachRowRepository {
  const ObjectUserAttachRowRepository._();

  /// Creates a relation between the given [ObjectUser] and [UserInfo]
  /// by setting the [ObjectUser]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _i1.Session session,
    ObjectUser objectUser,
    _i2.UserInfo userInfo, {
    _i1.Transaction? transaction,
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
