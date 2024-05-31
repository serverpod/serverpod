/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ParentUser extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory ParentUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int?,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (userInfoId != null) 'userInfoId': userInfoId,
    };
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    return session.db.find<ParentUser>(
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
    return session.db.findFirstRow<ParentUser>(
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
    return session.db.findById<ParentUser>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ParentUser>> insert(
    _i1.Session session,
    List<ParentUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ParentUser>(
      rows,
      transaction: transaction,
    );
  }

  Future<ParentUser> insertRow(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ParentUser>(
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
    return session.db.update<ParentUser>(
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
    return session.db.updateRow<ParentUser>(
      row,
      columns: columns?.call(ParentUser.t),
      transaction: transaction,
    );
  }

  Future<List<ParentUser>> delete(
    _i1.Session session,
    List<ParentUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ParentUser>(
      rows,
      transaction: transaction,
    );
  }

  Future<ParentUser> deleteRow(
    _i1.Session session,
    ParentUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ParentUser>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ParentUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ParentUser>(
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
    return session.db.count<ParentUser>(
      where: where?.call(ParentUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
