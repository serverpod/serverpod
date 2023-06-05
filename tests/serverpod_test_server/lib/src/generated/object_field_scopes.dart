/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

class ObjectFieldScopes extends _i1.TableRow {
  ObjectFieldScopes({
    int? id,
    required this.normal,
    this.api,
    this.database,
  }) : super(id);

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

  static var t = ObjectFieldScopesTable();

  final String normal;

  final String? api;

  final String? database;

  late Function({
    int? id,
    String? normal,
    String? api,
    String? database,
  }) copyWith = _copyWith;

  @override
  String get tableName => 'object_field_scopes';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectFieldScopes &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.normal,
                  normal,
                ) ||
                other.normal == normal) &&
            (identical(
                  other.api,
                  api,
                ) ||
                other.api == api) &&
            (identical(
                  other.database,
                  database,
                ) ||
                other.database == database));
  }

  @override
  int get hashCode => Object.hash(
        id,
        normal,
        api,
        database,
      );

  ObjectFieldScopes _copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
    Object? database = _Undefined,
  }) {
    return ObjectFieldScopes(
      id: id == _Undefined ? this.id : (id as int?),
      normal: normal ?? this.normal,
      api: api == _Undefined ? this.api : (api as String?),
      database: database == _Undefined ? this.database : (database as String?),
    );
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'normal': normal,
      'database': database,
    };
  }

  static Future<List<ObjectFieldScopes>> find(
    _i1.Session session, {
    ObjectFieldScopesExpressionBuilder? where,
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

  static Future<ObjectFieldScopes?> findSingleRow(
    _i1.Session session, {
    ObjectFieldScopesExpressionBuilder? where,
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

  static Future<ObjectFieldScopes?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectFieldScopes>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectFieldScopesExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectFieldScopes>(
      where: where(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

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

  static Future<int> count(
    _i1.Session session, {
    ObjectFieldScopesExpressionBuilder? where,
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
}

typedef ObjectFieldScopesExpressionBuilder = _i1.Expression Function(
    ObjectFieldScopesTable);

class ObjectFieldScopesTable extends _i1.Table {
  ObjectFieldScopesTable() : super(tableName: 'object_field_scopes');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final normal = _i1.ColumnString('normal');

  final database = _i1.ColumnString('database');

  @override
  List<_i1.Column> get columns => [
        id,
        normal,
        database,
      ];
}

@Deprecated('Use ObjectFieldScopesTable.t instead.')
ObjectFieldScopesTable tObjectFieldScopes = ObjectFieldScopesTable();
