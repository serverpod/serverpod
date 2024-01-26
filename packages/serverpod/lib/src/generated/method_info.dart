/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a server method.
abstract class MethodInfo extends _i1.TableRow {
  MethodInfo._({
    int? id,
    required this.endpoint,
    required this.method,
  }) : super(id);

  factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfoImpl;

  factory MethodInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MethodInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      endpoint: serializationManager
          .deserialize<String>(jsonSerialization['endpoint']),
      method:
          serializationManager.deserialize<String>(jsonSerialization['method']),
    );
  }

  static final t = MethodInfoTable();

  static const db = MethodInfoRepository._();

  /// The endpoint of this method.
  String endpoint;

  /// The name of this method.
  String method;

  @override
  _i1.Table get table => t;

  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'endpoint':
        endpoint = value;
        return;
      case 'method':
        method = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<MethodInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MethodInfo>(
      where: where != null ? where(MethodInfo.t) : null,
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
  static Future<MethodInfo?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<MethodInfo>(
      where: where != null ? where(MethodInfo.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<MethodInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<MethodInfo>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MethodInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MethodInfo>(
      where: where(MethodInfo.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    MethodInfo row, {
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
    MethodInfo row, {
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
    MethodInfo row, {
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
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MethodInfo>(
      where: where != null ? where(MethodInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static MethodInfoInclude include() {
    return MethodInfoInclude._();
  }

  static MethodInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    MethodInfoInclude? include,
  }) {
    return MethodInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MethodInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MethodInfo.t),
      include: include,
    );
  }
}

class _Undefined {}

class _MethodInfoImpl extends MethodInfo {
  _MethodInfoImpl({
    int? id,
    required String endpoint,
    required String method,
  }) : super._(
          id: id,
          endpoint: endpoint,
          method: method,
        );

  @override
  MethodInfo copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id is int? ? id : this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}

class MethodInfoTable extends _i1.Table {
  MethodInfoTable({super.tableRelation})
      : super(tableName: 'serverpod_method') {
    endpoint = _i1.ColumnString(
      'endpoint',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  /// The endpoint of this method.
  late final _i1.ColumnString endpoint;

  /// The name of this method.
  late final _i1.ColumnString method;

  @override
  List<_i1.Column> get columns => [
        id,
        endpoint,
        method,
      ];
}

@Deprecated('Use MethodInfoTable.t instead.')
MethodInfoTable tMethodInfo = MethodInfoTable();

class MethodInfoInclude extends _i1.IncludeObject {
  MethodInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MethodInfo.t;
}

class MethodInfoIncludeList extends _i1.IncludeList {
  MethodInfoIncludeList._({
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MethodInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MethodInfo.t;
}

class MethodInfoRepository {
  const MethodInfoRepository._();

  Future<List<MethodInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MethodInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<MethodInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MethodInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MethodInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<MethodInfo>(
      id,
      transaction: transaction,
    );
  }

  Future<List<MethodInfo>> insert(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<MethodInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<MethodInfo> insertRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<MethodInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MethodInfo>> update(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.ColumnSelections<MethodInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<MethodInfo>(
      rows,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  Future<MethodInfo> updateRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.ColumnSelections<MethodInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<MethodInfo>(
      row,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<MethodInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<MethodInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    MethodInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<MethodInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MethodInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<MethodInfo>(
      where: where(MethodInfo.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<MethodInfo>(
      where: where?.call(MethodInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
