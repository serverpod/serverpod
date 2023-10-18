/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectFieldScopes extends _i1.TableRow {
  ObjectFieldScopes._({
    int? id,
    required this.normal,
    this.api,
    this.database,
  }) : super(id);

  factory ObjectFieldScopes({
    int? id,
    required String normal,
    String? api,
    String? database,
  }) = _ObjectFieldScopesImpl;

  factory ObjectFieldScopes.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectFieldScopes(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      normal:
          serializationManager.deserialize<String>(jsonSerialization['normal']),
      api: serializationManager.deserialize<String?>(jsonSerialization['api']),
      database: serializationManager
          .deserialize<String?>(jsonSerialization['database']),
    );
  }

  static final t = ObjectFieldScopesTable();

  static const db = ObjectFieldScopesRepository._();

  String normal;

  String? api;

  String? database;

  @override
  _i1.Table get table => t;

  ObjectFieldScopes copyWith({
    int? id,
    String? normal,
    String? api,
    String? database,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'normal': normal,
      'database': database,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
      'database': database,
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
      case 'normal':
        normal = value;
        return;
      case 'database':
        database = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ObjectFieldScopes>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
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
  static Future<ObjectFieldScopes?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ObjectFieldScopes?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectFieldScopes>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectFieldScopesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectFieldScopes>(
      where: where(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectFieldScopes row, {
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
    ObjectFieldScopes row, {
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
    ObjectFieldScopes row, {
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
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ObjectFieldScopesInclude include() {
    return ObjectFieldScopesInclude._();
  }

  static ObjectFieldScopesIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    ObjectFieldScopesInclude? include,
  }) {
    return ObjectFieldScopesIncludeList._(
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

class _ObjectFieldScopesImpl extends ObjectFieldScopes {
  _ObjectFieldScopesImpl({
    int? id,
    required String normal,
    String? api,
    String? database,
  }) : super._(
          id: id,
          normal: normal,
          api: api,
          database: database,
        );

  @override
  ObjectFieldScopes copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
    Object? database = _Undefined,
  }) {
    return ObjectFieldScopes(
      id: id is int? ? id : this.id,
      normal: normal ?? this.normal,
      api: api is String? ? api : this.api,
      database: database is String? ? database : this.database,
    );
  }
}

class ObjectFieldScopesTable extends _i1.Table {
  ObjectFieldScopesTable({super.tableRelation})
      : super(tableName: 'object_field_scopes') {
    normal = _i1.ColumnString(
      'normal',
      this,
    );
    database = _i1.ColumnString(
      'database',
      this,
    );
  }

  late final _i1.ColumnString normal;

  late final _i1.ColumnString database;

  @override
  List<_i1.Column> get columns => [
        id,
        normal,
        database,
      ];
}

@Deprecated('Use ObjectFieldScopesTable.t instead.')
ObjectFieldScopesTable tObjectFieldScopes = ObjectFieldScopesTable();

class ObjectFieldScopesInclude extends _i1.IncludeObject {
  ObjectFieldScopesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectFieldScopes.t;
}

class ObjectFieldScopesIncludeList extends _i1.IncludeList {
  ObjectFieldScopesIncludeList._({
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectFieldScopes.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectFieldScopes.t;
}

class ObjectFieldScopesRepository {
  const ObjectFieldScopesRepository._();

  Future<List<ObjectFieldScopes>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectFieldScopes>(
      where: where?.call(ObjectFieldScopes.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes?> findRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<ObjectFieldScopes>(
      where: where?.call(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectFieldScopes>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectFieldScopes>> insert(
    _i1.Session session,
    List<ObjectFieldScopes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectFieldScopes>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes> insertRow(
    _i1.Session session,
    ObjectFieldScopes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectFieldScopes>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectFieldScopes>> update(
    _i1.Session session,
    List<ObjectFieldScopes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectFieldScopes>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes> updateRow(
    _i1.Session session,
    ObjectFieldScopes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectFieldScopes>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectFieldScopes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectFieldScopes>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectFieldScopes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectFieldScopes>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectFieldScopesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectFieldScopes>(
      where: where(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectFieldScopes>(
      where: where?.call(ObjectFieldScopes.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
