/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;

abstract class ObjectUser extends _i1.TableRow {
  ObjectUser._({
    int? id,
    this.name,
    required this.userInfoId,
    this.userInfo,
  }) : super(id);

  factory ObjectUser({
    int? id,
    String? name,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) = _ObjectUserImpl;

  factory ObjectUser.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectUser(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      userInfoId: serializationManager
          .deserialize<int>(jsonSerialization['userInfoId']),
      userInfo: serializationManager
          .deserialize<_i2.UserInfo?>(jsonSerialization['userInfo']),
    );
  }

  static final t = ObjectUserTable();

  static const db = ObjectUserRepository._();

  String? name;

  int userInfoId;

  _i2.UserInfo? userInfo;

  @override
  _i1.Table get table => t;

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
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.allToJson(),
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

  Future<void> userInfo(
    _i1.Session session,
    ObjectUser objectUser,
    _i2.UserInfo userInfo,
  ) async {
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
    );
  }
}
