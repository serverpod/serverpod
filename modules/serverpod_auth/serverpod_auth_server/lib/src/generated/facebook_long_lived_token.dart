/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a Facebook long-lived server token.
class FacebookLongLivedToken extends _i1.TableRow {
  FacebookLongLivedToken({
    int? id,
    required this.userId,
    required this.fbProfileId,
    required this.token,
    required this.expiresAt,
    required this.redirectUri,
  }) : super(id);

  factory FacebookLongLivedToken.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return FacebookLongLivedToken(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      fbProfileId: serializationManager
          .deserialize<String>(jsonSerialization['fbProfileId']),
      token:
          serializationManager.deserialize<String>(jsonSerialization['token']),
      expiresAt: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiresAt']),
      redirectUri: serializationManager
          .deserialize<String>(jsonSerialization['redirectUri']),
    );
  }

  static final t = FacebookLongLivedTokenTable();

  /// The Serverpod user id associated with the token.
  int userId;

  /// The Facebook profile id.
  String fbProfileId;

  /// The Facebook long-lived token.
  String token;

  /// The expiry date of the token.
  DateTime expiresAt;

  String redirectUri;

  @override
  String get tableName => 'serverpod_facebook_long_lived_token';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt,
      'redirectUri': redirectUri,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt,
      'redirectUri': redirectUri,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt,
      'redirectUri': redirectUri,
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
      case 'fbProfileId':
        fbProfileId = value;
        return;
      case 'token':
        token = value;
        return;
      case 'expiresAt':
        expiresAt = value;
        return;
      case 'redirectUri':
        redirectUri = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<FacebookLongLivedToken>> find(
    _i1.Session session, {
    FacebookLongLivedTokenExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FacebookLongLivedToken>(
      where: where != null ? where(FacebookLongLivedToken.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FacebookLongLivedToken?> findSingleRow(
    _i1.Session session, {
    FacebookLongLivedTokenExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<FacebookLongLivedToken>(
      where: where != null ? where(FacebookLongLivedToken.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FacebookLongLivedToken?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<FacebookLongLivedToken>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required FacebookLongLivedTokenExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FacebookLongLivedToken>(
      where: where(FacebookLongLivedToken.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    FacebookLongLivedTokenExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FacebookLongLivedToken>(
      where: where != null ? where(FacebookLongLivedToken.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef FacebookLongLivedTokenExpressionBuilder = _i1.Expression Function(
    FacebookLongLivedTokenTable);

class FacebookLongLivedTokenTable extends _i1.Table {
  FacebookLongLivedTokenTable()
      : super(tableName: 'serverpod_facebook_long_lived_token');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// The Serverpod user id associated with the token.
  final userId = _i1.ColumnInt('userId');

  /// The Facebook profile id.
  final fbProfileId = _i1.ColumnString('fbProfileId');

  /// The Facebook long-lived token.
  final token = _i1.ColumnString('token');

  /// The expiry date of the token.
  final expiresAt = _i1.ColumnDateTime('expiresAt');

  final redirectUri = _i1.ColumnString('redirectUri');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        fbProfileId,
        token,
        expiresAt,
        redirectUri,
      ];
}

@Deprecated('Use FacebookLongLivedTokenTable.t instead.')
FacebookLongLivedTokenTable tFacebookLongLivedToken =
    FacebookLongLivedTokenTable();
