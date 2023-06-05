/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:collection/collection.dart' as _i2;

typedef AuthKeyExpressionBuilder = _i1.Expression Function(AuthKeyTable);

/// Provides a method of access for a user to authenticate with the server.
abstract class AuthKey extends _i1.TableRow {
  const AuthKey._();

  const factory AuthKey({
    int? id,
    required int userId,
    required String hash,
    String? key,
    required List<String> scopeNames,
    required String method,
  }) = _AuthKey;

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

  static const t = AuthKeyTable();

  AuthKey copyWith({
    int? id,
    int? userId,
    String? hash,
    String? key,
    List<String>? scopeNames,
    String? method,
  });
  @override
  String get tableName => 'serverpod_auth_key';
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

  /// The id of the user to provide access to.
  int get userId;

  /// The hashed version of the key.
  String get hash;

  /// The key sent to the server to authenticate.
  String? get key;

  /// The scopes this key provides access to.
  List<String> get scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  String get method;
}

class _Undefined {}

/// Provides a method of access for a user to authenticate with the server.
class _AuthKey extends AuthKey {
  const _AuthKey({
    int? id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  }) : super._();

  /// The id of the user to provide access to.
  @override
  final int userId;

  /// The hashed version of the key.
  @override
  final String hash;

  /// The key sent to the server to authenticate.
  @override
  final String? key;

  /// The scopes this key provides access to.
  @override
  final List<String> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  @override
  final String method;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is AuthKey &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.hash,
                  hash,
                ) ||
                other.hash == hash) &&
            (identical(
                  other.key,
                  key,
                ) ||
                other.key == key) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method) &&
            const _i2.DeepCollectionEquality().equals(
              scopeNames,
              other.scopeNames,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        hash,
        key,
        method,
        const _i2.DeepCollectionEquality().hash(scopeNames),
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
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
      key: key == _Undefined ? this.key : (key as String?),
      scopeNames: scopeNames ?? this.scopeNames,
      method: method ?? this.method,
    );
  }
}

class AuthKeyTable extends _i1.Table {
  const AuthKeyTable() : super(tableName: 'serverpod_auth_key');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the user to provide access to.
  final userId = const _i1.ColumnInt('userId');

  /// The hashed version of the key.
  final hash = const _i1.ColumnString('hash');

  /// The scopes this key provides access to.
  final scopeNames = const _i1.ColumnSerializable('scopeNames');

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  final method = const _i1.ColumnString('method');

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
AuthKeyTable tAuthKey = const AuthKeyTable();
