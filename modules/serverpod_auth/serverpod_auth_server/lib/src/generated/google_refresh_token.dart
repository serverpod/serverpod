/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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

  static const db = GoogleRefreshTokenRepository._();

  /// The user id associated with the token.
  int userId;

  /// The token iteself.
  String refreshToken;

  @override
  _i1.Table get table => t;

  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  static GoogleRefreshTokenInclude include() {
    return GoogleRefreshTokenInclude._();
  }

  static GoogleRefreshTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    GoogleRefreshTokenInclude? include,
  }) {
    return GoogleRefreshTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      include: include,
    );
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
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class GoogleRefreshTokenTable extends _i1.Table {
  GoogleRefreshTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_google_refresh_token') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
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

class GoogleRefreshTokenInclude extends _i1.IncludeObject {
  GoogleRefreshTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => GoogleRefreshToken.t;
}

class GoogleRefreshTokenIncludeList extends _i1.IncludeList {
  GoogleRefreshTokenIncludeList._({
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GoogleRefreshToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => GoogleRefreshToken.t;
}

class GoogleRefreshTokenRepository {
  const GoogleRefreshTokenRepository._();

  Future<List<GoogleRefreshToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<GoogleRefreshToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<GoogleRefreshToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<GoogleRefreshToken>(
      id,
      transaction: transaction,
    );
  }

  Future<List<GoogleRefreshToken>> insert(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<GoogleRefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<GoogleRefreshToken> insertRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<GoogleRefreshToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<GoogleRefreshToken>> update(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.ColumnSelections<GoogleRefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<GoogleRefreshToken>(
      rows,
      columns: columns?.call(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  Future<GoogleRefreshToken> updateRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.ColumnSelections<GoogleRefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<GoogleRefreshToken>(
      row,
      columns: columns?.call(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<GoogleRefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<GoogleRefreshToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GoogleRefreshTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<GoogleRefreshToken>(
      where: where(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
