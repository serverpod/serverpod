/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithSelfParent extends _i1.TableRow {
  ObjectWithSelfParent._({
    int? id,
    this.other,
  }) : super(id);

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithSelfParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int?>(jsonSerialization['other']),
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
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'other': other,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'other':
        other = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectWithSelfParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
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
  static Future<ObjectWithSelfParent?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithSelfParent?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithSelfParent>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSelfParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSelfParent>(
      where: where(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
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
    ObjectWithSelfParent row, {
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
    ObjectWithSelfParent row, {
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
    _i1.WhereExpressionBuilder<ObjectWithSelfParentTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSelfParent>(
      where: where != null ? where(ObjectWithSelfParent.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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

@Deprecated('Use ObjectWithSelfParentTable.t instead.')
ObjectWithSelfParentTable tObjectWithSelfParent = ObjectWithSelfParentTable();

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
    return session.dbNext.find<ObjectWithSelfParent>(
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
    return session.dbNext.findFirstRow<ObjectWithSelfParent>(
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
    return session.dbNext.findById<ObjectWithSelfParent>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithSelfParent>> insert(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithSelfParent> insertRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithSelfParent>(
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
    return session.dbNext.update<ObjectWithSelfParent>(
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
    return session.dbNext.updateRow<ObjectWithSelfParent>(
      row,
      columns: columns?.call(ObjectWithSelfParent.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithSelfParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithSelfParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithSelfParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithSelfParent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSelfParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithSelfParent>(
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
    return session.dbNext.count<ObjectWithSelfParent>(
      where: where?.call(ObjectWithSelfParent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
