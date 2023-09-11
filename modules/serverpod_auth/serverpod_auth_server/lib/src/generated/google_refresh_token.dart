/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a Google refresh token.
abstract class GoogleRefreshToken extends _i1.TableRow {
  GoogleRefreshToken._({
    int? id,
    required this.userId,
    required this.refreshToken,
  }) : super(id);

  factory GoogleRefreshToken({
    int? id,
    required int userId,
    required String refreshToken,
  }) = _GoogleRefreshTokenImpl;

  factory GoogleRefreshToken.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return GoogleRefreshToken(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      refreshToken: serializationManager
          .deserialize<String>(jsonSerialization['refreshToken']),
    );
  }

  static final t = GoogleRefreshTokenTable();

  /// The user id associated with the token.
  int userId;

  /// The token iteself.
  String refreshToken;

  @override
  String get tableName => 'serverpod_google_refresh_token';
  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
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
      case 'refreshToken':
        refreshToken = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<GoogleRefreshToken>> find(
    _i1.Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<GoogleRefreshToken?> findSingleRow(
    _i1.Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<GoogleRefreshToken?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<GoogleRefreshToken>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required GoogleRefreshTokenExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GoogleRefreshToken>(
      where: where(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static GoogleRefreshTokenInclude include() {
    return GoogleRefreshTokenInclude._();
  }
}

class _Undefined {}

class _GoogleRefreshTokenImpl extends GoogleRefreshToken {
  _GoogleRefreshTokenImpl({
    int? id,
    required int userId,
    required String refreshToken,
  }) : super._(
          id: id,
          userId: userId,
          refreshToken: refreshToken,
        );

  @override
  GoogleRefreshToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? refreshToken,
  }) {
    return GoogleRefreshToken(
      id: id is! int? ? this.id : id,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

typedef GoogleRefreshTokenExpressionBuilder = _i1.Expression Function(
    GoogleRefreshTokenTable);

class GoogleRefreshTokenTable extends _i1.Table {
  GoogleRefreshTokenTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_google_refresh_token') {
    userId = _i1.ColumnInt(
      'userId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The user id associated with the token.
  late final _i1.ColumnInt userId;

  /// The token iteself.
  late final _i1.ColumnString refreshToken;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        refreshToken,
      ];
}

@Deprecated('Use GoogleRefreshTokenTable.t instead.')
GoogleRefreshTokenTable tGoogleRefreshToken = GoogleRefreshTokenTable();

class GoogleRefreshTokenInclude extends _i1.Include {
  GoogleRefreshTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => GoogleRefreshToken.t;
}
