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

  factory ObjectWithByteData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithByteData(
      id: jsonSerialization['id'] as int?,
      byteData: _i1.ByteDataExt.fromJson(jsonSerialization['byteData']),
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
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
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
    return session.db.find<ObjectWithByteData>(
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
    return session.db.findFirstRow<ObjectWithByteData>(
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
    return session.db.findById<ObjectWithByteData>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithByteData>> insert(
    _i1.Session session,
    List<ObjectWithByteData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithByteData> insertRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithByteData>(
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
    return session.db.update<ObjectWithByteData>(
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
    return session.db.updateRow<ObjectWithByteData>(
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
    return session.db.delete<ObjectWithByteData>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithByteData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithByteData>(
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
    return session.db.count<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
