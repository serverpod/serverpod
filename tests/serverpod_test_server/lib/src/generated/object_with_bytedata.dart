/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

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
      'id': id,
      'byteData': byteData,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'byteData': byteData,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'byteData': byteData,
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

  static Future<List<ObjectWithByteData>> find(
    _i1.Session session, {
    ObjectWithByteDataExpressionBuilder? where,
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

  static Future<ObjectWithByteData?> findSingleRow(
    _i1.Session session, {
    ObjectWithByteDataExpressionBuilder? where,
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

  static Future<ObjectWithByteData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithByteData>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithByteDataExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

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

  static Future<int> count(
    _i1.Session session, {
    ObjectWithByteDataExpressionBuilder? where,
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

typedef ObjectWithByteDataExpressionBuilder = _i1.Expression Function(
    ObjectWithByteDataTable);

class ObjectWithByteDataTable extends _i1.Table {
  ObjectWithByteDataTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'object_with_bytedata') {
    byteData = _i1.ColumnByteData(
      'byteData',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
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

class ObjectWithByteDataInclude extends _i1.Include {
  ObjectWithByteDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ObjectWithByteData.t;
}
