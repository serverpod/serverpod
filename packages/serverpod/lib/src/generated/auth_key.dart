/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Provides a method of access for a user to authenticate with the server.
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
  AuthKeyTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_auth_key') {
    id = _i1.ColumnInt(
      'id',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    userId = _i1.ColumnInt(
      'userId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    hash = _i1.ColumnString(
      'hash',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    method = _i1.ColumnString(
      'method',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  late final _i1.ColumnInt id;

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
  AuthKeyInclude();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => AuthKey.t;
}
