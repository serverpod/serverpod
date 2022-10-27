/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class AuthKey extends _i1.TableRow {
  AuthKey({
    int? id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  }) : super(id);

  factory AuthKey.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AuthKey(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      hash: serializationManager
          .deserializeJson<String>(jsonSerialization['hash']),
      key: serializationManager
          .deserializeJson<String?>(jsonSerialization['key']),
      scopeNames: serializationManager
          .deserializeJson<List<String>>(jsonSerialization['scopeNames']),
      method: serializationManager
          .deserializeJson<String>(jsonSerialization['method']),
    );
  }

  static final t = AuthKeyTable();

  int userId;

  String hash;

  String? key;

  List<String> scopeNames;

  String method;

  @override
  String get tableName => 'serverpod_auth_key';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopeNames': scopeNames,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'hash': hash,
      'scopeNames': scopeNames,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopeNames': scopeNames,
      'method': method,
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
      case 'userId':
        userId = value;
        return;
      case 'hash':
        hash = value;
        return;
      case 'scopeNames':
        scopeNames = value;
        return;
      case 'method':
        method = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<AuthKey>> find(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<AuthKey?> findSingleRow(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<AuthKey?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<AuthKey>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required AuthKeyExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthKey>(
      where: where(AuthKey.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef AuthKeyExpressionBuilder = _i1.Expression Function(AuthKeyTable);

class AuthKeyTable extends _i1.Table {
  AuthKeyTable() : super(tableName: 'serverpod_auth_key');

  final id = _i1.ColumnInt('id');

  final userId = _i1.ColumnInt('userId');

  final hash = _i1.ColumnString('hash');

  final scopeNames = _i1.ColumnSerializable('scopeNames');

  final method = _i1.ColumnString('method');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        hash,
        scopeNames,
        method,
      ];
}

@Deprecated('Use AuthKeyTable.t instead.')
AuthKeyTable tAuthKey = AuthKeyTable();
