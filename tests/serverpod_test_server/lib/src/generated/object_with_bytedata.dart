/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class ObjectWithByteData extends _i1.TableRow {
  ObjectWithByteData._({
    int? id,
    required this.byteData,
  }) : super(id);

  factory ObjectWithByteData({
    int? id,
    required _i2.ByteData byteData,
  }) = _ObjectWithByteDataImpl;

  factory ObjectWithByteData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithByteData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      byteData: serializationManager
          .deserialize<_i2.ByteData>(jsonSerialization['byteData']),
    );
  }

  static final t = ObjectWithByteDataTable();

  static const db = ObjectWithByteDataRepository._();

  _i2.ByteData byteData;

  @override
  _i1.Table get table => t;

  ObjectWithByteData copyWith({
    int? id,
    _i2.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
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
      case 'byteData':
        byteData = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectWithByteData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithByteData>(
      where: where != null ? where(ObjectWithByteData.t) : null,
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
  static Future<ObjectWithByteData?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithByteData>(
      where: where != null ? where(ObjectWithByteData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithByteData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithByteData>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithByteData row, {
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
    ObjectWithByteData row, {
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
    ObjectWithByteData row, {
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
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithByteData>(
      where: where != null ? where(ObjectWithByteData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithByteDataInclude include() {
    return ObjectWithByteDataInclude._();
  }

  static ObjectWithByteDataIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    ObjectWithByteDataInclude? include,
  }) {
    return ObjectWithByteDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithByteData.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ObjectWithByteDataImpl extends ObjectWithByteData {
  _ObjectWithByteDataImpl({
    int? id,
    required _i2.ByteData byteData,
  }) : super._(
          id: id,
          byteData: byteData,
        );

  @override
  ObjectWithByteData copyWith({
    Object? id = _Undefined,
    _i2.ByteData? byteData,
  }) {
    return ObjectWithByteData(
      id: id is int? ? id : this.id,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}

class ObjectWithByteDataTable extends _i1.Table {
  ObjectWithByteDataTable({super.tableRelation})
      : super(tableName: 'object_with_bytedata') {
    byteData = _i1.ColumnByteData(
      'byteData',
      this,
    );
  }

  late final _i1.ColumnByteData byteData;

  @override
  List<_i1.Column> get columns => [
        id,
        byteData,
      ];
}

@Deprecated('Use ObjectWithByteDataTable.t instead.')
ObjectWithByteDataTable tObjectWithByteData = ObjectWithByteDataTable();

class ObjectWithByteDataInclude extends _i1.IncludeObject {
  ObjectWithByteDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithByteData.t;
}

class ObjectWithByteDataIncludeList extends _i1.IncludeList {
  ObjectWithByteDataIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithByteData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithByteData.t;
}

class ObjectWithByteDataRepository {
  const ObjectWithByteDataRepository._();

  Future<List<ObjectWithByteData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithByteData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithByteData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithByteData>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithByteData>> insert(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithByteData> insertRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithByteData>> update(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.ColumnSelections<ObjectWithByteDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectWithByteData>(
      rows,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithByteData> updateRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.ColumnSelections<ObjectWithByteDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithByteData>(
      row,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
