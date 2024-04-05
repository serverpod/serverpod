/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Database bindings for a Facebook long-lived server token.
abstract class FacebookLongLivedToken extends _i1.TableRow {
  FacebookLongLivedToken._({
    int? id,
    required this.userId,
    required this.fbProfileId,
    required this.token,
    required this.expiresAt,
  }) : super(id);

  factory FacebookLongLivedToken({
    int? id,
    required int userId,
    required String fbProfileId,
    required String token,
    required DateTime expiresAt,
  }) = _FacebookLongLivedTokenImpl;

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
    );
  }

  static final t = FacebookLongLivedTokenTable();

  static const db = FacebookLongLivedTokenRepository._();

  /// The Serverpod user id associated with the token.
  int userId;

  /// The Facebook profile id.
  String fbProfileId;

  /// The Facebook long-lived token.
  String token;

  /// The expiry date of the token.
  DateTime expiresAt;

  @override
  _i1.Table get table => t;

  FacebookLongLivedToken copyWith({
    int? id,
    int? userId,
    String? fbProfileId,
    String? token,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt.toJson(),
    };
  }

  static FacebookLongLivedTokenInclude include() {
    return FacebookLongLivedTokenInclude._();
  }

  static FacebookLongLivedTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacebookLongLivedTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookLongLivedTokenTable>? orderByList,
    FacebookLongLivedTokenInclude? include,
  }) {
    return FacebookLongLivedTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FacebookLongLivedToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FacebookLongLivedToken.t),
      include: include,
    );
  }
}

class _Undefined {}

class _FacebookLongLivedTokenImpl extends FacebookLongLivedToken {
  _FacebookLongLivedTokenImpl({
    int? id,
    required int userId,
    required String fbProfileId,
    required String token,
    required DateTime expiresAt,
  }) : super._(
          id: id,
          userId: userId,
          fbProfileId: fbProfileId,
          token: token,
          expiresAt: expiresAt,
        );

  @override
  FacebookLongLivedToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? fbProfileId,
    String? token,
    DateTime? expiresAt,
  }) {
    return FacebookLongLivedToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      fbProfileId: fbProfileId ?? this.fbProfileId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class FacebookLongLivedTokenTable extends _i1.Table {
  FacebookLongLivedTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_facebook_long_lived_token') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    fbProfileId = _i1.ColumnString(
      'fbProfileId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
  }

  /// The Serverpod user id associated with the token.
  late final _i1.ColumnInt userId;

  /// The Facebook profile id.
  late final _i1.ColumnString fbProfileId;

  /// The Facebook long-lived token.
  late final _i1.ColumnString token;

  /// The expiry date of the token.
  late final _i1.ColumnDateTime expiresAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        fbProfileId,
        token,
        expiresAt,
      ];
}

class FacebookLongLivedTokenInclude extends _i1.IncludeObject {
  FacebookLongLivedTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => FacebookLongLivedToken.t;
}

class FacebookLongLivedTokenIncludeList extends _i1.IncludeList {
  FacebookLongLivedTokenIncludeList._({
    _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FacebookLongLivedToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => FacebookLongLivedToken.t;
}

class FacebookLongLivedTokenRepository {
  const FacebookLongLivedTokenRepository._();

  Future<List<FacebookLongLivedToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacebookLongLivedTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookLongLivedTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FacebookLongLivedToken>(
      where: where?.call(FacebookLongLivedToken.t),
      orderBy: orderBy?.call(FacebookLongLivedToken.t),
      orderByList: orderByList?.call(FacebookLongLivedToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<FacebookLongLivedToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<FacebookLongLivedTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookLongLivedTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FacebookLongLivedToken>(
      where: where?.call(FacebookLongLivedToken.t),
      orderBy: orderBy?.call(FacebookLongLivedToken.t),
      orderByList: orderByList?.call(FacebookLongLivedToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<FacebookLongLivedToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FacebookLongLivedToken>(
      id,
      transaction: transaction,
    );
  }

  Future<List<FacebookLongLivedToken>> insert(
    _i1.Session session,
    List<FacebookLongLivedToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FacebookLongLivedToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<FacebookLongLivedToken> insertRow(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FacebookLongLivedToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<FacebookLongLivedToken>> update(
    _i1.Session session,
    List<FacebookLongLivedToken> rows, {
    _i1.ColumnSelections<FacebookLongLivedTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FacebookLongLivedToken>(
      rows,
      columns: columns?.call(FacebookLongLivedToken.t),
      transaction: transaction,
    );
  }

  Future<FacebookLongLivedToken> updateRow(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.ColumnSelections<FacebookLongLivedTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FacebookLongLivedToken>(
      row,
      columns: columns?.call(FacebookLongLivedToken.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<FacebookLongLivedToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FacebookLongLivedToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    FacebookLongLivedToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FacebookLongLivedToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FacebookLongLivedToken>(
      where: where(FacebookLongLivedToken.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookLongLivedTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FacebookLongLivedToken>(
      where: where?.call(FacebookLongLivedToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
