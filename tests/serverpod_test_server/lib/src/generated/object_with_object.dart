/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

abstract class ObjectWithObject extends _i1.TableRow {
  ObjectWithObject._({
    int? id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  }) : super(id);

  factory ObjectWithObject({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithObject(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      data: serializationManager
          .deserialize<_i2.SimpleData>(jsonSerialization['data']),
      nullableData: serializationManager
          .deserialize<_i2.SimpleData?>(jsonSerialization['nullableData']),
      dataList: serializationManager
          .deserialize<List<_i2.SimpleData>>(jsonSerialization['dataList']),
      nullableDataList: serializationManager.deserialize<List<_i2.SimpleData>?>(
          jsonSerialization['nullableDataList']),
      listWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>>(
              jsonSerialization['listWithNullableData']),
      nullableListWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>?>(
              jsonSerialization['nullableListWithNullableData']),
    );
  }

  static final t = ObjectWithObjectTable();

  static const db = ObjectWithObjectRepository._();

  _i2.SimpleData data;

  _i2.SimpleData? nullableData;

  List<_i2.SimpleData> dataList;

  List<_i2.SimpleData>? nullableDataList;

  List<_i2.SimpleData?> listWithNullableData;

  List<_i2.SimpleData?>? nullableListWithNullableData;

  @override
  _i1.Table get table => t;

  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
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
      case 'data':
        data = value;
        return;
      case 'nullableData':
        nullableData = value;
        return;
      case 'dataList':
        dataList = value;
        return;
      case 'nullableDataList':
        nullableDataList = value;
        return;
      case 'listWithNullableData':
        listWithNullableData = value;
        return;
      case 'nullableListWithNullableData':
        nullableListWithNullableData = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectWithObject>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
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
  static Future<ObjectWithObject?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectWithObject?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithObject>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithObjectTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithObject row, {
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
    ObjectWithObject row, {
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
    ObjectWithObject row, {
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
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectWithObjectInclude include() {
    return ObjectWithObjectInclude._();
  }

  static ObjectWithObjectIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    ObjectWithObjectInclude? include,
  }) {
    return ObjectWithObjectIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _ObjectWithObjectImpl extends ObjectWithObject {
  _ObjectWithObjectImpl({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) : super._(
          id: id,
          data: data,
          nullableData: nullableData,
          dataList: dataList,
          nullableDataList: nullableDataList,
          listWithNullableData: listWithNullableData,
          nullableListWithNullableData: nullableListWithNullableData,
        );

  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i2.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i2.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i2.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i2.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.clone(),
      nullableDataList: nullableDataList is List<_i2.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.clone(),
      listWithNullableData:
          listWithNullableData ?? this.listWithNullableData.clone(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i2.SimpleData?>?
              ? nullableListWithNullableData
              : this.nullableListWithNullableData?.clone(),
    );
  }
}

class ObjectWithObjectTable extends _i1.Table {
  ObjectWithObjectTable({super.tableRelation})
      : super(tableName: 'object_with_object') {
    data = _i1.ColumnSerializable(
      'data',
      this,
    );
    nullableData = _i1.ColumnSerializable(
      'nullableData',
      this,
    );
    dataList = _i1.ColumnSerializable(
      'dataList',
      this,
    );
    nullableDataList = _i1.ColumnSerializable(
      'nullableDataList',
      this,
    );
    listWithNullableData = _i1.ColumnSerializable(
      'listWithNullableData',
      this,
    );
    nullableListWithNullableData = _i1.ColumnSerializable(
      'nullableListWithNullableData',
      this,
    );
  }

  late final _i1.ColumnSerializable data;

  late final _i1.ColumnSerializable nullableData;

  late final _i1.ColumnSerializable dataList;

  late final _i1.ColumnSerializable nullableDataList;

  late final _i1.ColumnSerializable listWithNullableData;

  late final _i1.ColumnSerializable nullableListWithNullableData;

  @override
  List<_i1.Column> get columns => [
        id,
        data,
        nullableData,
        dataList,
        nullableDataList,
        listWithNullableData,
        nullableListWithNullableData,
      ];
}

@Deprecated('Use ObjectWithObjectTable.t instead.')
ObjectWithObjectTable tObjectWithObject = ObjectWithObjectTable();

class ObjectWithObjectInclude extends _i1.IncludeObject {
  ObjectWithObjectInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithObject.t;
}

class ObjectWithObjectIncludeList extends _i1.IncludeList {
  ObjectWithObjectIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithObject.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithObject.t;
}

class ObjectWithObjectRepository {
  const ObjectWithObjectRepository._();

  Future<List<ObjectWithObject>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithObject?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithObject?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithObject>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithObject>> insert(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithObject>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithObject> insertRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithObject>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithObject>> update(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.ColumnSelections<ObjectWithObjectTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectWithObject>(
      rows,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithObject> updateRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.ColumnSelections<ObjectWithObjectTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithObject>(
      row,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithObject>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithObject>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithObjectTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
