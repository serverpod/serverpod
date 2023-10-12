/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Provides a method of access for a user to authenticate with the server.
abstract class AuthKey extends _i1.TableRow {
  AuthKey._({
    int? id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  }) : super(id);

  factory AuthKey({
    int? id,
    required int userId,
    required String hash,
    String? key,
    required List<String> scopeNames,
    required String method,
  }) = _AuthKeyImpl;

  factory AuthKey.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AuthKey(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
      key: serializationManager.deserialize<String?>(jsonSerialization['key']),
      scopeNames: serializationManager
          .deserialize<List<String>>(jsonSerialization['scopeNames']),
      method:
          serializationManager.deserialize<String>(jsonSerialization['method']),
    );
  }

  static final t = AuthKeyTable();

  static const db = AuthKeyRepository._();

  /// The id of the user to provide access to.
  int userId;

  /// The hashed version of the key.
  String hash;

  /// The key sent to the server to authenticate.
  String? key;

  /// The scopes this key provides access to.
  List<String> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  String method;

  @override
  _i1.Table get table => t;

  AuthKey copyWith({
    int? id,
    int? userId,
    String? hash,
    String? key,
    List<String>? scopeNames,
    String? method,
  });
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
  @Deprecated('Will be removed in 2.0.0')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<AuthKey?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<AuthKey>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
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

  static AuthKeyInclude include() {
    return AuthKeyInclude._();
  }
}

class _Undefined {}

class _AuthKeyImpl extends AuthKey {
  _AuthKeyImpl({
    int? id,
    required int userId,
    required String hash,
    String? key,
    required List<String> scopeNames,
    required String method,
  }) : super._(
          id: id,
          userId: userId,
          hash: hash,
          key: key,
          scopeNames: scopeNames,
          method: method,
        );

  @override
  AuthKey copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hash,
    Object? key = _Undefined,
    List<String>? scopeNames,
    String? method,
  }) {
    return AuthKey(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
      key: key is String? ? key : this.key,
      scopeNames: scopeNames ?? this.scopeNames.clone(),
      method: method ?? this.method,
    );
  }
}

typedef AuthKeyExpressionBuilder = _i1.Expression Function(AuthKeyTable);

class AuthKeyTable extends _i1.Table {
  AuthKeyTable({super.tableRelation}) : super(tableName: 'serverpod_auth_key') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  /// The id of the user to provide access to.
  late final _i1.ColumnInt userId;

  /// The hashed version of the key.
  late final _i1.ColumnString hash;

  /// The scopes this key provides access to.
  late final _i1.ColumnSerializable scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  late final _i1.ColumnString method;

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

class AuthKeyInclude extends _i1.Include {
  AuthKeyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => AuthKey.t;
}

class AuthKeyRepository {
  const AuthKeyRepository._();

  Future<List<AuthKey>> find(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<AuthKey>(
      where: where?.call(AuthKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<AuthKey?> findRow(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<AuthKey>(
      where: where?.call(AuthKey.t),
      transaction: transaction,
    );
  }

  Future<AuthKey?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<AuthKey>(
      id,
      transaction: transaction,
    );
  }

  Future<List<AuthKey>> insert(
    _i1.Session session,
    List<AuthKey> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<AuthKey>(
      rows,
      transaction: transaction,
    );
  }

  Future<AuthKey> insertRow(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<AuthKey>(
      row,
      transaction: transaction,
    );
  }

  Future<List<AuthKey>> update(
    _i1.Session session,
    List<AuthKey> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<AuthKey>(
      rows,
      transaction: transaction,
    );
  }

  Future<AuthKey> updateRow(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<AuthKey>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<AuthKey> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<AuthKey>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    AuthKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<AuthKey>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required AuthKeyExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<AuthKey>(
      where: where(AuthKey.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<AuthKey>(
      where: where?.call(AuthKey.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
