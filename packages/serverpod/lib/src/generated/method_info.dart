/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef MethodInfoExpressionBuilder = _i1.Expression Function(MethodInfoTable);

/// Information about a server method.
abstract class MethodInfo extends _i1.TableRow {
  const MethodInfo._();

  const factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfo;

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

  static const t = MethodInfoTable();

  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });
  @override
  String get tableName => 'serverpod_method';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  static Future<List<MethodInfo>> find(
    _i1.Session session, {
    MethodInfoExpressionBuilder? where,
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

  static Future<MethodInfo?> findSingleRow(
    _i1.Session session, {
    MethodInfoExpressionBuilder? where,
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

  static Future<MethodInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<MethodInfo>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required MethodInfoExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MethodInfo>(
      where: where(MethodInfo.t),
      transaction: transaction,
    );
  }

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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<MethodInfo> insert(
    _i1.Session session,
    MethodInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    MethodInfoExpressionBuilder? where,
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

  /// The endpoint of this method.
  String get endpoint;

  /// The name of this method.
  String get method;
}

class _Undefined {}

/// Information about a server method.
class _MethodInfo extends MethodInfo {
  const _MethodInfo({
    int? id,
    required this.endpoint,
    required this.method,
  }) : super._();

  /// The endpoint of this method.
  @override
  final String endpoint;

  /// The name of this method.
  @override
  final String method;

  @override
  String get tableName => 'serverpod_method';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is MethodInfo &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method));
  }

  @override
  int get hashCode => Object.hash(
        id,
        endpoint,
        method,
      );

  @override
  MethodInfo copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id == _Undefined ? this.id : (id as int?),
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}

class MethodInfoTable extends _i1.Table {
  const MethodInfoTable() : super(tableName: 'serverpod_method');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The endpoint of this method.
  final endpoint = const _i1.ColumnString('endpoint');

  /// The name of this method.
  final method = const _i1.ColumnString('method');

  @override
  List<_i1.Column> get columns => [
        id,
        endpoint,
        method,
      ];
}

@Deprecated('Use MethodInfoTable.t instead.')
MethodInfoTable tMethodInfo = const MethodInfoTable();
