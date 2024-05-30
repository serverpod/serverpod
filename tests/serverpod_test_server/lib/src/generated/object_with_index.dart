/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithIndex extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory ObjectWithIndex.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithIndex(
      id: jsonSerialization['id'] as int?,
      indexed: jsonSerialization['indexed'] as int,
      indexed2: jsonSerialization['indexed2'] as int,
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
      if (id != null) 'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    return session.db.find<ObjectWithIndex>(
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
    return session.db.findFirstRow<ObjectWithIndex>(
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
    return session.db.findById<ObjectWithIndex>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithIndex>> insert(
    _i1.Session session,
    List<ObjectWithIndex> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithIndex>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex> insertRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithIndex>(
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
    return session.db.update<ObjectWithIndex>(
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
    return session.db.updateRow<ObjectWithIndex>(
      row,
      columns: columns?.call(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  Future<List<ObjectWithIndex>> delete(
    _i1.Session session,
    List<ObjectWithIndex> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithIndex>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithIndex> deleteRow(
    _i1.Session session,
    ObjectWithIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithIndex>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithIndex>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithIndexTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithIndex>(
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
    return session.db.count<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
