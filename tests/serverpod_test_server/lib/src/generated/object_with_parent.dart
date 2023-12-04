/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithParent extends _i1.TableRow {
  ObjectWithParent._({
    int? id,
    required this.other,
  }) : super(id);

  factory ObjectWithParent({
    int? id,
    required int other,
  }) = _ObjectWithParentImpl;

  factory ObjectWithParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int>(jsonSerialization['other']),
    );
  }

  static final t = ObjectWithParentTable();

  static const db = ObjectWithParentRepository._();

  int other;

  @override
  _i1.Table get table => t;

  ObjectWithParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
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
      'id': id,
      'other': other,
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
  static Future<List<ObjectWithParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
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
  static Future<ObjectWithParent?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithParent?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithParent>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithParent row, {
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
    ObjectWithParent row, {
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
    ObjectWithParent row, {
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
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithParent>(
      where: where != null ? where(ObjectWithParent.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithParentInclude include() {
    return ObjectWithParentInclude._();
  }

  static ObjectWithParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    ObjectWithParentInclude? include,
  }) {
    return ObjectWithParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithParent.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ObjectWithParentImpl extends ObjectWithParent {
  _ObjectWithParentImpl({
    int? id,
    required int other,
  }) : super._(
          id: id,
          other: other,
        );

  @override
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
  }) {
    return ObjectWithParent(
      id: id is int? ? id : this.id,
      other: other ?? this.other,
    );
  }
}

class ObjectWithParentTable extends _i1.Table {
  ObjectWithParentTable({super.tableRelation})
      : super(tableName: 'object_with_parent') {
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

@Deprecated('Use ObjectWithParentTable.t instead.')
ObjectWithParentTable tObjectWithParent = ObjectWithParentTable();

class ObjectWithParentInclude extends _i1.IncludeObject {
  ObjectWithParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithParent.t;
}

class ObjectWithParentIncludeList extends _i1.IncludeList {
  ObjectWithParentIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithParent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithParent.t;
}

class ObjectWithParentRepository {
  const ObjectWithParentRepository._();

  Future<List<ObjectWithParent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithParent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithParent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithParent>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithParent>> insert(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithParent> insertRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithParent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithParent>> update(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.ColumnSelections<ObjectWithParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectWithParent>(
      rows,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithParent> updateRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.ColumnSelections<ObjectWithParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithParent>(
      row,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithParent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithParent>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithParent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
