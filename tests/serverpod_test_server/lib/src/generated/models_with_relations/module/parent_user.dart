/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ParentUser extends _i1.TableRow {
  ParentUser._({
    int? id,
    this.name,
    this.userInfoId,
  }) : super(id);

  factory ParentUser({
    int? id,
    String? name,
    int? userInfoId,
  }) = _ParentUserImpl;

  factory ParentUser.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ParentUser(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      userInfoId: serializationManager
          .deserialize<int?>(jsonSerialization['userInfoId']),
    );
  }

  static final t = ParentUserTable();

  static const db = ParentUserRepository._();

  String? name;

  int? userInfoId;

  @override
  _i1.Table get table => t;

  ParentUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (userInfoId != null) 'userInfoId': userInfoId,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'userInfoId': userInfoId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (userInfoId != null) 'userInfoId': userInfoId,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'userInfoId':
        userInfoId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ParentUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ParentUser>(
      where: where != null ? where(ParentUser.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<ParentUser?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ParentUser>(
      where: where != null ? where(ParentUser.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ParentUser?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ParentUser>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ParentUser>(
      where: where(ParentUser.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ParentUser>(
      where: where != null ? where(ParentUser.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ParentUserInclude include() {
    return ParentUserInclude._();
  }

  static ParentUserIncludeList includeList({
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentUserTable>? orderByList,
    ParentUserInclude? include,
  }) {
    return ParentUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ParentUser.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ParentUserImpl extends ParentUser {
  _ParentUserImpl({
    int? id,
    String? name,
    int? userInfoId,
  }) : super._(
          id: id,
          name: name,
          userInfoId: userInfoId,
        );

  @override
  ParentUser copyWith({
    Object? id = _Undefined,
    Object? name = _Undefined,
    Object? userInfoId = _Undefined,
  }) {
    return ParentUser(
      id: id is int? ? id : this.id,
      name: name is String? ? name : this.name,
      userInfoId: userInfoId is int? ? userInfoId : this.userInfoId,
    );
  }
}

class ParentUserTable extends _i1.Table {
  ParentUserTable({super.tableRelation}) : super(tableName: 'parent_user') {
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

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        userInfoId,
      ];
}

@Deprecated('Use ParentUserTable.t instead.')
ParentUserTable tParentUser = ParentUserTable();

class ParentUserInclude extends _i1.IncludeObject {
  ParentUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ParentUser.t;
}

class ParentUserIncludeList extends _i1.IncludeList {
  ParentUserIncludeList._({
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ParentUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ParentUser.t;
}

class ParentUserRepository {
  const ParentUserRepository._();

  Future<List<ParentUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ParentUser>(
      where: where?.call(ParentUser.t),
      orderBy: orderBy?.call(ParentUser.t),
      orderByList: orderByList?.call(ParentUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ParentUser?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<ParentUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ParentUser>(
      where: where?.call(ParentUser.t),
      orderBy: orderBy?.call(ParentUser.t),
      orderByList: orderByList?.call(ParentUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ParentUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ParentUser>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ParentUser>> insert(
    _i1.Session session,
    List<ParentUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ParentUser>(
      rows,
      transaction: transaction,
    );
  }

  Future<ParentUser> insertRow(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ParentUser>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ParentUser>> update(
    _i1.Session session,
    List<ParentUser> rows, {
    _i1.ColumnSelections<ParentUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ParentUser>(
      rows,
      columns: columns?.call(ParentUser.t),
      transaction: transaction,
    );
  }

  Future<ParentUser> updateRow(
    _i1.Session session,
    ParentUser row, {
    _i1.ColumnSelections<ParentUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ParentUser>(
      row,
      columns: columns?.call(ParentUser.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ParentUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ParentUser>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ParentUser>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ParentUser>(
      where: where(ParentUser.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ParentUser>(
      where: where?.call(ParentUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
