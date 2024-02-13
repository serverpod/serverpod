/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (database != null) 'database': database,
    };
  }

  static ObjectFieldScopesInclude include() {
    return ObjectFieldScopesInclude._();
  }

  static ObjectFieldScopesIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectFieldScopesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldScopesTable>? orderByList,
    ObjectFieldScopesInclude? include,
  }) {
    return ObjectFieldScopesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectFieldScopes.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectFieldScopes.t),
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
    _i1.OrderByBuilder<ObjectFieldScopesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldScopesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectFieldScopes>(
      where: where?.call(ObjectFieldScopes.t),
      orderBy: orderBy?.call(ObjectFieldScopes.t),
      orderByList: orderByList?.call(ObjectFieldScopes.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectFieldScopesTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectFieldScopesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectFieldScopesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectFieldScopes>(
      where: where?.call(ObjectFieldScopes.t),
      orderBy: orderBy?.call(ObjectFieldScopes.t),
      orderByList: orderByList?.call(ObjectFieldScopes.t),
      orderDescending: orderDescending,
      offset: offset,
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
    _i1.ColumnSelections<ObjectFieldScopesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectFieldScopes>(
      rows,
      columns: columns?.call(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

  Future<ObjectFieldScopes> updateRow(
    _i1.Session session,
    ObjectFieldScopes row, {
    _i1.ColumnSelections<ObjectFieldScopesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectFieldScopes>(
      row,
      columns: columns?.call(ObjectFieldScopes.t),
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
