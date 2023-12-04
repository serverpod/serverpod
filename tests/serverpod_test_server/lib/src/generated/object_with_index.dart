/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithIndex extends _i1.TableRow {
  ObjectWithIndex._({
    int? id,
    required this.indexed,
    required this.indexed2,
  }) : super(id);

  factory ObjectWithIndex({
    int? id,
    required int indexed,
    required int indexed2,
  }) = _ObjectWithIndexImpl;

  factory ObjectWithIndex.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithIndex(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      indexed:
          serializationManager.deserialize<int>(jsonSerialization['indexed']),
      indexed2:
          serializationManager.deserialize<int>(jsonSerialization['indexed2']),
    );
  }

  static final t = ObjectWithIndexTable();

  static const db = ObjectWithIndexRepository._();

  int indexed;

  int indexed2;

  @override
  _i1.Table get table => t;

  ObjectWithIndex copyWith({
    int? id,
    int? indexed,
    int? indexed2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
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
      case 'indexed':
        indexed = value;
        return;
      case 'indexed2':
        indexed2 = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectWithIndex>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
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
  static Future<ObjectWithIndex?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithIndex?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithIndex>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithIndexTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithIndex>(
      where: where(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithIndex row, {
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
    ObjectWithIndex row, {
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
    ObjectWithIndex row, {
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
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithIndex>(
      where: where != null ? where(ObjectWithIndex.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithIndexInclude include() {
    return ObjectWithIndexInclude._();
  }

  static ObjectWithIndexIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    ObjectWithIndexInclude? include,
  }) {
    return ObjectWithIndexIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithIndex.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ObjectWithIndexImpl extends ObjectWithIndex {
  _ObjectWithIndexImpl({
    int? id,
    required int indexed,
    required int indexed2,
  }) : super._(
          id: id,
          indexed: indexed,
          indexed2: indexed2,
        );

  @override
  ObjectWithIndex copyWith({
    Object? id = _Undefined,
    int? indexed,
    int? indexed2,
  }) {
    return ObjectWithIndex(
      id: id is int? ? id : this.id,
      indexed: indexed ?? this.indexed,
      indexed2: indexed2 ?? this.indexed2,
    );
  }
}

class ObjectWithIndexTable extends _i1.Table {
  ObjectWithIndexTable({super.tableRelation})
      : super(tableName: 'object_with_index') {
    indexed = _i1.ColumnInt(
      'indexed',
      this,
    );
    indexed2 = _i1.ColumnInt(
      'indexed2',
      this,
    );
  }

  late final _i1.ColumnInt indexed;

  late final _i1.ColumnInt indexed2;

  @override
  List<_i1.Column> get columns => [
        id,
        indexed,
        indexed2,
      ];
}

@Deprecated('Use ObjectWithIndexTable.t instead.')
ObjectWithIndexTable tObjectWithIndex = ObjectWithIndexTable();

class ObjectWithIndexInclude extends _i1.IncludeObject {
  ObjectWithIndexInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithIndex.t;
}

class ObjectWithIndexIncludeList extends _i1.IncludeList {
  ObjectWithIndexIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithIndex.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithIndex.t;
}

class ObjectWithIndexRepository {
  const ObjectWithIndexRepository._();

  Future<List<ObjectWithIndex>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithIndex>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithIndex>> insert(
    _i1.Session session,
    List<ObjectWithIndex> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithIndex>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex> insertRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithIndex>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithIndex>> update(
    _i1.Session session,
    List<ObjectWithIndex> rows, {
    _i1.ColumnSelections<ObjectWithIndexTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectWithIndex>(
      rows,
      columns: columns?.call(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex> updateRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.ColumnSelections<ObjectWithIndexTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithIndex>(
      row,
      columns: columns?.call(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithIndex> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithIndex>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithIndex>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithIndexTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithIndex>(
      where: where(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
