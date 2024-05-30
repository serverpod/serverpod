/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithSelfParent extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  ObjectWithSelfParent._({
    int? id,
    this.other,
  }) : super(id);

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithSelfParent(
      id: jsonSerialization['id'] as int?,
      other: jsonSerialization['other'] as int?,
    );
  }

  static final t = ObjectWithSelfParentTable();

  static const db = ObjectWithSelfParentRepository._();

  int? other;

  @override
  _i1.Table get table => t;

  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  static ObjectWithSelfParentInclude include() {
    return ObjectWithSelfParentInclude._();
  }

  static ObjectWithSelfParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    ObjectWithSelfParentInclude? include,
  }) {
    return ObjectWithSelfParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSelfParentImpl extends ObjectWithSelfParent {
  _ObjectWithSelfParentImpl({
    int? id,
    int? other,
  }) : super._(
          id: id,
          other: other,
        );

  @override
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id is int? ? id : this.id,
      other: other is int? ? other : this.other,
    );
  }
}

class ObjectWithSelfParentTable extends _i1.Table {
  ObjectWithSelfParentTable({super.tableRelation})
      : super(tableName: 'object_with_self_parent') {
    other = _i1.ColumnInt(
      'other',
      this,
    );
  }

  late final _i1.ColumnInt other;

  @override
  List<_i1.Column> get columns => [
        id,
        other,
      ];
}

class ObjectWithSelfParentInclude extends _i1.IncludeObject {
  ObjectWithSelfParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithSelfParent.t;
}

class ObjectWithSelfParentIncludeList extends _i1.IncludeList {
  ObjectWithSelfParentIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithSelfParent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithSelfParent.t;
}

class ObjectWithSelfParentRepository {
  const ObjectWithSelfParentRepository._();

  Future<List<ObjectWithSelfParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSelfParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSelfParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      orderBy: orderBy?.call(ObjectWithSelfParent.t),
      orderByList: orderByList?.call(ObjectWithSelfParent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithSelfParent>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithSelfParent>> insert(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent> insertRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithSelfParent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithSelfParent>> update(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.ColumnSelections<ObjectWithSelfParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithSelfParent>(
      rows,
      columns: columns?.call(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent> updateRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.ColumnSelections<ObjectWithSelfParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithSelfParent>(
      row,
      columns: columns?.call(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  Future<List<ObjectWithSelfParent>> delete(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent> deleteRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithSelfParent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithSelfParent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSelfParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithSelfParent>(
      where: where(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
